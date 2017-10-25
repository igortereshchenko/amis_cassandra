//User visits cinema
CREATE KEYSPACE IF NOT EXISTS "Lymar"
WITH replication = {
	'class':'SimpleStrategy',
	'replication_factor':2
}
AND  DURABLE_WRITES =  true;

ALTER KEYSPACE "Lymar"
WITH replication = {
	'class':'SimpleStrategy',
	'replication_factor':3
} AND  DURABLE_WRITES =  true;

USE "Lymar";
CREATE TABLE IF NOT EXISTS "UserCinema" (
	userId int,
	userName text,
	name text,
	surname text,
	birthDate date,
	movieId int,
	movieName text,
	movieGenre text,
	movieDate date,
	PRIMARY KEY ((
		userId,
		birthDate),
		movieId));
		
INSERT INTO "UserCinema" (userId, username, name, surname, birthDate, movieId, movieName, movieGenre,movieDate)
VALUES (1,'user','User','Userkin','2001-05-03',1,'It','horror','2017-05-03');

UPDATE "UserCinema" set userName='lymar'
WHERE userId=1 AND birthDate='2001-05-03'and movieId=1  IF EXISTS;

DROP TABLE "UserCinema";
CREATE TABLE IF NOT EXISTS "UserCinema" (
	userId int,
	userName text static,
	name text,
	surname text,
	birthDate date,
	movieId int,
	movieName text static,
	movieGenre text static,
	movieDate date,
	PRIMARY KEY ((
		userId,
		birthDate),
		movieId));

INSERT INTO "UserCinema" (userId, username, name, surname, birthDate, movieId, movieName, movieGenre,movieDate)
VALUES (1,'user','User','Userkin','2001-05-03',1,'It','horror','2017-05-03');

UPDATE "UserCinema" set userName='lymar'
WHERE userId=1 and birthDate='2001-05-03' and  movieId=1  IF EXISTS;

DROP TABLE "UserCinema";
DROP KEYSPACE "Lymar";		