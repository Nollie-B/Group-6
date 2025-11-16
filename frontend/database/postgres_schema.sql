-- PostgreSQL Schema for F2C Solutions Farm Management System
-- Converted from MySQL to PostgreSQL

-- Create database
CREATE DATABASE f2c_solutions;

-- Connect to the database
\c f2c_solutions;

-- =========================================================
-- USERS
-- =========================================================
DROP TABLE IF EXISTS users CASCADE;
CREATE TABLE users (
    users_id     BIGSERIAL PRIMARY KEY,
    name         VARCHAR(120) NOT NULL,
    email        VARCHAR(200) NOT NULL UNIQUE,
    password     VARCHAR(255) NOT NULL, -- Added for authentication
    farm_name    VARCHAR(150),
    phone        VARCHAR(20),
    address      TEXT,
    created_at   TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at   TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =========================================================
-- CATEGORIES
-- =========================================================
DROP TABLE IF EXISTS categories CASCADE;
CREATE TABLE categories (
    categories_id SERIAL PRIMARY KEY,
    name          VARCHAR(100) NOT NULL UNIQUE,
    description   TEXT,
    created_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =========================================================
-- UNITS
-- =========================================================
DROP TABLE IF EXISTS units CASCADE;
CREATE TABLE units (
    units_id    SERIAL PRIMARY KEY,
    name        VARCHAR(50) NOT NULL UNIQUE,
    symbol      VARCHAR(10),
    created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =========================================================
-- INVENTORY
-- =========================================================
DROP TABLE IF EXISTS inventory CASCADE;
CREATE TABLE inventory (
    inventory_id                    BIGSERIAL PRIMARY KEY,
    name                            VARCHAR(200) NOT NULL,
    quantity                        DECIMAL(12,3) NOT NULL DEFAULT 0,
    price                           DECIMAL(12,2) NOT NULL DEFAULT 0,
    cost                            DECIMAL(12,2) NOT NULL DEFAULT 0,
    expiry                          DATE NULL,
    reserved_qty                    DECIMAL(12,3) NOT NULL DEFAULT 0,
    minimum_stock                   DECIMAL(12,3) DEFAULT 0,
    maximum_stock                   DECIMAL(12,3),
    description                     TEXT,
    image_url                       VARCHAR(500),
    created_at                      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at                      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    users_users_id                  BIGINT NOT NULL REFERENCES users(users_id) ON DELETE RESTRICT,
    categories_categories_id        INT NOT NULL REFERENCES categories(categories_id) ON DELETE RESTRICT,
    units_units_id                  INT NOT NULL REFERENCES units(units_id) ON DELETE RESTRICT
);

CREATE INDEX idx_inventory_users ON inventory(users_users_id);
CREATE INDEX idx_inventory_categories ON inventory(categories_categories_id);
CREATE INDEX idx_inventory_units ON inventory(units_units_id);
CREATE INDEX idx_inventory_expiry ON inventory(expiry);
CREATE INDEX idx_inventory_low_stock ON inventory(minimum_stock, quantity);

-- =========================================================
-- SALES HISTORY
-- =========================================================
DROP TABLE IF EXISTS sales_history CASCADE;
CREATE TABLE sales_history (
    sales_history_id  BIGSERIAL PRIMARY KEY,
    product_name      VARCHAR(200) NOT NULL,
    quantity          DECIMAL(12,3) NOT NULL,
    price             DECIMAL(12,2) NOT NULL,
    cost              DECIMAL(12,2) NOT NULL DEFAULT 0,
    profit            DECIMAL(12,2) GENERATED ALWAYS AS (price - cost) STORED,
    date              TIMESTAMP NOT NULL,
    created_at        TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    users_users_id    BIGINT NOT NULL REFERENCES users(users_id) ON DELETE RESTRICT,
    inventory_id      BIGINT REFERENCES inventory(inventory_id)
);

CREATE INDEX idx_sales_history_users ON sales_history(users_users_id);
CREATE INDEX idx_sales_history_date ON sales_history(date);
CREATE INDEX idx_sales_history_inventory ON sales_history(inventory_id);

-- =========================================================
-- MARKETPLACE LISTINGS
-- =========================================================
DROP TABLE IF EXISTS marketplace_listings CASCADE;
CREATE TABLE marketplace_listings (
    marketplace_listings_id           BIGSERIAL PRIMARY KEY,
    name                               VARCHAR(200) NOT NULL,
    description                        TEXT,
    quantity                           DECIMAL(12,3) NOT NULL,
    price                              DECIMAL(12,2) NOT NULL,
    expiry                             DATE NULL,
    status                             VARCHAR(20) NOT NULL DEFAULT 'ACTIVE' CHECK (status IN ('ACTIVE','PENDING','SOLD','EXPIRED','CANCELLED')),
    created_at                         TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at                         TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    inventory_inventory_id             BIGINT NOT NULL REFERENCES inventory(inventory_id) ON DELETE RESTRICT,
    inventory_users_users_id           BIGINT NOT NULL REFERENCES users(users_id) ON DELETE RESTRICT,
    inventory_categories_categories_id INT NOT NULL REFERENCES categories(categories_id) ON DELETE RESTRICT,
    inventory_units_units_id           INT NOT NULL REFERENCES units(units_id) ON DELETE RESTRICT,
    users_users_id                     BIGINT NOT NULL REFERENCES users(users_id) ON DELETE RESTRICT
);

CREATE INDEX idx_marketplace_users ON marketplace_listings(users_users_id);
CREATE INDEX idx_marketplace_inventory ON marketplace_listings(inventory_inventory_id);
CREATE INDEX idx_marketplace_status ON marketplace_listings(status);
CREATE INDEX idx_marketplace_expiry ON marketplace_listings(expiry);

-- =========================================================
-- ORDERS
-- =========================================================
DROP TABLE IF EXISTS orders CASCADE;
CREATE TABLE orders (
    orders_id       BIGSERIAL PRIMARY KEY,
    order_number    VARCHAR(50) NOT NULL UNIQUE,
    customer_name   VARCHAR(200) NOT NULL,
    customer_email  VARCHAR(200) NOT NULL,
    customer_phone  VARCHAR(20),
    customer_address TEXT,
    total           DECIMAL(12,2) NOT NULL DEFAULT 0,
    status          VARCHAR(20) NOT NULL DEFAULT 'NEW' CHECK (status IN ('NEW','PAID','CANCELLED','FULFILLED','SHIPPED','DELIVERED')),
    payment_method  VARCHAR(50),
    payment_status  VARCHAR(20) DEFAULT 'PENDING',
    date            DATE NOT NULL,
    notes           TEXT,
    created_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    users_users_id  BIGINT NOT NULL REFERENCES users(users_id) ON DELETE RESTRICT
);

CREATE INDEX idx_orders_users ON orders(users_users_id);
CREATE INDEX idx_orders_status ON orders(status);
CREATE INDEX idx_orders_date ON orders(date);
CREATE INDEX idx_orders_customer ON orders(customer_email);

-- =========================================================
-- ORDER ITEMS
-- =========================================================
DROP TABLE IF EXISTS order_items CASCADE;
CREATE TABLE order_items (
    order_items_id                                         BIGSERIAL PRIMARY KEY,
    product_name                                           VARCHAR(200) NOT NULL,
    quantity                                               DECIMAL(12,3) NOT NULL,
    price                                                  DECIMAL(12,2) NOT NULL,
    subtotal                                               DECIMAL(12,2) NOT NULL,
    marketplace_listings_marketplace_listings_id           BIGINT NOT NULL REFERENCES marketplace_listings(marketplace_listings_id) ON DELETE RESTRICT,
    marketplace_listings_inventory_inventory_id            BIGINT NOT NULL REFERENCES inventory(inventory_id) ON DELETE RESTRICT,
    marketplace_listings_inventory_users_users_id          BIGINT NOT NULL REFERENCES users(users_id) ON DELETE RESTRICT,
    marketplace_listings_inventory_categories_categories_id INT NOT NULL REFERENCES categories(categories_id) ON DELETE RESTRICT,
    marketplace_listings_inventory_units_units_id          INT NOT NULL REFERENCES units(units_id) ON DELETE RESTRICT,
    marketplace_listings_users_users_id                    BIGINT NOT NULL REFERENCES users(users_id) ON DELETE RESTRICT,
    orders_orders_id                                       BIGINT NOT NULL REFERENCES orders(orders_id) ON DELETE CASCADE
);

CREATE INDEX idx_order_items_orders ON order_items(orders_orders_id);
CREATE INDEX idx_order_items_marketplace ON order_items(marketplace_listings_marketplace_listings_id);
CREATE INDEX idx_order_items_inventory ON order_items(marketplace_listings_inventory_inventory_id);

-- =========================================================
-- FUNCTIONS AND TRIGGERS
-- =========================================================

-- Function to update timestamps
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Triggers for updated_at
CREATE TRIGGER update_inventory_updated_at BEFORE UPDATE ON inventory
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_orders_updated_at BEFORE UPDATE ON orders
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_marketplace_updated_at BEFORE UPDATE ON marketplace_listings
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON users
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Function to update order total
CREATE OR REPLACE FUNCTION update_order_total()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE orders 
    SET total = COALESCE((SELECT SUM(subtotal) FROM order_items WHERE orders_orders_id = COALESCE(NEW.orders_orders_id, OLD.orders_orders_id)), 0)
    WHERE orders_id = COALESCE(NEW.orders_orders_id, OLD.orders_orders_id);
    RETURN COALESCE(NEW, OLD);
END;
$$ language 'plpgsql';

-- Trigger to update order total
CREATE TRIGGER update_order_total_trigger 
    AFTER INSERT OR UPDATE OR DELETE ON order_items
    FOR EACH ROW EXECUTE FUNCTION update_order_total();

-- Function to generate order numbers
CREATE OR REPLACE FUNCTION generate_order_number()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.order_number IS NULL THEN
        NEW.order_number = 'ORD-' || TO_CHAR(NOW(), 'YYYYMMDD') || '-' || LPAD(nextval('orders_orders_id_seq')::TEXT, 4, '0');
    END IF;
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Trigger to auto-generate order numbers
CREATE TRIGGER generate_order_number_trigger
    BEFORE INSERT ON orders
    FOR EACH ROW EXECUTE FUNCTION generate_order_number();