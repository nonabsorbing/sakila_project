USE sakila;

-- 1a. Display the first and last names of all actors from the table actor.
SELECT first_name, last_name
FROM actor;

-- 1b. Display the first and last name of each actor in a single column in upper 
-- case letters. Name the column Actor Name.

SELECT *, CONCAT(first_name, ' ', last_name) AS Actor_name 
FROM actor;

-- 2a. You need to find the ID number, first name, and last name of an actor, 
-- of whom you know only the first name, "Joe." 
SELECT actor_id, first_name, last_name 
FROM actor
WHERE first_name = "Joe"; 


-- 2b. Find all actors whose last name contain the letters GEN:
SELECT *
FROM actor  
WHERE last_name LIKE "%GEN%"; 

-- 2c Find all actors whose last names contain the letters LI. 
-- This time, order the rows by last name and first name, in that order:
SELECT *
FROM actor  
WHERE last_name LIKE "%LI%"
ORDER BY last_name, first_name; 

-- 2d Using IN, display the country_id and country columns of the 
-- following countries: Afghanistan, Bangladesh, and China:
SELECT country_id, country 
FROM country 
WHERE country IN ("Afghanistan", "Bangladesh","China");

-- 3a acreate a column in the table actor named description and use the data type BLOB
ALTER TABLE actor
ADD description BLOB; 

SELECT * 
FROM actor;

-- 3b ALTER TABLE actor 
ALTER TABLE actor
DROP description;  

SELECT * 
FROM actor;

-- 4a. List the last names of actors, as well as how many actors have that last name.
SELECT last_name,
COUNT(*) AS `num`
FROM actor
GROUP BY last_name; 

-- 4b. List last names of actors and the number of actors who have that last name, 
-- but only for names that are shared by at least two actors
SELECT COUNT(last_name) AS "number_with_name"
	,last_name
FROM actor
GROUP BY last_name
HAVING COUNT(last_name) >1
;

-- 5a. You cannot locate the schema of the address table. 
-- -- Which query would you use to re-create it?
SHOW CREATE TABLE address; 

-- 6a. Use JOIN to display the first and last names, as well 
-- as the address, of each staff member. Use the tables staff and address:

SELECT staff.first_name, staff.last_name, address.address
FROM staff
LEFT JOIN address ON 
staff.address_id = address.address_id;

-- 6b. Use JOIN to display the total amount rung up by each staff member 
-- in August of 2005. Use tables staff and payment.

SELECT SUM(amount) AS "August 2005 Sales"
,last_name
FROM staff s
INNER JOIN payment p ON s.staff_id = p.staff_id
WHERE payment_date LIKE "2005-08%"
GROUP BY last_name
;

-- 6c. List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join.

SELECT DISTINCT COUNT(actor_id) as "Number of Actors"
, title
FROM film f
INNER JOIN film_actor fa ON f.film_id = fa.film_id
GROUP BY title; 

-- 6d. How many copies of the film Hunchback Impossible exist in the inventory system?

SELECT DISTINCT COUNT(inventory_id) as "Number of Copies"
, title
FROM inventory i
INNER JOIN film f ON i.film_id = f.film_id
WHERE title = "Hunchback Impossible";

-- 6e. Using the tables payment and customer and the JOIN command, list the total paid by each customer. 
-- List the customers alphabetically by last name:

SELECT SUM(amount) AS "Total Paid by Customer"
,last_name
FROM payment p
INNER JOIN customer c ON p.customer_id = c.customer_id
GROUP BY last_name
ORDER BY last_name;

-- 7a. Use subqueries to display the titles of movies starting with the letters K and Q whose language is English.

SELECT title
	FROM film 
	WHERE language_id IN(
		SELECT language_id
			FROM language 
            WHERE name = "English")      
	AND title LIKE "k%" OR title LIKE "q%";

-- 7b. Use subqueries to display all actors who appear in the film Alone Trip.

SELECT first_name, last_name 
FROM actor
	WHERE actor_id IN 
		(SELECT actor_id
		FROM film_actor
        WHERE film_id IN
			(SELECT film_id
			FROM film 
            WHERE title = "ALONE TRIP"
            )
          );

-- 7c. You want to run an email marketing campaign in Canada, for which you will need the names 
-- and email addresses of all Canadian customers. Use joins to retrieve this information.

SELECT cu.first_name, cu.last_name, cu.email
FROM customer cu
INNER JOIN address ad ON cu.address_id = ad.address_id
INNER JOIN city ci ON ad.city_id = ci.city_id
INNER JOIN country co ON ci.country_id = co.country_id
WHERE country = "Canada"
;
 
-- 7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion.
-- Identify all movies categorized as family films.

SELECT * FROM category; -- category , category_id
SELECT * FROM film_category; -- category_id, film_id
SELECT * FROM film; -- film_id, title 

SELECT title 
FROM film 
WHERE film_id IN 
	(SELECT film_id 
    FROM film_category
    WHERE category_id IN
		(SELECT category_id
        FROM category 
        WHERE name = "family" 
        )
    );
    
-- 7e. Display the most frequently rented movies in descending order.
-- THINK ABOUT THIS SOME MORE? 
SELECT * FROM rental; -- rental_id, inventory_id
SELECT * FROM inventory; -- inventory_id, film_id
SELECT * FROM film; -- film_id, title 

SELECT COUNT(title) as "Number of Times Rented" 
, title
FROM film f
LEFT JOIN inventory i ON f.film_id = i.film_id
LEFT JOIN rental r ON i.inventory_id = r.inventory_id
GROUP BY title
ORDER BY COUNT(title) DESC; 


-- 7f. Write a query to display how much business, in dollars, each store brought in.
-- There's bad data entries in the payment table at row 424 - a null value for rental_id. 
SELECT * FROM store; -- store_id
SELECT * FROM staff; -- store_id, staff_id
SELECT * FROM rental; -- rental_id?, staff_id
SELECT * FROM payment; -- amount, rental_id

SELECT SUM(amount) as "Revenue per Store"
, st.store_id
FROM payment p
LEFT JOIN rental r ON p.rental_id = r.rental_id
LEFT join staff s ON r.staff_id = s.staff_id
LEFT join store st ON s.store_id = st.store_id
WHERE s.store_id IS NOT NULL
GROUP BY s.store_id
;

-- 7g. Write a query to display for each store its store ID, city, and country.
SELECT * FROM store; -- store_id, addrees_id
SELECT * FROM address; -- address_id, city_id
SELECT * FROM city;  -- city_id, country_id
SELECT * FROM country; -- country_id, country

SELECT store_id, city, country
FROM store s
INNER JOIN address a ON s.address_id = a.address_id
INNER JOIN city ci ON a.city_id = ci.city_id
INNER JOIN country co ON ci.country_id = co.country_id;

-- 7h. List the top five genres in gross revenue in descending order. 
-- (Hint: you may need to use the following tables: 
-- category, film_category, inventory, payment, and rental.)

SELECT * FROM category; -- category_id, name
SELECT * FROM film_category; -- category_id, film_id
SELECT * FROM  inventory; -- film_id, inventory_id
SELECT * FROM rental;  -- inventory_id, rental_id
SELECT * FROM payment; -- rental_id, amount 

SELECT SUM(amount) AS total_per_genre
, name
FROM payment p 
LEFT JOIN rental r ON p.rental_id = r.rental_id
LEFT JOIN inventory i ON r.inventory_id = i.inventory_id
LEFT JOIN film_category fc ON i.film_id = fc.film_id
LEFT JOIN category c ON fc.category_id = c.category_id
GROUP BY name
ORDER BY total_per_genre DESC
LIMIT 5
; -- NOT SORTING RIGHT???? 

-- 8a. In your new role as an executive, you would like to have an easy way of viewing 
-- the Top five genres by gross revenue. Use the solution from the problem above to create a view. 
-- If you haven't solved 7h, you can substitute another query to create a view.



CREATE VIEW top_genres AS
SELECT SUM(amount) as total_per_genre
, name
FROM payment p 
LEFT JOIN rental r ON p.rental_id = r.rental_id
LEFT JOIN inventory i ON r.inventory_id = i.inventory_id
LEFT JOIN film_category fc ON i.film_id = fc.film_id
LEFT JOIN category c ON fc.category_id = c.category_id
GROUP BY name
ORDER BY total_per_genre DESC
LIMIT 5;

-- 8b. How would you display the view that you created in 8a?
SELECT * FROM top_genres;

-- 8c. You find that you no longer need the view top_five_genres. Write a query to delete it.

DROP VIEW top_genres; 