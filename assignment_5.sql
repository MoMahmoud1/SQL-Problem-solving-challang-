use my_guitar_shop;

/* 
Write a SELECT statement that returns the same result set as this SELECT statement, but don’t use a join. Instead, use a subquery in a WHERE clause that uses the IN keyword.
SELECT DISTINCT category_name
FROM categories c JOIN products p
  ON c.category_id = p.category_id
ORDER BY category_name

*/
SELECT DISTINCT category_name
FROM categories c
WHERE c.category_id IN (SELECT 
category_id FROM products)
ORDER BY category_name;

/* 
Write a SELECT statement that answers this question: Which products have a list price that’s greater than the average list price for all products?
Return the product_name and list_price columns for each product.
Sort the results by the list_price column in descending sequence. 
*/ 
SELECT product_name, list_price
FROM products
WHERE list_price > (SELECT AVG(list_price)
FROM products)
ORDER BY list_price DESC;

/* 
3.	Write a SELECT statement that returns the category_name column from the Categories table.
Return one row for each category that has never been assigned to any product in the Products table.
 To do that, use a subquery introduced with the NOT EXISTS operator.

*/
SELECT category_name
FROM categories c
WHERE NOT EXISTS( SELECT * FROM products p
WHERE p.category_id = c.category_id);

/* 
4.	Write a SELECT statement that returns three columns: email_address, order_id, and the order total for each customer. To do this, you can group the result set by the email_address and order_id columns. In addition, you must calculate the order total from the columns in the Order_Items table.
Write a second SELECT statement that uses the first SELECT statement in its FROM clause. 
The main query should return two columns: the customer’s email address and the largest order for that customer. To do this, you can group the result set by the email_address. Sort the result set by the largest order in descending sequence.

*/
SELECT email_address, order_id, MAX(order_total) AS max_order_total
FROM (SELECT email_address, o.order_id,
SUM((item_price - discount_amount) * quantity) AS order_total
FROM customers c JOIN orders o
ON c.customer_id = o.customer_id
JOIN order_items oi
 ON o.order_id = oi.order_id
GROUP BY email_address , order_id) 
GROUP BY email_address;

/* 
Write a SELECT statement that returns the name and discount percent of each product that has a unique discount percent. 
In other words, don’t include products that have the same discount percent as another product.
Sort the results by the product_name column.
*/
SELECT product_name, discount_percent
FROM products
WHERE discount_percent NOT IN (SELECT  discount_percent
FROM products
GROUP BY discount_percent
HAVING COUNT(discount_percent) > 1)
ORDER BY product_name;


/* 
6.Use a correlated subquery to return one row per customer, representing the customer’s oldest order (the one with the earliest date). Each row should include these three columns: email_address, order_id, and order_date.
Sort the result set by the order_date and order_id columns.
*/
SELECT  email_address, order_id, order_date
FROM customers c JOIN orders o
 ON c.customer_id = o.customer_id
WHERE order_date = (SELECT  MIN(order_date)
FROM orders
WHERE customer_id = o.customer_id)
order by order_date, order_id;

/* 
1.	Write a SELECT statement that returns these columns from the Products table:
The list_price column
A column that uses the FORMAT function to return the list_price column with 1 digit to the right of the decimal point
A column that uses the CONVERT function to return the list_price column as an integer
A column that uses the CAST function to return the list_price column as an integer
 */
SELECT list_price,
FORMAT(list_price, 1),
CONVERT( list_price , signed),
CAST(list_price as signed)  
FROM products;


/* 
2.	Write a SELECT statement that returns these columns from the Products table:
The date_added column
A column that uses the CAST function to return the date_added column with its date only (year, month, and day)
A column that uses the CAST function to return the date_added column with just the year and the month
A column that uses the CAST function to return the date_added column with its full time only (hour, minutes, and seconds)
*/
SELECT  date_added, CAST(date_added as date),
CAST(date_added AS CHAR (7)),
CAST(date_added AS TIME)
FROM products;