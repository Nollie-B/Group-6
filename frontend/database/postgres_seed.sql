-- PostgreSQL Seed Data for F2C Solutions
-- Sample data for development and testing

-- Clear existing data
TRUNCATE TABLE order_items, orders, marketplace_listings, sales_history, inventory, users, categories, units RESTART IDENTITY CASCADE;

-- =========================================================
-- USERS
-- =========================================================
INSERT INTO users (users_id, name, email, password, farm_name, phone, address, created_at, updated_at) VALUES
(1, 'Ava Mokoena', 'ava@greengrow.co.za', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewdBPj3xqG2X7XRO', 'GreenGrow Farms', '+27-82-123-4567', '123 Green Valley Road, Pretoria, Gauteng', NOW(), NOW()),
(2, 'Liam Naidoo', 'liam@freshroots.co.za', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewdBPj3xqG2X7XRO', 'FreshRoots Farm', '+27-83-987-6543', '456 Farm Lane, Durban, KwaZulu-Natal', NOW(), NOW()),
(3, 'Admin User', 'admin@f2csolutions.co.za', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewdBPj3xqG2X7XRO', 'F2C Solutions', '+27-11-555-0000', '1 Admin Street, Johannesburg, Gauteng', NOW(), NOW());

-- Note: All passwords are hashed (default: 'admin123')

-- =========================================================
-- CATEGORIES
-- =========================================================
INSERT INTO categories (categories_id, name, description, created_at) VALUES
(1, 'Vegetables', 'Fresh vegetables from local farms', NOW()),
(2, 'Fruits', 'Seasonal fruits and berries', NOW()),
(3, 'Dairy', 'Milk, cheese, and other dairy products', NOW()),
(4, 'Herbs', 'Fresh and dried herbs', NOW()),
(5, 'Grains', 'Rice, maize, wheat, and other grains', NOW()),
(6, 'Meat', 'Fresh meat and poultry', NOW());

-- =========================================================
-- UNITS
-- =========================================================
INSERT INTO units (units_id, name, symbol, created_at) VALUES
(1, 'kilogram', 'kg', NOW()),
(2, 'litre', 'l', NOW()),
(3, 'box', 'box', NOW()),
(4, 'piece', 'pc', NOW()),
(5, 'bundle', 'bundle', NOW()),
(6, 'pack', 'pack', NOW()),
(7, 'gram', 'g', NOW()),
(8, 'millilitre', 'ml', NOW());

-- =========================================================
-- INVENTORY
-- =========================================================
INSERT INTO inventory (
    inventory_id, name, quantity, price, cost, expiry, reserved_qty, 
    minimum_stock, maximum_stock, description, image_url,
    created_at, updated_at, users_users_id, categories_categories_id, units_units_id
) VALUES
-- Vegetables
(1, 'Fresh Potatoes', 200.000, 25.00, 15.00, '2025-12-31', 10.000, 20.000, 500.000, 'Premium grade potatoes, perfect for cooking', NULL, NOW(), NOW(), 1, 1, 1),
(2, 'Organic Carrots', 150.000, 30.00, 18.00, '2025-12-15', 5.000, 15.000, 300.000, 'Fresh organic carrots, rich in vitamins', NULL, NOW(), NOW(), 1, 1, 1),
(3, 'Cherry Tomatoes', 80.000, 45.00, 28.00, '2025-11-20', 0.000, 10.000, 150.000, 'Sweet cherry tomatoes, perfect for salads', NULL, NOW(), NOW(), 2, 1, 3),
(4, 'Fresh Spinach', 50.000, 35.00, 22.00, '2025-11-18', 2.000, 8.000, 100.000, 'Organic spinach leaves, nutrient-rich', NULL, NOW(), NOW(), 1, 1, 5),

-- Fruits
(5, 'Fresh Apples', 120.000, 45.00, 25.00, '2025-11-30', 0.000, 20.000, 250.000, 'Crisp and juicy red apples', NULL, NOW(), NOW(), 2, 2, 3),
(6, 'Strawberries', 25.000, 65.00, 40.00, '2025-11-16', 0.000, 5.000, 50.000, 'Sweet and fresh strawberries', NULL, NOW(), NOW(), 1, 2, 3),
(7, 'Orange Juice Oranges', 300.000, 12.00, 8.00, '2025-12-05', 0.000, 50.000, 600.000, 'Perfect for fresh juice extraction', NULL, NOW(), NOW(), 2, 2, 1),

-- Dairy
(8, 'Fresh Milk', 60.000, 18.00, 10.00, '2025-11-05', 0.000, 10.000, 100.000, 'Farm-fresh milk, pasteurized', NULL, NOW(), NOW(), 2, 3, 2),
(9, 'Artisan Cheese', 15.000, 85.00, 50.00, '2025-12-01', 0.000, 5.000, 30.000, 'Handcrafted artisan cheese', NULL, NOW(), NOW(), 1, 3, 3),
(10, 'Yogurt', 40.000, 22.00, 15.00, '2025-11-12', 0.000, 8.000, 80.000, 'Natural probiotic yogurt', NULL, NOW(), NOW(), 2, 3, 3),

-- Herbs
(11, 'Fresh Basil', 5.000, 40.00, 25.00, '2025-11-14', 0.000, 1.000, 15.000, 'Aromatic fresh basil leaves', NULL, NOW(), NOW(), 1, 4, 5),
(12, 'Dried Oregano', 3.000, 55.00, 35.00, '2026-11-14', 0.000, 1.000, 10.000, 'Dried oregano for seasoning', NULL, NOW(), NOW(), 1, 4, 6);

-- =========================================================
-- SALES HISTORY
-- =========================================================
INSERT INTO sales_history (
    sales_history_id, product_name, quantity, price, cost, date, created_at, users_users_id, inventory_id
) VALUES
(1, 'Fresh Potatoes', 10.000, 25.00, 15.00, NOW() - INTERVAL '3 days', NOW(), 1, 1),
(2, 'Organic Carrots', 8.000, 30.00, 18.00, NOW() - INTERVAL '2 days', NOW(), 1, 2),
(3, 'Fresh Apples', 5.000, 45.00, 25.00, NOW() - INTERVAL '1 day', NOW(), 2, 5),
(4, 'Fresh Milk', 2.000, 18.00, 10.00, NOW() - INTERVAL '1 day', NOW(), 2, 8),
(5, 'Cherry Tomatoes', 3.000, 45.00, 28.00, NOW() - INTERVAL '1 day', NOW(), 1, 3),
(6, 'Fresh Spinach', 2.000, 35.00, 22.00, NOW() - INTERVAL '4 hours', NOW(), 1, 4);

-- =========================================================
-- MARKETPLACE LISTINGS
-- =========================================================
INSERT INTO marketplace_listings (
    marketplace_listings_id, name, description, quantity, price, expiry, status, created_at, updated_at,
    inventory_inventory_id, inventory_users_users_id,
    inventory_categories_categories_id, inventory_units_units_id, users_users_id
) VALUES
(1, 'Premium Fresh Potatoes', 'High-quality potatoes perfect for chips and roasting', 50.000, 27.00, '2025-12-01', 'ACTIVE', NOW(), NOW(), 1, 1, 1, 1, 1),
(2, 'Organic Sweet Carrots', 'Fresh organic carrots, sweet and crunchy', 30.000, 32.00, '2025-12-05', 'ACTIVE', NOW(), NOW(), 2, 1, 1, 1, 1),
(3, 'Red Apples Bundle', 'Fresh red apples, perfect for snacking', 25.000, 46.00, '2025-11-15', 'ACTIVE', NOW(), NOW(), 5, 2, 2, 3, 2),
(4, 'Fresh Farm Milk', 'Pure farm-fresh milk in 1L bottles', 20.000, 20.00, '2025-11-02', 'ACTIVE', NOW(), NOW(), 8, 2, 3, 2, 2),
(5, 'Cherry Tomatoes Box', 'Sweet cherry tomatoes in 1kg box', 15.000, 48.00, '2025-11-18', 'ACTIVE', NOW(), NOW(), 3, 1, 1, 3, 1),
(6, 'Strawberry Pack', 'Fresh strawberries, perfect for desserts', 8.000, 70.00, '2025-11-14', 'ACTIVE', NOW(), NOW(), 6, 1, 2, 3, 1),
(7, 'Artisan Cheese Wedge', 'Handcrafted cheese, 500g wedge', 5.000, 90.00, '2025-11-28', 'ACTIVE', NOW(), NOW(), 9, 1, 3, 3, 1),
(8, 'Fresh Basil Bundle', 'Aromatic basil leaves for cooking', 2.000, 45.00, '2025-11-12', 'ACTIVE', NOW(), NOW(), 11, 1, 4, 5, 1);

-- =========================================================
-- ORDERS
-- =========================================================
INSERT INTO orders (
    orders_id, order_number, customer_name, customer_email, customer_phone, customer_address,
    total, status, payment_method, payment_status, date, notes, created_at, updated_at, users_users_id
) VALUES
(1, NULL, 'John Smith', 'john.smith@email.com', '+27-82-555-1234', '789 Customer Street, Cape Town', 135.00, 'PAID', 'CREDIT_CARD', 'COMPLETED', '2025-10-26', 'Standard delivery', NOW(), NOW(), 1),
(2, NULL, 'Sarah Johnson', 'sarah.j@email.com', '+27-84-987-6543', '456 Client Avenue, Bloemfontein', 138.00, 'FULFILLED', 'BANK_TRANSFER', 'COMPLETED', '2025-10-25', 'Express delivery requested', NOW(), NOW(), 2),
(3, NULL, 'Mike Wilson', 'mike.wilson@email.com', '+27-83-444-7890', '321 Buyer Lane, Port Elizabeth', 200.00, 'SHIPPED', 'CREDIT_CARD', 'COMPLETED', '2025-11-14', 'Large order - wholesale pricing', NOW(), NOW(), 1),
(4, NULL, 'Emma Davis', 'emma.davis@email.com', '+27-82-777-8888', '654 Purchase Road, East London', 75.00, 'NEW', 'CASH_ON_DELIVERY', 'PENDING', '2025-11-15', 'First-time customer', NOW(), NOW(), 2);

-- =========================================================
-- ORDER ITEMS
-- =========================================================
INSERT INTO order_items (
    order_items_id, product_name, quantity, price, subtotal,
    marketplace_listings_marketplace_listings_id,
    marketplace_listings_inventory_inventory_id,
    marketplace_listings_inventory_users_users_id,
    marketplace_listings_inventory_categories_categories_id,
    marketplace_listings_inventory_units_units_id,
    marketplace_listings_users_users_id,
    orders_orders_id
) VALUES
-- Order 1 items (Potatoes, Carrots)
(1, 'Premium Fresh Potatoes', 5.000, 27.00, 135.00, 1, 1, 1, 1, 1, 1, 1),
(2, 'Organic Sweet Carrots', 3.000, 32.00, 96.00, 2, 2, 1, 1, 1, 1, 1),

-- Order 2 items (Apples, Milk)  
(3, 'Red Apples Bundle', 2.000, 46.00, 92.00, 3, 5, 2, 2, 3, 2, 2),
(4, 'Fresh Farm Milk', 2.000, 20.00, 40.00, 4, 8, 2, 3, 2, 2, 2),

-- Order 3 items (multiple items)
(5, 'Premium Fresh Potatoes', 8.000, 27.00, 216.00, 1, 1, 1, 1, 1, 1, 3),
(6, 'Cherry Tomatoes Box', 2.000, 48.00, 96.00, 5, 3, 1, 1, 3, 1, 3),

-- Order 4 items (new customer)
(7, 'Fresh Basil Bundle', 1.000, 45.00, 45.00, 8, 11, 1, 4, 5, 1, 4),
(8, 'Strawberry Pack', 1.000, 70.00, 70.00, 6, 6, 1, 2, 3, 1, 4);

-- Update the totals for existing orders
UPDATE orders SET total = (SELECT SUM(subtotal) FROM order_items WHERE orders_orders_id = orders.orders_id);

-- Show summary of seeded data
SELECT 'Seed data created successfully!' as message;