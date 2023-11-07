/*1 задание*/
SELECT customers_new_3.customer_id, customers_new_3.name, EXTRACT(EPOCH FROM to_timestamp(orders_new_3.shipment_date, 'YYYY MM DD HH24:MI:SS')) - EXTRACT(EPOCH FROM to_timestamp(orders_new_3.order_date, 'YYYY MM DD HH24:MI:SS')) AS time
FROM customers_new_3 JOIN orders_new_3
On customers_new_3.customer_id = orders_new_3.customer_id
AND EXTRACT(EPOCH FROM to_timestamp(orders_new_3.shipment_date, 'YYYY MM DD HH24:MI:SS')) - EXTRACT(EPOCH FROM to_timestamp(orders_new_3.order_date, 'YYYY MM DD HH24:MI:SS')) =
(SELECT MAX(EXTRACT(EPOCH FROM to_timestamp(orders_new_3.shipment_date, 'YYYY MM DD HH24:MI:SS')) - EXTRACT(EPOCH FROM to_timestamp(orders_new_3.order_date, 'YYYY MM DD HH24:MI:SS'))) FROM orders_new_3)


/* 2 задание*/
SELECT customers_new_3.customer_id, SUM(orders_new_3.order_ammount),
AVG(EXTRACT(EPOCH FROM to_timestamp(orders_new_3.shipment_date, 'YYYY MM DD HH24:MI:SS')) - EXTRACT(EPOCH FROM to_timestamp(orders_new_3.order_date, 'YYYY MM DD HH24:MI:SS')))
FROM customers_new_3 JOIN orders_new_3
On customers_new_3.customer_id = orders_new_3.customer_id
/*WHERE orders_new_3.order_ammount = 
(SELECT MAX(orders_new_3.order_ammount) FROM orders_new_3)*/
GROUP BY customers_new_3.customer_id
ORDER BY SUM(orders_new_3.order_ammount) desc
LIMIT 7

/*3 задание*/
SELECT customers_new_3.name, t1.long, t1.cancel, t1.ammount
FROM
(SELECT
(CASE WHEN long.customer_id is NULL THEN CONCAT_WS('',long.customer_id, cancel.customer_id) ELSE long.customer_id::varchar END),
(CASE WHEN long.long is null THEN 0 ELSE long.long END),
(CASE WHEN cancel.cancel is null THEN 0 ELSE cancel.cancel END),
(CASE WHEN cancel.cam is null THEN long.lam WHEN long.lam IS NULL THEN cancel.cam ELSE long.lam+cancel.cam END) AS ammount
from 
(SELECT customers_new_3.customer_id, SUM(orders_new_3.order_ammount) AS lam,
COUNT(orders_new_3.customer_id) as long
FROM customers_new_3 JOIN orders_new_3
On customers_new_3.customer_id = orders_new_3.customer_id
WHERE EXTRACT(EPOCH FROM to_timestamp(orders_new_3.shipment_date, 'YYYY MM DD HH24:MI:SS')) - EXTRACT(EPOCH FROM to_timestamp(orders_new_3.order_date, 'YYYY MM DD HH24:MI:SS'))>432000
group by customers_new_3.customer_id
ORDER BY customers_new_3.customer_id) long

FULL outer JOIN

(SELECT customers_new_3.customer_id, SUM(orders_new_3.order_ammount) AS cam,
COUNT(orders_new_3.customer_id) as cancel
FROM customers_new_3 JOIN orders_new_3
On customers_new_3.customer_id = orders_new_3.customer_id
WHERE orders_new_3.order_status = 'Cancel'
GROUP BY customers_new_3.customer_id
ORDER BY customers_new_3.customer_id) cancel
on long.customer_id=cancel.customer_id) t1
JOIN customers_new_3
ON t1.customer_id::smallint=customers_new_3.customer_id
ORDER BY ammount DESC


/*4 задание
Напитки - категория с наибольшей общей суммой продаж*/
SELECT ammount.product_category, ammount.ammount AS total_ammount, popular.product_name
FROM
(SELECT products_3.product_category, SUM(orders_2.order_ammount) AS ammount
FROM products_3 JOIN orders_2
On products_3.product_id=orders_2.product_id
GROUP BY products_3.product_category
ORDER bY ammount DESC) ammount
JOIN
(SELECT products_3.product_category, products_3.product_name, orders_2.order_ammount
FROM products_3
JOIN orders_2 ON products_3.product_id=orders_2.product_id
WHERE (products_3.product_category, orders_2.order_ammount)
in 
(SELECT products_3.product_category, MAX(orders_2.order_ammount)
 FROM products_3
 JOIN orders_2 ON products_3.product_id=orders_2.product_id
 GROUP BY products_3.product_category)) popular
ON ammount.product_category=popular.product_category
ORDER BY ammount.ammount DESC

