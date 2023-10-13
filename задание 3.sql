SELECT *
FROM orders
JOIN users ON users.c1 = orders.c1 
WHERE orders.c3 >='01/09/2022' and orders.c3<='30/11/2022'