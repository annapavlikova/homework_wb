DELETE FROM orders
WHERE orders.c7 = 'cancel_order' OR orders.c8 > 4;

SELECT *
FROM orders
LIMIT 20
