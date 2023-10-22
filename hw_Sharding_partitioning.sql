create table users as
select
   generate_series as user_id,
   now() - (random() * (interval '10 days')) AS birth_date,
   (array['m','w'])[floor(random() * 2 + 1)] AS sex,
   floor(random() * 99)::int AS age
from generate_series(1, 20);


create table orders as
select
   generate_series as item_id,
   md5(random()::text) || 'WB' AS description,
   floor(random() * 1000)::int AS price,
   (array['food','vitamins', 'drinks'])[floor(random() * 2 + 1)] AS category,
   floor(random() * 20)::int AS buyer
from generate_series(1, 20);


create table ratings as
select
   generate_series as item_id,
   md5(random()::text) || 'WB' AS review,
   floor(random() * 5)::int AS rating,
   floor(random() * 20)::int AS buyer
from generate_series(1, 20);



SELECT 
   table_name, 
   column_name, 
   data_type 
FROM 
   information_schema.columns
WHERE 
   table_name = 'orders';

--INSERT INTO ratings
--SELECT orders.buyer
--FROM orders
--INNER JOIN ratings ON orders.item_id = ratings.item_id 
