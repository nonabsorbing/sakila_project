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
#What is one query would you use to obtain this information?

SELECT actor_id, first_name, last_name 
FROM actor
WHERE first_name = "Joe"; 


#2b. Find all actors whose last name contain the letters GEN:
#NOT returning a value? 
SELECT *
FROM actor  
WHERE last_name LIKE "GEN"; 

