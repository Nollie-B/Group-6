# Farm Shop Database System

> A relational database project built with **MySQL** for managing farm inventory, marketplace listings, orders, and sales.

---

## Project Purpose

The **Farm Shop Database System** provides a centralized solution for farmers to manage their inventory, marketplace listings, sales history, and customer orders.  
It ensures **data accuracy**, **traceability**, and **integrity** through a normalized relational schema with foreign keys and clear one-to-many relationships.

### Key Features

- Track **inventory** levels, expiry, and cost
- Manage **marketplace listings** and pricing
- Record **sales history** and **customer orders**
- Categorize products by **category** and **unit**
- Support multiple **users** (farm owners)
- Maintain **referential integrity** across entities

---

## Database Schema Overview

The database follows **third normal form (3NF)** to reduce redundancy and maintain logical consistency.  
It consists of **8 main tables**:

| #   | Table                  | Description                                      |
| --- | ---------------------- | ------------------------------------------------ |
| 1   | `Users`                | Stores farm owner information                    |
| 2   | `Categories`           | Defines product groups (e.g., Vegetables, Dairy) |
| 3   | `Units`                | Stores measurement types (kg, litre, box)        |
| 4   | `Inventory`            | Tracks product quantity, cost, and expiry        |
| 5   | `Sales_history`        | Records past sales per user                      |
| 6   | `Marketplace_listings` | Represents products listed for sale              |
| 7   | `Orders`               | Captures customer orders                         |
| 8   | `Order_items`          | Links individual items to an order               |

---

## Entity Details

### Users

| Field      | Type                       | Description               |
| ---------- | -------------------------- | ------------------------- |
| Users_ID   | BIGINT, PK, AUTO_INCREMENT | Unique user ID            |
| name       | VARCHAR(120)               | User name                 |
| email      | VARCHAR(200), UNIQUE       | Contact email             |
| farm_name  | VARCHAR(150)               | Name of the farm          |
| created_at | DATETIME                   | Record creation timestamp |

---

### Categories

| Field         | Type                    | Description   |
| ------------- | ----------------------- | ------------- |
| Categories_id | INT, PK, AUTO_INCREMENT | Category ID   |
| name          | VARCHAR(100), UNIQUE    | Category name |
| created_at    | DATETIME                | Timestamp     |

---

### Units

| Field      | Type                    | Description                       |
| ---------- | ----------------------- | --------------------------------- |
| Units_id   | INT, PK, AUTO_INCREMENT | Unit ID                           |
| name       | VARCHAR(50), UNIQUE     | Unit of measure (kg, litre, etc.) |
| created_at | DATETIME                | Timestamp                         |

---

### Inventory

| Field                    | Type                       | Description            |
| ------------------------ | -------------------------- | ---------------------- |
| Inventory_id             | BIGINT, PK, AUTO_INCREMENT | Product record ID      |
| name                     | VARCHAR(200)               | Product name           |
| quantity                 | DECIMAL(12,3)              | Quantity available     |
| price                    | DECIMAL(12,2)              | Selling price per unit |
| cost                     | DECIMAL(12,2)              | Cost per unit          |
| expiry                   | DATE                       | Expiration date        |
| reserved_qty             | DECIMAL(12,3)              | Reserved amount        |
| created_at               | DATETIME                   | Created timestamp      |
| updated_at               | DATETIME                   | Auto-updated timestamp |
| Users_Users_ID           | FK → Users                 | Product owner          |
| Categories_Categories_id | FK → Categories            | Product category       |
| Units_Units_id           | FK → Units                 | Measurement unit       |

---

### Sales_history

| Field            | Type                       | Description      |
| ---------------- | -------------------------- | ---------------- |
| sales_history_id | BIGINT, PK, AUTO_INCREMENT | Sales record ID  |
| product_name     | VARCHAR(200)               | Product sold     |
| quantity         | DECIMAL(12,3)              | Quantity sold    |
| price            | DECIMAL(12,2)              | Price per unit   |
| date             | DATETIME                   | Sale date        |
| created_at       | DATETIME                   | Timestamp        |
| Users_Users_ID   | FK → Users                 | Seller reference |

---

### Marketplace_listings

| Field                   | Type                                                  | Description        |
| ----------------------- | ----------------------------------------------------- | ------------------ |
| Marketplace_listings_id | BIGINT, PK, AUTO_INCREMENT                            | Listing ID         |
| name                    | VARCHAR(200)                                          | Listing title      |
| quantity                | DECIMAL(12,3)                                         | Quantity available |
| price                   | DECIMAL(12,2)                                         | Price per unit     |
| expiry                  | DATE                                                  | Expiration date    |
| status                  | ENUM('ACTIVE','PENDING','SOLD','EXPIRED','CANCELLED') | Listing status     |
| created_at              | DATETIME                                              | Timestamp          |
| Inventory_Inventory_id  | FK → Inventory                                        | Product listed     |
| Users_Users_ID          | FK → Users                                            | Listing owner      |

---

### Orders

| Field          | Type                                       | Description       |
| -------------- | ------------------------------------------ | ----------------- |
| Orders_id      | BIGINT, PK, AUTO_INCREMENT                 | Order ID          |
| total          | DECIMAL(12,2)                              | Order total       |
| status         | ENUM('NEW','PAID','CANCELLED','FULFILLED') | Order status      |
| date           | DATE                                       | Order date        |
| created_at     | DATETIME                                   | Created timestamp |
| Users_Users_ID | FK → Users                                 | Buyer reference   |

---

### Order_items

| Field                                        | Type                       | Description               |
| -------------------------------------------- | -------------------------- | ------------------------- |
| Order_items_id                               | BIGINT, PK, AUTO_INCREMENT | Item record ID            |
| product_name                                 | VARCHAR(200)               | Snapshot of product name  |
| quantity                                     | DECIMAL(12,3)              | Quantity purchased        |
| price                                        | DECIMAL(12,2)              | Price per unit            |
| subtotal                                     | DECIMAL(12,2)              | Total price               |
| Marketplace_listings_Marketplace_listings_id | FK → Marketplace_listings  | Product listing reference |
| Orders_Orders_id                             | FK → Orders                | Parent order reference    |

---

## Running the Project

### Prerequisites

- A modern web browser (Chrome, Firefox, Safari, or Edge)
- Local development server (optional, but recommended)

### Project Structure

```
F2C_Solutions/
├── frontend/
│   ├── assets/         # Static assets like images
│   ├── components/     # Reusable HTML components
│   ├── html/          # Main HTML pages
│   ├── js/           # JavaScript files
│   └── styles/       # CSS stylesheets
├── database/
│   ├── diagrams/     # Database diagrams
│   └── scripts/      # SQL scripts
└── wireframes/       # UI/UX wireframes
```

### Quick Start

1. Clone the repository:

   ```bash
   git clone https://github.com/Nollie-B/F2C_Solutions.git
   cd F2C_Solutions
   ```

2. Open the project:

   - Direct file access

     - Navigate to `frontend/html/index.html`
     - Open in your web browser (Right click, open with live server)

### Current Features

- Responsive navigation with mobile support
- Basic page structure for:
  - Profile management
  - Inventory tracking
  - Shop/Marketplace
  - Order tracking
- Styled with Bootstrap 5.3.3
- Custom components system for reusability

### Development Status

The project is currently in early development with:

- Frontend UI structure
- Database schema design
- Basic component system
- Backend implementation (pending)
- Database integration (pending)

### Known Issues

- The forms are not yet connected to a backend
- Data is not persisted
- Sample data needs to be implemented

---

## Relationships Summary

```text
Users ───< Inventory >── Categories
   │           │
   │           └── Units
   │
   ├──< Orders >──< Order_items >── Marketplace_listings >── Inventory
   │                                             │
   │                                             └── Users (seller)
   │
   └──< Sales_history
```
