USE delivero;

SELECT
    state_code,
    COUNT(*) AS order_count
FROM orders
GROUP BY state_code
ORDER BY order_count DESC;

SELECT
    u.customer_subscription,
    p.product,
    COUNT(*) AS order_count
FROM orders o
JOIN user u ON o.customer_id = u.customer_id
JOIN product p ON o.meal_name = p.product
GROUP BY u.customer_subscription, p.product
ORDER BY order_count DESC;

SELECT
    u.gender,
    u.customer_subscription,
    COUNT(*) AS total_orders,
   ROUND(SUM(p.product_price * o.total_quantity), 2) AS total_spent
FROM orders o
JOIN user u ON o.customer_id = u.customer_id
JOIN product p ON o.meal_name = p.product
GROUP BY u.gender, u.customer_subscription
ORDER BY total_spent DESC;

SELECT
    gender,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM user), 1) AS percentage
FROM user
GROUP BY gender;

CREATE TEMPORARY TABLE temp_idprods_table (
SELECT p.prod_id, o.meal_name as product
FROM product p
INNER JOIN orders o 
ON p.product = o.meal_name
ORDER BY prod_id);

SELECT prod_id, product, COUNT(*) as n_orders
FROM temp_idprods_table
GROUP BY prod_id, product;


WITH cte_unit_price AS (
    SELECT order_id, meal_name as product, restaurant, price_in_order, total_quantity,
           ROUND(SUM(price_in_order / total_quantity), 2) AS unit_price
    FROM orders
    GROUP BY order_id, product, restaurant, price_in_order, total_quantity
)
SELECT
    product,
    MAX(unit_price) AS max_unit_price
FROM 
    cte_unit_price
GROUP BY 
    product
ORDER BY max_unit_price DESC;

