/*1 задание*/
SELECT city, age, COUNT(*) AS count_city FROM users
GROUP BY city, age
ORDER BY count_city DESC;

/*2 задание*/
SELECT category, round(CAST(AVG(price) AS numeric),2) AS avg_price FROM products
WHERE name LIKE '%Hair%' OR name LIKE '%Home%'
GROUP BY category;

/*3 задание*/
SELECT seller_id, COUNT(category) AS total_categ, round(AVG(rating),2) AS avg_rating, SUM(revenue) AS total_revenue,
CASE 
	WHEN COUNT(category)>1 AND SUM(revenue) > 50000 THEN 'rich'
    ELSE 'poor'
END AS seller_type
FROM sellers
GROUP BY seller_id
ORDER BY seller_id

/*4 задание*/
SELECT seller_id, FLOOR(MAX((EXTRACT(EPOCH FROM current_timestamp) - EXTRACT(EPOCH FROM to_date(date_reg, 'DD MM YYYY')))/2592000)) AS month_from_registration, (MAX(delivery_days)-MIN(delivery_days)) AS max_delivery_difference 
FROM sellers
GROUP BY seller_id
HAVING (COUNT(category)>1 AND SUM(revenue) < 50000) 
ORDER BY seller_id

/*5 задание*/
SELECT seller_id FROM (SELECT seller_id, MAX(date_reg) AS date_reg FROM sellers GROUP BY seller_id HAVING count(category)=2 AND SUM(revenue)>75000)
wheRE EXTRACT(YEAR FROM to_date(date_reg,  'DD MM YYYY'))=2022
GROUP BY seller_id
ORDER BY seller_id