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

SELECT last_name,
COUNT(*) AS `num`
FROM actor
GROUP BY last_name
IF num < 1;


