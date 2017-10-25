/*
 Task:
 1) Create keyspace named as chernenko with replication factor 2.
 2) Alter keyspace named as chernenko with replication factor +1.
 3) Create table which describes 1 to N relation "User watch films". Each entity should have atleast 3 attributes in addition to key attributes.
 4) Update record to create example of nonconsistent data.
 5) Recreate table so attributes of main entity are marked with static keyword.
 6) Update record and check that data are still consistent.
 7) Drop created tables and keyspaces
 */
 
 CREATE KEYSPACE IF NOT EXISTS chernenko
 with replication = {'class':'SimpleStrategy',
 					'replication_factor':2
 };
 //
 ALTER KEYSPACE chernenko 
 with replication = {'class':'SimpleStrategy',
 					'replication_factor':3
 };
 
USE chernenko;
 
//without STATIC:
CREATE TABLE IF NOT EXISTS film(
	movie_id int,
	year int,
	film_name text,
	producer text,
	user_id int,
	user_name text,
	age int,
	city text,
		PRIMARY KEY ((movie_id, user_id))
);

//
INSERT INTO film JSON '{
"movie_id": "1",
"year": "2017",
"film_name": "Pirates of the Caribbean",
"producer": "Jerry Bruckheimer",
"user_id": "01",
"user_name": "Vlad",
"age": "21",
"city": "Kyiv"
}';

INSERT INTO film JSON '{
"movie_id": "2",
"year": "2010",
"film_name": "Inception",
"producer": "Christopher Nolan",
"user_id": "02",
"user_name": "Bob",
"age": "22",
"city": "NY"
}';


SELECT *
FROM film;

 UPDATE chernenko.film
 SET film_name = 'The Green Mile'
 WHERE movie_id = 2 AND user_id=2;
 
SELECT *
FROM film;

DROP TABLE IF EXISTS chernenko.film;


//with STATIC:

CREATE TABLE IF NOT EXISTS film(
	movie_id int,
	year int,
	film_name text STATIC,
	producer text,
	user_id int,
	user_name text STATIC,
	age int STATIC,
	city text,
		PRIMARY KEY ((movie_id, user_id), year)
);

//
INSERT INTO film JSON '{
"movie_id": "1",
"year": "2017",
"film_name": "Pirates of the Caribbean",
"producer": "Jerry Bruckheimer",
"user_id": "01",
"user_name": "Vlad",
"age": "21",
"city": "Kyiv"
}';

INSERT INTO film JSON '{
"movie_id": "2",
"year": "2010",
"film_name": "Inception",
"producer": "Christopher Nolan",
"user_id": "02",
"user_name": "Bob",
"age": "22",
"city": "NY"
}';


SELECT *
FROM film;

 UPDATE chernenko.film
 SET film_name = 'The Great Gatsby',
 	city = 'Poltava'
 WHERE movie_id = 2 AND user_id=2 AND year = 2010;
 
SELECT *
FROM film;

//
//DROP TABLE IF EXISTS chernenko.film;
//DROP KEYSPACE chernenko;




