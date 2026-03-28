DROP TABLE IF EXISTS order_items CASCADE;
DROP TABLE IF EXISTS orders CASCADE;
DROP TABLE IF EXISTS recipes CASCADE;
DROP TABLE IF EXISTS ingredients CASCADE;
DROP TABLE IF EXISTS menu_items CASCADE;
DROP TABLE IF EXISTS restaurant_table CASCADE;


CREATE TABLE restaurant_table (
    table_id SERIAL PRIMARY KEY,
    table_number INT NOT NULL UNIQUE,
    status VARCHAR(20) NOT NULL
        CHECK (status IN ('available', 'reserved', 'occupied'))
);

CREATE TABLE menu_items (
    menu_item_id SERIAL PRIMARY KEY,
    item_name VARCHAR(100) NOT NULL,
    price NUMERIC(10,2) NOT NULL
        CHECK (price >= 0),
    category VARCHAR(50) NOT NULL
        CHECK (category IN ('Pizza', 'Fast Food', 'Italian'))
);

CREATE TABLE ingredients (
    ingredient_id SERIAL PRIMARY KEY,
    ingredient_name VARCHAR(100) NOT NULL,
    stock_quantity NUMERIC(10,2) NOT NULL
        CHECK (stock_quantity >= 0)
);

CREATE TABLE recipes (
    menu_item_id INT NOT NULL,
    ingredient_id INT NOT NULL,
    quantity_required NUMERIC(10,2) NOT NULL
        CHECK (quantity_required > 0),
    PRIMARY KEY (menu_item_id, ingredient_id),
    FOREIGN KEY (menu_item_id) REFERENCES menu_items(menu_item_id),
    FOREIGN KEY (ingredient_id) REFERENCES ingredients(ingredient_id)
);

CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    table_id INT NOT NULL,
    order_date TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    order_status VARCHAR(20) NOT NULL DEFAULT 'pending'
        CHECK (order_status IN ('pending', 'cooking', 'served', 'cancelled')),
    FOREIGN KEY (table_id) REFERENCES restaurant_table(table_id)
);

CREATE TABLE order_items (
    order_item_id SERIAL PRIMARY KEY,
    order_id INT NOT NULL,
    menu_item_id INT NOT NULL,
    quantity INT NOT NULL
        CHECK (quantity > 0),
    FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE,
    FOREIGN KEY (menu_item_id) REFERENCES menu_items(menu_item_id)
);


INSERT INTO restaurant_table (table_number, status)
VALUES
(1, 'available'),
(2, 'occupied'),
(3, 'reserved'),
(4, 'available');

INSERT INTO menu_items (item_name, price, category)
VALUES
('Pizza', 150.00, 'Pizza'),
('Burger', 95.00, 'Fast Food'),
('Pasta', 120.00, 'Italian');

INSERT INTO ingredients (ingredient_name, stock_quantity)
VALUES
('Dough', 20),
('Cheese', 30),
('Tomato Sauce', 15),
('Burger Bun', 12),
('Beef Patty', 10),
('Pasta Noodles', 18);

INSERT INTO recipes (menu_item_id, ingredient_id, quantity_required)
VALUES
(1, 1, 1),
(1, 2, 2),
(1, 3, 1),
(2, 4, 1),
(2, 5, 1),
(2, 2, 1),
(3, 6, 1),
(3, 2, 1),
(3, 3, 1);

INSERT INTO orders (table_id, order_status)
VALUES
(2, 'pending'),
(3, 'cooking');

INSERT INTO order_items (order_id, menu_item_id, quantity)
VALUES
(1, 1, 2),
(1, 2, 1),
(2, 3, 1);


SELECT * FROM restaurant_table;
SELECT * FROM menu_items;
SELECT * FROM ingredients;
SELECT * FROM recipes;
SELECT * FROM orders;
SELECT * FROM order_items;


SELECT
    o.order_id,
    rt.table_number,
    mi.item_name,
    oi.quantity
FROM orders o
JOIN restaurant_table rt
    ON o.table_id = rt.table_id
JOIN order_items oi
    ON o.order_id = oi.order_id
JOIN menu_items mi
    ON oi.menu_item_id = mi.menu_item_id
ORDER BY o.order_id;


SELECT
    o.order_id,
    o.order_date,
    o.order_status,
    rt.table_number,
    mi.item_name,
    oi.quantity
FROM orders o
JOIN restaurant_table rt
    ON o.table_id = rt.table_id
JOIN order_items oi
    ON o.order_id = oi.order_id
JOIN menu_items mi
    ON oi.menu_item_id = mi.menu_item_id
WHERE o.order_status IN ('pending', 'cooking')
ORDER BY o.order_date;


SELECT
    mi.item_name,
    i.ingredient_name,
    r.quantity_required
FROM recipes r
JOIN menu_items mi
    ON r.menu_item_id = mi.menu_item_id
JOIN ingredients i
    ON r.ingredient_id = i.ingredient_id
ORDER BY mi.item_name, i.ingredient_name;


SELECT *
FROM restaurant_table
WHERE status = 'available';


BEGIN;

UPDATE restaurant_table
SET status = 'occupied'
WHERE table_id = 4;

INSERT INTO orders (table_id, order_status)
VALUES (4, 'pending');

SELECT
    i.ingredient_name,
    i.stock_quantity,
    (r.quantity_required * 2) AS total_needed
FROM recipes r
JOIN ingredients i
    ON r.ingredient_id = i.ingredient_id
WHERE r.menu_item_id = 1
AND i.stock_quantity < (r.quantity_required * 2);

INSERT INTO order_items (order_id, menu_item_id, quantity)
SELECT currval(pg_get_serial_sequence('orders', 'order_id')), 1, 2;

UPDATE ingredients i
SET stock_quantity = i.stock_quantity - (r.quantity_required * 2)
FROM recipes r
WHERE i.ingredient_id = r.ingredient_id
AND r.menu_item_id = 1;

COMMIT;


BEGIN;

INSERT INTO orders (table_id, order_status)
VALUES (1, 'pending');

SELECT
    i.ingredient_name,
    i.stock_quantity,
    (r.quantity_required * 100) AS total_needed
FROM recipes r
JOIN ingredients i
    ON r.ingredient_id = i.ingredient_id
WHERE r.menu_item_id = 1
AND i.stock_quantity < (r.quantity_required * 100);

ROLLBACK;


SELECT
    o.order_id,
    rt.table_number,
    mi.item_name,
    oi.quantity,
    o.order_status
FROM orders o
JOIN restaurant_table rt
    ON o.table_id = rt.table_id
JOIN order_items oi
    ON o.order_id = oi.order_id
JOIN menu_items mi
    ON oi.menu_item_id = mi.menu_item_id
WHERE o.order_status IN ('pending', 'cooking')
ORDER BY o.order_date ASC;


SELECT
    o.order_id,
    mi.item_name,
    oi.quantity,
    mi.price,
    (oi.quantity * mi.price) AS subtotal
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
JOIN menu_items mi
    ON oi.menu_item_id = mi.menu_item_id
WHERE o.table_id = 2;


SELECT
    o.table_id,
    o.order_id,
    o.order_date::TIME AS order_time,
    STRING_AGG(CONCAT(mi.item_name, ' (x', oi.quantity, ')'), ', ') AS order_details,
    SUM(oi.quantity * mi.price) AS table_total,
    o.order_status
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
JOIN menu_items mi
    ON oi.menu_item_id = mi.menu_item_id
WHERE DATE(o.order_date) = CURRENT_DATE
GROUP BY o.table_id, o.order_id, o.order_date, o.order_status
ORDER BY o.order_date DESC;


SELECT
    COUNT(DISTINCT o.order_id) AS total_orders_today,
    SUM(oi.quantity * mi.price) AS total_revenue,
    ROUND(SUM(oi.quantity * mi.price) / COUNT(DISTINCT o.order_id), 2) AS avg_ticket_size
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
JOIN menu_items mi
    ON oi.menu_item_id = mi.menu_item_id
WHERE o.order_status = 'served'
AND DATE(o.order_date) = CURRENT_DATE;


UPDATE orders
SET order_status = 'served'
WHERE order_id = 1;

UPDATE restaurant_table
SET status = 'available'
WHERE table_id = 2;