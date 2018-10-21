USE sakila;

#1a. Display the first and last names of all actors from the table actor.
SELECT first_name, last_name
FROM actor;

#1b. Display the first and last name of each actor in a single column in upper 
#case letters. Name the column Actor Name.

SELECT *, CONCAT(first_name, ' ', last_name) AS Actor_name 
FROM actor;

#2a. You need to find the ID number, first name, and last name of an actor, 
#of whom you know only the first name, "Joe." 
SELECT actor_id, first_name, last_name 
FROM actor
WHERE first_name = "Joe"; 


#2b. Find all actors whose last name contain the letters GEN:
SELECT *
FROM actor  
WHERE last_name LIKE "%GEN%"; 

#2c Find all actors whose last names contain the letters LI. 
#This time, order the rows by last name and first name, in that order:
SELECT *
FROM actor  
WHERE last_name LIKE "%LI%"
ORDER BY last_name, first_name; 

#2d Using IN, display the country_id and country columns of the 
#following countries: Afghanistan, Bangladesh, and China:
SELECT country_id, country 
FROM country 
WHERE country = "Afghanistan" OR country = "Bangladesh" OR country = "China";

#3a acreate a column in the table actor named description and use the data type BLOB
ALTER TABLE actor
ADD description BLOB; 

#3b ALTER TABLE actor 
ALTER TABLE actor
DROP description;  

#4a. List the last names of actors, as well as how many actors have that last name.
SELECT last_name,
COUNT(*) AS `num`
FROM actor
GROUP BY last_name; 

#4b. List last names of actors and the number of actors who have that last name, 
#but only for names that are shared by at least two actors
###still trying to get the count filter fixed? 
SELECT COUNT(last_name) AS "number_with_name"
	,last_name
FROM actor
#WHERE "number_with_name" >=2
GROUP BY last_name;

#5a. You cannot locate the schema of the address table. 
#Which query would you use to re-create it?
SHOW CREATE TABLE address; 

#6a. Use JOIN to display the first and last names, as well 
#as the address, of each staff member. Use the tables staff and address:

SELECT staff.first_name, staff.last_name, address.address
FROM staff
LEFT JOIN address ON 
staff.address_id = address.address_id;

#6b. Use JOIN to display the total amount rung up by each staff member 
#in August of 2005. Use tables staff and payment.

-- SELECT last_name
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

SELECT * FROM rental; -- rental_id, inventory_id
SELECT * FROM inventory; -- inventory_id, film_id
SELECT * FROM film; film_id, title 

SELECT COUNT(title) 
FROM film f
LEFT JOIN inventory i ON f.film_id = i.film_id; 

