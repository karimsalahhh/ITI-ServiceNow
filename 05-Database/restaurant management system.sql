CREATE TABLE restaurant_table(
table_id SERIAL PRIMARY KEY,
table_number INT NOT NULL UNIQUE,
status VARCHAR(20) NOT NULL CHECK (status IN ('available', 'reserved', 'occupied'))
);

CREATE TABLE menu_items(
menu_item_id SERIAL PRIMARY KEY,
item_name VARCHAR(100) NOT NULL,
price NUMERIC(10,2) NOT NULL CHECK (price >= 0),
category VARCHAR(50) NOT NULL CHECK (category IN('Pizza','Fast Food','Italian'))
);

CREATE TABLE ingredients (
ingredient_id SERIAL PRIMARY KEY,
ingredient_name VARCHAR(100) NOT NULL,
stock_quantity NUMERIC(10,2) NOT NULL CHECK (stock_quantity >= 0)
);

CREATE TABLE recipes(
menu_item_id INT NOT NULL,
ingredient_id INT NOT NULL,
quantity_required NUMERIC(10,2) NOT NULL CHECK (quantity_required > 0),
PRIMARY KEY (menu_item_id, ingredient_id),
FOREIGN KEY (menu_item_id) REFERENCES menu_items(menu_item_id),
FOREIGN KEY (ingredient_id) REFERENCES ingredients(ingredient_id)
);

CREATE TABLE orders(
order_id SERIAL PRIMARY KEY,
table_id INT NOT NULL,
order_date TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
FOREIGN KEY (table_id) REFERENCES restaurant_table(table_id)
);

CREATE TABLE order_items(
order_item_id SERIAL PRIMARY KEY,
order_id INT NOT NULL,
menu_item_id INT NOT NULL,
quantity INT NOT NULL CHECK (quantity > 0),
FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE,
FOREIGN KEY (menu_item_id) REFERENCES menu_items(menu_item_id)
);



INSERT INTO restaurant_table (table_number, status)
VALUES
(1, 'available'),
(2, 'occupied'),
(3, 'reserved');

INSERT INTO menu_items (item_name, price,category)
VALUES
('Pizza', 150.00,'Pizza'),
('Burger', 95.00,'Fast Food'),
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
-- Pizza
(1, 1, 1),
(1, 2, 2),
(1, 3, 1),

-- Burger
(2, 4, 1),
(2, 5, 1),
(2, 2, 1),

-- Pasta
(3, 6, 1),
(3, 2, 1),
(3, 3, 1);

INSERT INTO orders (table_id)
VALUES
(2),
(3);

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


SELECT o.order_id, rt.table_number, mi.item_name, oi.quantity
FROM orders o
JOIN restaurant_table rt ON o.table_id = rt.table_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN menu_items mi ON oi.menu_item_id = mi.menu_item_id;


SELECT 	
	o.order_id, mi.item_name,












