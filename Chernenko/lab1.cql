// Користувач відвідує кінотеатр, тобто дивиться фільми.

//Код таблиці без STATIC:
CREATE TABLE IF NOT EXISTS film(
	movie_id int,
	name text,
	year int,
	producer text,
	PRIMARY KEY ((movie_id))
);

INSERT INTO film (movie_id, name, year, producer)
VALUES (
1,
'Pirates',
2017,
'Gatsby');

INSERT INTO film JSON '{
"movie_id": "2",
"name": "Horror",
"year": "2008",
"producer": "Brain"
}';

INSERT INTO film (movie_id, name, year, producer)
VALUES (
1,
'Owls',
2016,
'Gatsby');

//SELECT *
//FROM film;

//Код таблиці з STATIC:

CREATE TABLE IF NOT EXISTS film2(
	movie_id int,
	name text STATIC,
	year int,
	producer text STATIC,
	PRIMARY KEY ((movie_id), year)
);
INSERT INTO film2 (movie_id, name, year, producer)
VALUES (
1,
'Pirates',
2017,
'Gatsby');

INSERT INTO film2 JSON '{
"movie_id": "2",
"name": "Horror",
"year": "2008",
"producer": "Brain"
}';

INSERT INTO film2 (movie_id, name, year, producer)
VALUES (
1,
'Owls', // після зміни цього поля яке є STATIC, в одному і тому записі має бути ERROR
2017,
'Gatsby');



//DROP TABLE film2;

SELECT *
FROM film2;

//DROP TABLE IF EXISTS Chernenko.film;
//DROP TABLE IF EXISTS Chernenko.film2;
//
//DROP KEYSPACE Chernenko;
//



