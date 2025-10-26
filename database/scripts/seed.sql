USE farm_shop;

-- =========================================================
-- USERS
-- =========================================================
INSERT INTO Users (Users_ID, name, email, farm_name, created_at) VALUES
(1, 'Ava Mokoena', 'ava@greengrow.co.za', 'GreenGrow Farms', NOW()),
(2, 'Liam Naidoo', 'liam@freshroots.co.za', 'FreshRoots Farm', NOW());

-- =========================================================
-- CATEGORIES
-- =========================================================
INSERT INTO Categories (Categories_id, name, created_at) VALUES
(1, 'Vegetables', NOW()),
(2, 'Fruit', NOW()),
(3, 'Dairy', NOW());

-- =========================================================
-- UNITS
-- =========================================================
INSERT INTO Units (Units_id, name, created_at) VALUES
(1, 'kg', NOW()),
(2, 'litre', NOW()),
(3, 'box', NOW());

-- =========================================================
-- INVENTORY
-- =========================================================
INSERT INTO Inventory (
  Inventory_id, name, quantity, price, cost, expiry, reserved_qty,
  created_at, updated_at, Users_Users_ID, Categories_Categories_id, Units_Units_id
) VALUES
(1, 'Potatoes', 200.000, 25.00, 15.00, '2025-12-31', 10.000, NOW(), NOW(), 1, 1, 1),
(2, 'Carrots', 150.000, 30.00, 18.00, '2025-12-15', 5.000, NOW(), NOW(), 1, 1, 1),
(3, 'Apples', 80.000, 45.00, 25.00, '2025-11-30', 0.000, NOW(), NOW(), 2, 2, 3),
(4, 'Milk', 60.000, 18.00, 10.00, '2025-11-05', 0.000, NOW(), NOW(), 2, 3, 2);

-- =========================================================
-- SALES HISTORY
-- =========================================================
INSERT INTO Sales_history (
  sales_history_id, product_name, quantity, price, date, created_at, Users_Users_ID
) VALUES
(1, 'Potatoes', 10.000, 25.00, NOW() - INTERVAL 3 DAY, NOW(), 1),
(2, 'Carrots', 8.000, 30.00, NOW() - INTERVAL 2 DAY, NOW(), 1),
(3, 'Apples', 5.000, 45.00, NOW() - INTERVAL 1 DAY, NOW(), 2);

-- =========================================================
-- MARKETPLACE LISTINGS
-- =========================================================
INSERT INTO Marketplace_listings (
  Marketplace_listings_id, name, quantity, price, expiry, status, created_at,
  Inventory_Inventory_id, Inventory_Users_Users_ID,
  Inventory_Categories_Categories_id, Inventory_Units_Units_id, Users_Users_ID
) VALUES
(1, 'Fresh Potatoes', 50.000, 27.00, '2025-12-01', 'ACTIVE', NOW(),
  1, 1, 1, 1, 1),
(2, 'Sweet Carrots', 30.000, 32.00, '2025-12-05', 'ACTIVE', NOW(),
  2, 1, 1, 1, 1),
(3, 'Farm Apples', 25.000, 46.00, '2025-11-15', 'ACTIVE', NOW(),
  3, 2, 2, 3, 2),
(4, 'Fresh Milk', 20.000, 20.00, '2025-11-02', 'ACTIVE', NOW(),
  4, 2, 3, 2, 2);

-- =========================================================
-- ORDERS
-- =========================================================
INSERT INTO Orders (
  Orders_id, total, status, date, created_at, Users_Users_ID
) VALUES
(1, 300.00, 'PAID', '2025-10-26', NOW(), 1),
(2, 138.00, 'NEW', '2025-10-25', NOW(), 2);

-- =========================================================
-- ORDER ITEMS
-- =========================================================
INSERT INTO Order_items (
  Order_items_id, product_name, quantity, price, subtotal,
  Marketplace_listings_Marketplace_listings_id,
  Marketplace_listings_Inventory_Inventory_id,
  Marketplace_listings_Inventory_Users_Users_ID,
  Marketplace_listings_Inventory_Categories_Categories_id,
  Marketplace_listings_Inventory_Units_Units_id,
  Marketplace_listings_Users_Users_ID,
  Orders_Orders_id
) VALUES
(1, 'Fresh Potatoes', 5.000, 27.00, 135.00, 1, 1, 1, 1, 1, 1, 1),
(2, 'Sweet Carrots', 3.000, 32.00, 96.00, 2, 2, 1, 1, 1, 1, 1),
(3, 'Farm Apples', 2.000, 46.00, 92.00, 3, 3, 2, 2, 3, 2, 2),
(4, 'Fresh Milk', 2.000, 23.00, 46.00, 4, 4, 2, 3, 2, 2, 2);
