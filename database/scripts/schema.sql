CREATE DATABASE IF NOT EXISTS farm_shop
  CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
USE farm_shop;

-- =========================================================
-- USERS
-- =========================================================
DROP TABLE IF EXISTS Users;
CREATE TABLE Users (
  Users_ID     BIGINT PRIMARY KEY,
  name         VARCHAR(120) NOT NULL,
  email        VARCHAR(200) NOT NULL,
  farm_name    VARCHAR(150),
  created_at   DATETIME DEFAULT CURRENT_TIMESTAMP,
  UNIQUE KEY email_UNIQUE (email)
) ENGINE=InnoDB;

-- =========================================================
-- CATEGORIES
-- =========================================================
DROP TABLE IF EXISTS Categories;
CREATE TABLE Categories (
  Categories_id INT PRIMARY KEY,
  name          VARCHAR(100) NOT NULL,
  created_at    DATETIME DEFAULT CURRENT_TIMESTAMP,
  UNIQUE KEY name_UNIQUE (name)
) ENGINE=InnoDB;

-- =========================================================
-- UNITS
-- =========================================================
DROP TABLE IF EXISTS Units;
CREATE TABLE Units (
  Units_id    INT PRIMARY KEY,
  name        VARCHAR(50) NOT NULL,
  created_at  DATETIME DEFAULT CURRENT_TIMESTAMP,
  UNIQUE KEY name_UNIQUE (name)
) ENGINE=InnoDB;

-- =========================================================
-- INVENTORY
-- =========================================================
DROP TABLE IF EXISTS Inventory;
CREATE TABLE Inventory (
  Inventory_id                    BIGINT PRIMARY KEY,
  name                            VARCHAR(200) NOT NULL,
  quantity                        DECIMAL(12,3) NOT NULL DEFAULT 0,
  price                           DECIMAL(12,2) NOT NULL DEFAULT 0,
  cost                            DECIMAL(12,2) NOT NULL DEFAULT 0,
  expiry                          DATE NULL,
  reserved_qty                    DECIMAL(12,3) NOT NULL DEFAULT 0,
  created_at                      DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at                      DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  Users_Users_ID                  BIGINT NOT NULL,
  Categories_Categories_id        INT NOT NULL,
  Units_Units_id                  INT NOT NULL,
  KEY fk_Inventory_Users_idx (Users_Users_ID),
  KEY fk_Inventory_Categories1_idx (Categories_Categories_id),
  KEY fk_Inventory_Units1_idx (Units_Units_id),
  CONSTRAINT fk_Inventory_Users
    FOREIGN KEY (Users_Users_ID) REFERENCES Users (Users_ID)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_Inventory_Categories1
    FOREIGN KEY (Categories_Categories_id) REFERENCES Categories (Categories_id)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_Inventory_Units1
    FOREIGN KEY (Units_Units_id) REFERENCES Units (Units_id)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

-- =========================================================
-- SALES HISTORY
-- =========================================================
DROP TABLE IF EXISTS Sales_history;
CREATE TABLE Sales_history (
  sales_history_id  BIGINT PRIMARY KEY,
  product_name      VARCHAR(200) NOT NULL,
  quantity          DECIMAL(12,3) NOT NULL,
  price             DECIMAL(12,2) NOT NULL,
  date              DATETIME NOT NULL,
  created_at        DATETIME DEFAULT CURRENT_TIMESTAMP,
  Users_Users_ID    BIGINT NOT NULL,
  KEY fk_Sales_history_Users_idx (Users_Users_ID),
  CONSTRAINT fk_Sales_history_Users
    FOREIGN KEY (Users_Users_ID) REFERENCES Users (Users_ID)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

-- =========================================================
-- MARKETPLACE LISTINGS
-- =========================================================
DROP TABLE IF EXISTS Marketplace_listings;
CREATE TABLE Marketplace_listings (
  Marketplace_listings_id           BIGINT PRIMARY KEY,
  name                               VARCHAR(200) NOT NULL,
  quantity                           DECIMAL(12,3) NOT NULL,
  price                              DECIMAL(12,2) NOT NULL,
  expiry                             DATE NULL,
  status                             ENUM('ACTIVE','PENDING','SOLD','EXPIRED','CANCELLED') NOT NULL DEFAULT 'ACTIVE',
  created_at                         DATETIME DEFAULT CURRENT_TIMESTAMP,
  Inventory_Inventory_id             BIGINT NOT NULL,
  Inventory_Users_Users_ID           BIGINT NOT NULL,
  Inventory_Categories_Categories_id INT NOT NULL,
  Inventory_Units_Units_id           INT NOT NULL,
  Users_Users_ID                     BIGINT NOT NULL,
  KEY fk_Marketplace_listings_Inventory1_idx (Inventory_Inventory_id),
  KEY fk_Marketplace_listings_Users1_idx (Users_Users_ID),
  KEY fk_Marketplace_listings_InvUsers_idx (Inventory_Users_Users_ID),
  KEY fk_Marketplace_listings_InvCats_idx (Inventory_Categories_Categories_id),
  KEY fk_Marketplace_listings_InvUnits_idx (Inventory_Units_Units_id),
  CONSTRAINT fk_Marketplace_listings_Inventory1
    FOREIGN KEY (Inventory_Inventory_id) REFERENCES Inventory (Inventory_id)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_Marketplace_listings_Users1
    FOREIGN KEY (Users_Users_ID) REFERENCES Users (Users_ID)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_Marketplace_listings_InvUsers
    FOREIGN KEY (Inventory_Users_Users_ID) REFERENCES Users (Users_ID)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_Marketplace_listings_InvCats
    FOREIGN KEY (Inventory_Categories_Categories_id) REFERENCES Categories (Categories_id)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_Marketplace_listings_InvUnits
    FOREIGN KEY (Inventory_Units_Units_id) REFERENCES Units (Units_id)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

-- =========================================================
-- ORDERS
-- =========================================================
DROP TABLE IF EXISTS Orders;
CREATE TABLE Orders (
  Orders_id       BIGINT PRIMARY KEY,
  total           DECIMAL(12,2) NOT NULL DEFAULT 0,
  status          ENUM('NEW','PAID','CANCELLED','FULFILLED') NOT NULL DEFAULT 'NEW',
  date            DATE NOT NULL,
  created_at      DATETIME DEFAULT CURRENT_TIMESTAMP,
  Users_Users_ID  BIGINT NOT NULL,
  KEY fk_Orders_Users1_idx (Users_Users_ID),
  CONSTRAINT fk_Orders_Users1
    FOREIGN KEY (Users_Users_ID) REFERENCES Users (Users_ID)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

-- =========================================================
-- ORDER ITEMS
-- =========================================================
DROP TABLE IF EXISTS Order_items;
CREATE TABLE Order_items (
  Order_items_id                                         BIGINT PRIMARY KEY,
  product_name                                           VARCHAR(200) NOT NULL,
  quantity                                               DECIMAL(12,3) NOT NULL,
  price                                                  DECIMAL(12,2) NOT NULL,
  subtotal                                               DECIMAL(12,2) NOT NULL,
  Marketplace_listings_Marketplace_listings_id           BIGINT NOT NULL,
  Marketplace_listings_Inventory_Inventory_id            BIGINT NOT NULL,
  Marketplace_listings_Inventory_Users_Users_ID          BIGINT NOT NULL,
  Marketplace_listings_Inventory_Categories_Categories_id INT NOT NULL,
  Marketplace_listings_Inventory_Units_Units_id          INT NOT NULL,
  Marketplace_listings_Users_Users_ID                    BIGINT NOT NULL,
  Orders_Orders_id                                       BIGINT NOT NULL,
  KEY fk_Order_items_Marketplace_listings1_idx (Marketplace_listings_Marketplace_listings_id),
  KEY fk_Order_items_Orders1_idx (Orders_Orders_id),
  KEY fk_Order_items_InvInv_idx (Marketplace_listings_Inventory_Inventory_id),
  KEY fk_Order_items_InvUsers_idx (Marketplace_listings_Inventory_Users_Users_ID),
  KEY fk_Order_items_InvCats_idx (Marketplace_listings_Inventory_Categories_Categories_id),
  KEY fk_Order_items_InvUnits_idx (Marketplace_listings_Inventory_Units_Units_id),
  KEY fk_Order_items_ListUsers_idx (Marketplace_listings_Users_Users_ID),
  CONSTRAINT fk_Order_items_Marketplace_listings1
    FOREIGN KEY (Marketplace_listings_Marketplace_listings_id)
      REFERENCES Marketplace_listings (Marketplace_listings_id)
      ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_Order_items_Orders1
    FOREIGN KEY (Orders_Orders_id) REFERENCES Orders (Orders_id)
      ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_Order_items_InvInv
    FOREIGN KEY (Marketplace_listings_Inventory_Inventory_id)
      REFERENCES Inventory (Inventory_id)
      ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_Order_items_InvUsers
    FOREIGN KEY (Marketplace_listings_Inventory_Users_Users_ID)
      REFERENCES Users (Users_ID)
      ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_Order_items_InvCats
    FOREIGN KEY (Marketplace_listings_Inventory_Categories_Categories_id)
      REFERENCES Categories (Categories_id)
      ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_Order_items_InvUnits
    FOREIGN KEY (Marketplace_listings_Inventory_Units_Units_id)
      REFERENCES Units (Units_id)
      ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_Order_items_ListUsers
    FOREIGN KEY (Marketplace_listings_Users_Users_ID)
      REFERENCES Users (Users_ID)
      ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

