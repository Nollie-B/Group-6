-- F2C Solutions PostgreSQL Seed Data
-- Sample data for development and testing

-- Insert default categories
INSERT INTO categories (name, description) VALUES
('Vegetables', 'Fresh vegetables from local farms'),
('Fruits', 'Seasonal fruits and berries'),
('Herbs', 'Fresh herbs and spices'),
('Dairy', 'Farm fresh dairy products'),
('Eggs', 'Free-range eggs'),
('Meat', 'Grass-fed meat products'),
('Grains', 'Organic grains and cereals'),
('Honey', 'Local honey and bee products'),
('Nuts', 'Assorted nuts and seeds'),
('Spices', 'Ground and whole spices'),
('Flowers', 'Cut flowers and ornamental plants'),
('Mushrooms', 'Fresh and dried mushrooms');

-- Insert default units
INSERT INTO units (name, symbol, description) VALUES
('Kilogram', 'kg', 'Standard weight unit (1000 grams)'),
('Gram', 'g', 'Small weight unit'),
('Liter', 'l', 'Liquid volume unit'),
('Milliliter', 'ml', 'Small liquid volume unit'),
('Piece', 'pcs', 'Individual items (count)'),
('Dozen', 'doz', 'Twelve pieces'),
('Bunch', 'bunch', 'Agricultural bunch (variable items)'),
('Head', 'head', 'Whole heads (lettuce, cabbage)'),
('Bundle', 'bundle', 'Tied bundles (herbs, flowers)'),
('Box', 'box', 'Packaged boxes'),
('Sack', 'sack', 'Large agricultural sacks'),
('Tray', 'tray', 'Standard agricultural trays');

-- Insert admin user
INSERT INTO users (name, email, phone, address, password_hash, role, status) VALUES
('Admin User', 'admin@f2csolutions.co.za', '+27123456789', '123 Admin Street, Cape Town, South Africa', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewdBPj9xL5X4b.2.', 'admin', 'active');

-- Insert sample farmer
INSERT INTO users (name, email, phone, address, password_hash, role, status) VALUES
('Ava Mokoena', 'ava.mokoena@farm.co.za', '+27123456780', 'Farm Road 456, Stellenbosch, Western Cape, South Africa', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewdBPj9xL5X4b.2.', 'farmer', 'active'),
('Thabo Mthembu', 'thabo.mthembu@farm.co.za', '+27123456781', 'Valley View Farm, Paarl, Western Cape, South Africa', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewdBPj9xL5X4b.2.', 'farmer', 'active'),
('Nomsa Dlamini', 'nomsa.dlamini@organic.co.za', '+27123456782', 'Green Valley Organic Farm, Hermanus, Western Cape, South Africa', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewdBPj9xL5X4b.2.', 'farmer', 'active');

-- Insert sample customers
INSERT INTO users (name, email, phone, address, password_hash, role, status) VALUES
('Liam Naidoo', 'liam.naidoo@email.com', '+27123456783', '789 Customer Avenue, Johannesburg, Gauteng, South Africa', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewdBPj9xL5X4b.2.', 'customer', 'active'),
('Zara Khan', 'zara.khan@email.com', '+27123456784', '456 Suburb Lane, Durban, KwaZulu-Natal, South Africa', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewdBPj9xL5X4b.2.', 'customer', 'active'),
('Michael van der Merwe', 'michael.vdm@email.com', '+27123456785', '321 Estate Road, Pretoria, Gauteng, South Africa', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewdBPj9xL5X4b.2.', 'customer', 'active'),
('Amara Okafor', 'amara.okafor@email.com', '+27123456786', '654 Garden Street, Port Elizabeth, Eastern Cape, South Africa', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewdBPj9xL5X4b.2.', 'customer', 'active');

-- Get references for inventory items
DO $$
DECLARE
    farmer_id_ava BIGINT;
    farmer_id_thabo BIGINT;
    farmer_id_nomsa BIGINT;
    
    veg_cat_id BIGINT;
    fruit_cat_id BIGINT;
    herb_cat_id BIGINT;
    egg_cat_id BIGINT;
    dairy_cat_id BIGINT;
    meat_cat_id BIGINT;
    grain_cat_id BIGINT;
    honey_cat_id BIGINT;
    
    kg_unit_id BIGINT;
    gram_unit_id BIGINT;
    liter_unit_id BIGINT;
    piece_unit_id BIGINT;
    dozen_unit_id BIGINT;
    bunch_unit_id BIGINT;
    box_unit_id BIGINT;
    tray_unit_id BIGINT;
BEGIN
    -- Get user IDs
    SELECT users_id INTO farmer_id_ava FROM users WHERE email = 'ava.mokoena@farm.co.za';
    SELECT users_id INTO farmer_id_thabo FROM users WHERE email = 'thabo.mthembu@farm.co.za';
    SELECT users_id INTO farmer_id_nomsa FROM users WHERE email = 'nomsa.dlamini@organic.co.za';
    
    -- Get category IDs
    SELECT category_id INTO veg_cat_id FROM categories WHERE name = 'Vegetables';
    SELECT category_id INTO fruit_cat_id FROM categories WHERE name = 'Fruits';
    SELECT category_id INTO herb_cat_id FROM categories WHERE name = 'Herbs';
    SELECT category_id INTO egg_cat_id FROM categories WHERE name = 'Eggs';
    SELECT category_id INTO dairy_cat_id FROM categories WHERE name = 'Dairy';
    SELECT category_id INTO meat_cat_id FROM categories WHERE name = 'Meat';
    SELECT category_id INTO grain_cat_id FROM categories WHERE name = 'Grains';
    SELECT category_id INTO honey_cat_id FROM categories WHERE name = 'Honey';
    
    -- Get unit IDs
    SELECT unit_id INTO kg_unit_id FROM units WHERE symbol = 'kg';
    SELECT unit_id INTO gram_unit_id FROM units WHERE symbol = 'g';
    SELECT unit_id INTO liter_unit_id FROM units WHERE symbol = 'l';
    SELECT unit_id INTO piece_unit_id FROM units WHERE symbol = 'pcs';
    SELECT unit_id INTO dozen_unit_id FROM units WHERE symbol = 'doz';
    SELECT unit_id INTO bunch_unit_id FROM units WHERE symbol = 'bunch';
    SELECT unit_id INTO box_unit_id FROM units WHERE symbol = 'box';
    SELECT unit_id INTO tray_unit_id FROM units WHERE symbol = 'tray';
    
    -- Insert inventory items for Ava Mokoena
    INSERT INTO inventory (name, description, quantity, price, unit_id, category_id, user_id, production_date, expiry_date) VALUES
    ('Organic Tomatoes', 'Fresh organic tomatoes grown without pesticides', 50.0, 25.50, kg_unit_id, veg_cat_id, farmer_id_ava, CURRENT_DATE - INTERVAL '3 days', CURRENT_DATE + INTERVAL '7 days'),
    ('Fresh Lettuce', 'Crisp lettuce heads, perfect for salads', 30.0, 15.00, piece_unit_id, veg_cat_id, farmer_id_ava, CURRENT_DATE - INTERVAL '2 days', CURRENT_DATE + INTERVAL '6 days'),
    ('Spinach', 'Baby spinach leaves, tender and sweet', 25.0, 35.00, gram_unit_id, veg_cat_id, farmer_id_ava, CURRENT_DATE - INTERVAL '1 day', CURRENT_DATE + INTERVAL '5 days'),
    ('Strawberries', 'Sweet, juicy strawberries picked fresh', 25.0, 45.00, gram_unit_id, fruit_cat_id, farmer_id_ava, CURRENT_DATE - INTERVAL '1 day', CURRENT_DATE + INTERVAL '3 days'),
    ('Fresh Basil', 'Aromatic basil leaves for cooking', 15.0, 12.00, bunch_unit_id, herb_cat_id, farmer_id_ava, CURRENT_DATE - INTERVAL '1 day', CURRENT_DATE + INTERVAL '7 days'),
    ('Free-range Eggs', 'Farm fresh eggs from free-range chickens', 120.0, 8.00, dozen_unit_id, egg_cat_id, farmer_id_ava, CURRENT_DATE - INTERVAL '2 days', CURRENT_DATE + INTERVAL '28 days'),
    ('Bell Peppers', 'Colorful bell peppers, red and yellow varieties', 20.0, 32.00, kg_unit_id, veg_cat_id, farmer_id_ava, CURRENT_DATE - INTERVAL '2 days', CURRENT_DATE + INTERVAL '10 days'),
    ('Avocados', 'Perfectly ripe avocados, creamy and rich', 40.0, 8.50, piece_unit_id, fruit_cat_id, farmer_id_ava, CURRENT_DATE - INTERVAL '3 days', CURRENT_DATE + INTERVAL '5 days');
    
    -- Insert inventory items for Thabo Mthembu
    INSERT INTO inventory (name, description, quantity, price, unit_id, category_id, user_id, production_date, expiry_date) VALUES
    ('Chicken Eggs', 'Fresh chicken eggs from pasture-raised hens', 150.0, 9.50, dozen_unit_id, egg_cat_id, farmer_id_thabo, CURRENT_DATE - INTERVAL '1 day', CURRENT_DATE + INTERVAL '30 days'),
    ('Honey', 'Raw wildflower honey, unfiltered and pure', 15.0, 85.00, liter_unit_id, honey_cat_id, farmer_id_thabo, CURRENT_DATE - INTERVAL '30 days', CURRENT_DATE + INTERVAL '365 days'),
    ('Potatoes', 'Fresh potatoes, perfect for roasting and mashing', 200.0, 12.00, kg_unit_id, veg_cat_id, farmer_id_thabo, CURRENT_DATE - INTERVAL '5 days', CURRENT_DATE + INTERVAL '60 days'),
    ('Onions', 'Yellow onions, essential for cooking', 80.0, 18.00, kg_unit_id, veg_cat_id, farmer_id_thabo, CURRENT_DATE - INTERVAL '7 days', CURRENT_DATE + INTERVAL '90 days'),
    ('Carrots', 'Sweet baby carrots, crisp and crunchy', 60.0, 22.00, kg_unit_id, veg_cat_id, farmer_id_thabo, CURRENT_DATE - INTERVAL '2 days', CURRENT_DATE + INTERVAL '21 days'),
    ('Goat Milk', 'Fresh goat milk, creamy and nutritious', 25.0, 45.00, liter_unit_id, dairy_cat_id, farmer_id_thabo, CURRENT_DATE - INTERVAL '1 day', CURRENT_DATE + INTERVAL '5 days'),
    ('Fresh Garlic', 'Garlic bulbs, strong flavor for cooking', 30.0, 55.00, kg_unit_id, veg_cat_id, farmer_id_thabo, CURRENT_DATE - INTERVAL '3 days', CURRENT_DATE + INTERVAL '120 days'),
    ('Beef Sausages', 'Homemade beef sausages, spices and herbs', 25.0, 75.00, kg_unit_id, meat_cat_id, farmer_id_thabo, CURRENT_DATE - INTERVAL '2 days', CURRENT_DATE + INTERVAL '7 days');
    
    -- Insert inventory items for Nomsa Dlamini (Organic specialist)
    INSERT INTO inventory (name, description, quantity, price, unit_id, category_id, user_id, production_date, expiry_date) VALUES
    ('Organic Kale', 'Dark leafy kale, nutrient-dense and fresh', 20.0, 42.00, kg_unit_id, veg_cat_id, farmer_id_nomsa, CURRENT_DATE - INTERVAL '1 day', CURRENT_DATE + INTERVAL '8 days'),
    ('Organic Apples', 'Crisp apples from pesticide-free trees', 100.0, 35.00, kg_unit_id, fruit_cat_id, farmer_id_nomsa, CURRENT_DATE - INTERVAL '3 days', CURRENT_DATE + INTERVAL '45 days'),
    ('Organic Quinoa', 'Premium organic quinoa grains, high protein', 40.0, 125.00, kg_unit_id, grain_cat_id, farmer_id_nomsa, CURRENT_DATE - INTERVAL '10 days', CURRENT_DATE + INTERVAL '365 days'),
    ('Fresh Rosemary', 'Aromatic rosemary sprigs, perfect for roasting', 12.0, 15.00, bunch_unit_id, herb_cat_id, farmer_id_nomsa, CURRENT_DATE - INTERVAL '2 days', CURRENT_DATE + INTERVAL '10 days'),
    ('Organic Chia Seeds', 'Superfood chia seeds, rich in omega-3', 5.0, 185.00, kg_unit_id, grain_cat_id, farmer_id_nomsa, CURRENT_DATE - INTERVAL '15 days', CURRENT_DATE + INTERVAL '730 days'),
    ('Fresh Oregano', 'Strong oregano leaves for Mediterranean cooking', 8.0, 18.00, bunch_unit_id, herb_cat_id, farmer_id_nomsa, CURRENT_DATE - INTERVAL '2 days', CURRENT_DATE + INTERVAL '8 days'),
    ('Organic Mushrooms', 'Fresh button mushrooms, cultivated organically', 30.0, 65.00, kg_unit_id, veg_cat_id, farmer_id_nomsa, CURRENT_DATE - INTERVAL '1 day', CURRENT_DATE + INTERVAL '5 days'),
    ('Organic Tomatoes (Cherry)', 'Sweet cherry tomatoes, perfect for salads', 15.0, 38.00, kg_unit_id, veg_cat_id, farmer_id_nomsa, CURRENT_DATE - INTERVAL '1 day', CURRENT_DATE + INTERVAL '6 days'),
    ('Fresh Parsley', 'Bright green parsley, great for garnishes', 10.0, 14.00, bunch_unit_id, herb_cat_id, farmer_id_nomsa, CURRENT_DATE - INTERVAL '1 day', CURRENT_DATE + INTERVAL '5 days'),
    ('Organic Spinach (Baby)', 'Tender baby spinach leaves', 12.0, 48.00, kg_unit_id, veg_cat_id, farmer_id_nomsa, CURRENT_DATE - INTERVAL '1 day', CURRENT_DATE + INTERVAL '4 days');

END $$;

-- Insert sample orders
DO $$
DECLARE
    customer_liam BIGINT;
    customer_zara BIGINT;
    customer_michael BIGINT;
    customer_amara BIGINT;
    order_id_1 BIGINT;
    order_id_2 BIGINT;
    order_id_3 BIGINT;
    
    inventory_tomatoes BIGINT;
    inventory_eggs BIGINT;
    inventory_strawberries BIGINT;
    inventory_bell_peppers BIGINT;
    inventory_organic_kale BIGINT;
    inventory_fresh_basil BIGINT;
    inventory_organic_apples BIGINT;
    inventory_honey BIGINT;
BEGIN
    -- Get customer IDs
    SELECT users_id INTO customer_liam FROM users WHERE email = 'liam.naidoo@email.com';
    SELECT users_id INTO customer_zara FROM users WHERE email = 'zara.khan@email.com';
    SELECT users_id INTO customer_michael FROM users WHERE email = 'michael.vdm@email.com';
    SELECT users_id INTO customer_amara FROM users WHERE email = 'amara.okafor@email.com';
    
    -- Create sample orders
    INSERT INTO orders (user_id, total_amount, status, payment_status, shipping_address, notes) VALUES
    (customer_liam, 215.75, 'delivered', 'completed', '789 Customer Avenue, Johannesburg, Gauteng, South Africa', 'Please deliver in the morning'),
    (customer_zara, 156.50, 'shipped', 'completed', '456 Suburb Lane, Durban, KwaZulu-Natal, South Africa', 'Handle with care'),
    (customer_michael, 89.25, 'paid', 'completed', '321 Estate Road, Pretoria, Gauteng, South Africa', NULL);
    
    -- Get order IDs
    SELECT order_id INTO order_id_1 FROM orders WHERE user_id = customer_liam;
    SELECT order_id INTO order_id_2 FROM orders WHERE user_id = customer_zara;
    SELECT order_id INTO order_id_3 FROM orders WHERE user_id = customer_michael;
    
    -- Get inventory item IDs
    SELECT item_id INTO inventory_tomatoes FROM inventory WHERE name = 'Organic Tomatoes' LIMIT 1;
    SELECT item_id INTO inventory_eggs FROM inventory WHERE name = 'Free-range Eggs' LIMIT 1;
    SELECT item_id INTO inventory_strawberries FROM inventory WHERE name = 'Strawberries' LIMIT 1;
    SELECT item_id INTO inventory_bell_peppers FROM inventory WHERE name = 'Bell Peppers' LIMIT 1;
    SELECT item_id INTO inventory_organic_kale FROM inventory WHERE name = 'Organic Kale' LIMIT 1;
    SELECT item_id INTO inventory_fresh_basil FROM inventory WHERE name = 'Fresh Basil' LIMIT 1;
    SELECT item_id INTO inventory_organic_apples FROM inventory WHERE name = 'Organic Apples' LIMIT 1;
    SELECT item_id INTO inventory_honey FROM inventory WHERE name = 'Honey' LIMIT 1;
    
    -- Insert order items
    -- Order 1: Liam's order (delivered)
    INSERT INTO order_items (order_id, inventory_item_id, quantity, unit_price, total_price) VALUES
    (order_id_1, inventory_tomatoes, 2.0, 25.50, 51.00),
    (order_id_1, inventory_eggs, 2.0, 8.00, 16.00),
    (order_id_1, inventory_strawberries, 500.0, 45.00, 22.50),
    (order_id_1, inventory_bell_peppers, 3.0, 32.00, 96.00),
    (order_id_1, inventory_fresh_basil, 1.0, 12.00, 12.00);
    
    -- Order 2: Zara's order (shipped)
    INSERT INTO order_items (order_id, inventory_item_id, quantity, unit_price, total_price) VALUES
    (order_id_2, inventory_organic_kale, 1.0, 42.00, 42.00),
    (order_id_2, inventory_organic_apples, 2.0, 35.00, 70.00),
    (order_id_2, inventory_fresh_basil, 2.0, 12.00, 24.00),
    (order_id_2, inventory_honey, 0.5, 85.00, 42.50);
    
    -- Order 3: Michael's order (paid)
    INSERT INTO order_items (order_id, inventory_item_id, quantity, unit_price, total_price) VALUES
    (order_id_3, inventory_eggs, 1.0, 8.00, 8.00),
    (order_id_3, inventory_strawberries, 100.0, 45.00, 4.50),
    (order_id_3, inventory_tomatoes, 1.5, 25.50, 38.25),
    (order_id_3, inventory_organic_kale, 0.5, 42.00, 21.00),
    (order_id_3, inventory_bell_peppers, 0.5, 32.00, 16.00);

END $$;

-- Insert sample marketplace listings
DO $$
DECLARE
    listing_id_1 BIGINT;
    listing_id_2 BIGINT;
    listing_id_3 BIGINT;
    listing_id_4 BIGINT;
    
    inventory_tomatoes BIGINT;
    inventory_eggs BIGINT;
    inventory_strawberries BIGINT;
    inventory_organic_kale BIGINT;
BEGIN
    -- Get inventory IDs
    SELECT item_id INTO inventory_tomatoes FROM inventory WHERE name = 'Organic Tomatoes' LIMIT 1;
    SELECT item_id INTO inventory_eggs FROM inventory WHERE name = 'Free-range Eggs' LIMIT 1;
    SELECT item_id INTO inventory_strawberries FROM inventory WHERE name = 'Strawberries' LIMIT 1;
    SELECT item_id INTO inventory_organic_kale FROM inventory WHERE name = 'Organic Kale' LIMIT 1;
    
    -- Create marketplace listings
    INSERT INTO marketplace_listings (inventory_item_id, price, quantity, description) VALUES
    (inventory_tomatoes, 28.00, 25.0, 'Premium organic tomatoes, perfect for salads and cooking'),
    (inventory_eggs, 9.00, 60.0, 'Free-range eggs from happy chickens, laid fresh daily'),
    (inventory_strawberries, 50.00, 15.0, 'Sweet strawberries, hand-picked at peak ripeness'),
    (inventory_organic_kale, 45.00, 10.0, 'Nutrient-dense organic kale, perfect for smoothies and salads');
END $$;

-- Update order totals (trigger should handle this, but let's ensure)
UPDATE orders SET total_amount = (
    SELECT COALESCE(SUM(total_price), 0)
    FROM order_items
    WHERE order_items.order_id = orders.order_id
);

-- Insert sample sales history
DO $$
DECLARE
    delivered_order_items BIGINT[];
    current_date DATE := CURRENT_DATE;
BEGIN
    -- Get all delivered order items
    SELECT array_agg(oi.item_id) INTO delivered_order_items
    FROM order_items oi
    JOIN orders o ON oi.order_id = o.order_id
    WHERE o.status = 'delivered';
    
    -- Insert sales history for delivered items
    IF delivered_order_items IS NOT NULL AND array_length(delivered_order_items, 1) > 0 THEN
        INSERT INTO sales_history (order_item_id, date, revenue, quantity)
        SELECT 
            oi.item_id,
            current_date - (ROW_NUMBER() OVER() % 30), -- Spread over last 30 days
            oi.total_price,
            oi.quantity
        FROM order_items oi
        WHERE oi.item_id = ANY(delivered_order_items);
    END IF;
END $$;

-- Update sequence values to proper starting points
SELECT setval('users_users_id_seq', (SELECT MAX(users_id) FROM users));
SELECT setval('categories_category_id_seq', (SELECT MAX(category_id) FROM categories));
SELECT setval('units_unit_id_seq', (SELECT MAX(unit_id) FROM units));
SELECT setval('inventory_item_id_seq', (SELECT MAX(item_id) FROM inventory));
SELECT setval('marketplace_listings_listing_id_seq', (SELECT MAX(listing_id) FROM marketplace_listings));
SELECT setval('orders_order_id_seq', (SELECT MAX(order_id) FROM orders));
SELECT setval('order_items_item_id_seq', (SELECT MAX(item_id) FROM order_items));
SELECT setval('sales_history_sale_id_seq', (SELECT MAX(sale_id) FROM sales_history));

-- Comments for seed data
COMMENT ON TABLE categories IS 'Seed data: 12 common agricultural categories';
COMMENT ON TABLE units IS 'Seed data: 12 standard measurement units';
COMMENT ON TABLE users IS 'Seed data: 1 admin, 3 farmers, 4 customers (password: password123)';
COMMENT ON TABLE inventory IS 'Seed data: 26 inventory items across all farms';
COMMENT ON TABLE orders IS 'Seed data: 3 sample orders in different statuses';
COMMENT ON TABLE order_items IS 'Seed data: 14 order items across orders';
COMMENT ON TABLE marketplace_listings IS 'Seed data: 4 active marketplace listings';
COMMENT ON TABLE sales_history IS 'Seed data: Historical sales for analytics testing';