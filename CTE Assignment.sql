use sakila;

-- Q.1 First Normal Form (1NF)
-- Identify a table in the Sakila database that violates 1NF. Explain how you would normalize 
-- it to achieve 1NF

 -- ANS 
 -- One such table is the film table, which has a special_features column that contains multiple 
 -- values separated by commas . This violates 1NF because the special_features column is a 
 -- multi-valued attribute . To normalize this table, we can create a new table called 
 -- film_2 with two columns: film_id and special_feature . The film_id column
 -- will be a foreign key that references the film_id column in the film table, and the 
 -- special_feature column will contain a single value from the special_features column in the 
 -- film table . This will allow us to store each special feature as a separate row in the 
 -- film_2 table.
 
 -- Q.2 Second Normal Form (2NF)
-- Choose a table in Sakila and describe how you would determine whether it is in 2NF. 
-- If it violates 2NF, explain the steps to normalize it

-- ANS 
-- To determine whether a table in Sakila is in 2NF, we need to check if it satisfies the 
-- following conditions:
-- The table must be in First Normal Form (1NF).
-- The table must not have any partial dependencies.

-- Q.3  Third Normal Form (3NF)
-- Identify a table in Sakila that violates 3NF. Describe the transitive dependencies present 
-- and outline the steps to normalize the table to 3NF

-- ANS
-- To identify a table in Sakila that violates 3NF, we need to examine the relationships 
-- between the attributes of each table. One such table is the film_actor table, which contains
-- the following attributes: actor_id, film_id, last_update. The film_actor table violates 3NF
-- because it has a transitive dependency between actor_id and last_update through film_id. 

-- Q.4  Normalization Process
 -- Take a specific table in Sakila and guide through the process of normalizing it from the initial 
-- unnormalized form up to at least 2NF


-- Q.5  CTE Basics
 -- Write a query using a CTE to retrieve the distinct list of actor names and the number of films they have 
-- acted in from the  actor and film_actor tables

-- ANS
WITH actor_film_count AS (
SELECT a.first_name AS actor_name , COUNT(fa.actor_id) AS film_count
FROM actor a JOIN film_actor fa ON a.actor_id = fa.actor_id
GROUP BY a.actor_id)
SELECT actor_name, film_count
FROM actor_film_count
ORDER BY actor_name;

-- Q.6 Recursive CTE
-- Use a recursive CTE to generate a hierarchical list of categories and their subcategories from the table in Sakila
select * from film_category;
select * from category;

-- ANS
WITH RECURSIVE category_tree AS (SELECT category_id, name FROM category
WHERE category_id IS NULL UNION ALL SELECT c.category_id, c.name
FROM category c JOIN film_category fc ON c.category_id = fc.category_id)
SELECT category_id,name FROM category_tree;

-- Q.7  CTE with Joins
-- Create a CTE that combines information from the  and  name, and rental rate customer and  payment tables
-- customer rental table film language category tables to display the film title, language

-- ANS
WITH rental_info AS (SELECT r.rental_id,r.customer_id,r.inventory_id,r.return_date,f.film_id,f.title,
f.language_id,c.name AS category_name,l.name AS language_name FROM rental r
INNER JOIN inventory AS i ON r.inventory_id = i.inventory_id
INNER JOIN film AS f ON i.film_id = f.film_id
INNER JOIN film_category AS fc ON f.film_id = fc.film_id
INNER JOIN category AS c ON fc.category_id = c.category_id
INNER JOIN language AS l ON f.language_id = l.language_id)
SELECT title AS "Film Title",language_name AS "Film Language"
FROM rental_info ORDER BY title;

-- Q.8 CTE for Aggregation
 -- Write a query using a CTE to find the total revenue generated by each customer (sum of payments) from 
-- the customer and payment tables.

-- ANS 
WITH customer_revenue AS (SELECT c.customer_id, SUM(p.amount) AS total_revenue FROM customer c
INNER JOIN payment p ON c.customer_id = p.customer_id GROUP BY c.customer_id) 
SELECT c.customer_id, c.first_name, c.last_name, customer_revenue.total_revenue FROM customer c
INNER JOIN customer_revenue ON c.customer_id = customer_revenue.customer_id;

-- Q.9 CTE with Window Functions
 -- Utilize a CTE with a window function to rank films based on their rental duration from the film table
 
 -- ANS 
WITH film_duration_cte AS (SELECT film_id,rental_duration,
RANK() OVER (ORDER BY rental_duration DESC) AS rental_duration_rank FROM film)
SELECT film_id,rental_duration,rental_duration_rank
FROM film_duration_cte ORDER BY rental_duration_rank;

-- Q.10 CTE and Filtering
-- Create a CTE to list customers who have made more than two rentals, and then join this CTE with the customer
-- table to retrieve additional customer details

-- ANS
WITH rental_customers AS (SELECT customer_id, COUNT(*) AS rental_count FROM rental
GROUP BY customer_id HAVING COUNT(*) > 2)
SELECT c.first_name, c.last_name, c.email, rc.rental_count FROM customer c 
INNER JOIN rental_customers rc ON c.customer_id = rc.customer_id;

-- Q.11  CTE for Date Calculations
-- Write a query using a CTE to find the total number of rentals made each month, considering the from the rental table

-- ANS 
WITH monthly_rentals AS (
SELECT month(rental_date) AS rental_month, COUNT(*) AS rental_count FROM rental
GROUP BY month (rental_date))
SELECT rental_month, rental_count FROM monthly_rentals ORDER BY rental_month;

-- Q.12 CTE for Pivot Operations
 -- Use a CTE to pivot the data from the payment table to display the total payments made by 
 -- each customer in separate columns for different payment methods
 
 -- ANS 

-- Q.13 CTE and Self-Join
-- Create a CTE to generate a report showing pairs of actors who have appeared in the same film together, using the film_actor table

-- ANS
WITH film_actor_pairs AS (
SELECT f1.actor_id AS actor1, f2.actor_id AS actor2, f1.film_id FROM film_actor f1 
INNER JOIN film_actor f2 ON f1.film_id = f2.film_id )
SELECT actor1, actor2, COUNT(film_id) AS films_in_common FROM film_actor_pairs
GROUP BY actor1 ORDER BY films_in_common DESC;

-- Q.14 CTE foV RecuVsive SeaVch
-- Implement a recursive CTE to find all employees in the staff table who report to a specific manager, 
-- considering the reports_to column
