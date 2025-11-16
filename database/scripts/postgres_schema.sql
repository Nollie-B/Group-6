-- F2C Solutions PostgreSQL Database Schema
-- Farm-to-Consumer Farm Management System

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Create custom types
CREATE TYPE user_role AS ENUM ('admin', 'farmer', 'customer');
CREATE TYPE user_status AS ENUM ('active', 'inactive', 'pending');
CREATE TYPE order_status AS ENUM ('new', 'paid', 'shipped', 'delivered', 'cancelled');
CREATE TYPE payment_status AS ENUM ('pending', 'completed', 'failed', 'refunded');
CREATE TYPE product_status AS ENUM ('active', 'out_of_stock', 'discontinued');

-- Users table
CREATE TABLE users (
    users_id BIGSERIAL PRIMARY KEY,
    name VARCHAR(120) NOT NULL,
    email VARCHAR(200) UNIQUE NOT NULL,
    phone VARCHAR(20),
    address TEXT,
    password_hash VARCHAR(255),
    role user_role DEFAULT 'customer' NOT NULL,
    status user_status DEFAULT 'pending' NOT NULL,
    profile_image VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Categories table
CREATE TABLE categories (
    category_id BIGSERIAL PRIMARY KEY,
    name VARCHAR(100) UNIQUE NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Units table
CREATE TABLE units (
    unit_id BIGSERIAL PRIMARY KEY,
    name VARCHAR(50) UNIQUE NOT NULL,
    symbol VARCHAR(10) NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Inventory table
CREATE TABLE inventory (
    item_id BIGSERIAL PRIMARY KEY,
    name VARCHAR(120) NOT NULL,
    description TEXT,
    quantity NUMERIC(10,2) NOT NULL DEFAULT 0,
    price NUMERIC(10,2) NOT NULL DEFAULT 0,
    unit_id BIGINT NOT NULL REFERENCES units(unit_id),
    category_id BIGINT NOT NULL REFERENCES categories(category_id),
    user_id BIGINT NOT NULL REFERENCES users(users_id),
    image_url VARCHAR(255),
    expiry_date DATE,
    production_date DATE,
    status product_status DEFAULT 'active' NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Marketplace listings table
CREATE TABLE marketplace_listings (
    listing_id BIGSERIAL PRIMARY KEY,
    inventory_item_id BIGINT NOT NULL REFERENCES inventory(item_id) ON DELETE CASCADE,
    price NUMERIC(10,2) NOT NULL,
    quantity NUMERIC(10,2) NOT NULL,
    description TEXT,
    images JSON,
    status VARCHAR(20) DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Orders table
CREATE TABLE orders (
    order_id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL REFERENCES users(users_id),
    total_amount NUMERIC(10,2) NOT NULL DEFAULT 0,
    status order_status DEFAULT 'new' NOT NULL,
    payment_status payment_status DEFAULT 'pending' NOT NULL,
    shipping_address TEXT NOT NULL,
    shipping_date DATE,
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Order items table
CREATE TABLE order_items (
    item_id BIGSERIAL PRIMARY KEY,
    order_id BIGINT NOT NULL REFERENCES orders(order_id) ON DELETE CASCADE,
    inventory_item_id BIGINT NOT NULL REFERENCES inventory(item_id),
    quantity NUMERIC(10,2) NOT NULL,
    unit_price NUMERIC(10,2) NOT NULL,
    total_price NUMERIC(10,2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Sales history table (for analytics)
CREATE TABLE sales_history (
    sale_id BIGSERIAL PRIMARY KEY,
    order_item_id BIGINT REFERENCES order_items(item_id),
    date DATE NOT NULL,
    revenue NUMERIC(10,2) NOT NULL,
    quantity NUMERIC(10,2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create indexes for better performance
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_role ON users(role);
CREATE INDEX idx_users_status ON users(status);

CREATE INDEX idx_inventory_user_id ON inventory(user_id);
CREATE INDEX idx_inventory_category_id ON inventory(category_id);
CREATE INDEX idx_inventory_status ON inventory(status);
CREATE INDEX idx_inventory_expiry_date ON inventory(expiry_date);
CREATE INDEX idx_inventory_user_status ON inventory(user_id, status);

CREATE INDEX idx_marketplace_inventory_item_id ON marketplace_listings(inventory_item_id);
CREATE INDEX idx_marketplace_status ON marketplace_listings(status);

CREATE INDEX idx_orders_user_id ON orders(user_id);
CREATE INDEX idx_orders_status ON orders(status);
CREATE INDEX idx_orders_created_at ON orders(created_at);

CREATE INDEX idx_order_items_order_id ON order_items(order_id);
CREATE INDEX idx_order_items_inventory_item_id ON order_items(inventory_item_id);

CREATE INDEX idx_sales_history_date ON sales_history(date);

-- Function to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Triggers for updated_at
CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON users
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_inventory_updated_at BEFORE UPDATE ON inventory
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_marketplace_listings_updated_at BEFORE UPDATE ON marketplace_listings
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_orders_updated_at BEFORE UPDATE ON orders
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Function to calculate order total
CREATE OR REPLACE FUNCTION calculate_order_total()
RETURNS TRIGGER AS $$
DECLARE
    order_total NUMERIC(10,2) := 0;
BEGIN
    -- Calculate total for this order
    SELECT COALESCE(SUM(total_price), 0) INTO order_total
    FROM order_items
    WHERE order_id = NEW.order_id;
    
    -- Update order total
    UPDATE orders
    SET total_amount = order_total
    WHERE order_id = NEW.order_id;
    
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Trigger to update order total when order items change
CREATE TRIGGER trigger_calculate_order_total
    AFTER INSERT OR UPDATE OR DELETE ON order_items
    FOR EACH ROW EXECUTE FUNCTION calculate_order_total();

-- Function to record sales history
CREATE OR REPLACE FUNCTION record_sales_history()
RETURNS TRIGGER AS $$
BEGIN
    -- Record sales history when order is completed
    IF TG_OP = 'INSERT' AND NEW.status = 'delivered' THEN
        INSERT INTO sales_history (order_item_id, date, revenue, quantity)
        SELECT NEW.item_id, CURRENT_DATE, NEW.total_price, NEW.quantity
        FROM order_items
        WHERE item_id = NEW.item_id;
    END IF;
    
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Trigger to record sales when order status changes to delivered
CREATE TRIGGER trigger_record_sales_history
    AFTER UPDATE ON orders
    FOR EACH ROW EXECUTE FUNCTION record_sales_history();

-- Function to check stock availability
CREATE OR REPLACE FUNCTION check_stock_availability(order_item_id_param BIGINT, requested_quantity NUMERIC)
RETURNS BOOLEAN AS $$
DECLARE
    available_quantity NUMERIC;
BEGIN
    SELECT quantity INTO available_quantity
    FROM inventory
    WHERE item_id = (
        SELECT inventory_item_id FROM order_items WHERE item_id = order_item_id_param
    );
    
    RETURN COALESCE(available_quantity, 0) >= requested_quantity;
END;
$$ language 'plpgsql';

-- Comments for documentation
COMMENT ON TABLE users IS 'User accounts for farmers, customers, and administrators';
COMMENT ON TABLE categories IS 'Product categories for organizing inventory';
COMMENT ON TABLE units IS 'Units of measurement for products';
COMMENT ON TABLE inventory IS 'Farm inventory items and products';
COMMENT ON TABLE marketplace_listings IS 'Public marketplace listings from inventory';
COMMENT ON TABLE orders IS 'Customer orders for products';
COMMENT ON TABLE order_items IS 'Individual items within orders';
COMMENT ON TABLE sales_history IS 'Historical sales data for analytics';

COMMENT ON COLUMN users.role IS 'User role: admin, farmer, or customer';
COMMENT ON COLUMN users.status IS 'User account status';
COMMENT ON COLUMN inventory.quantity IS 'Available quantity in stock';
COMMENT ON COLUMN inventory.status IS 'Product status: active, out_of_stock, or discontinued';
COMMENT ON COLUMN orders.status IS 'Order status progression: new -> paid -> shipped -> delivered';
COMMENT ON COLUMN orders.payment_status IS 'Payment processing status';
COMMENT ON COLUMN order_items.total_price IS 'Quantity * unit_price for this line item';