CREATE KEYSPACE if not exists yurchuk
WITH replication = {'class': 'SimpleStrategy', 
					'replication_factor' : 2};
					
alter keyspace yurchuk
with replication = {'class': 'SimpleStrategy',
					'replication_factor': 3};

//Create table without static fields
drop table if exists yurchuk.cinema_session;

create table if not exists yurchuk.cinema_session(
	cinema_id text,
	name text,
	address text, 
	phone_num text,
	begin_time timestamp,
	movie_name text,
	hall_name text,
	age_limit smallint,
	sold_tickets smallint,
	premier boolean,
	primary key((cinema_id), begin_time, movie_name, hall_name)
);
use yurchuk;
INSERT INTO cinema_session (cinema_id, name, address, phone_num, begin_time, movie_name, hall_name, age_limit, sold_tickets, premier )
VALUES ('1', 'First', 'New York, 5 Avenue', '+380921231212', '2017-11-11 04:05+0000', 'Harry Potter', 'Red', 12, 43, true);

INSERT INTO cinema_session (cinema_id, name, address, phone_num, begin_time, movie_name, hall_name, age_limit, sold_tickets, premier )
VALUES ('2', 'Second', 'California, 23 Avenue', '+380967534445', '2017-11-03 12:05+0000', 'Baby', 'Red', 12, 35, false);

INSERT INTO cinema_session (cinema_id, name, address, phone_num, begin_time, movie_name, hall_name, age_limit, sold_tickets, premier )
VALUES ('1', 'First', 'New York, 5 Avenue', '+380921231212', '2011-11-11 06:05+0000', 'Harry Potter', 'Red', 12, 63, true);

select * from yurchuk.cinema_session;

//Update 3-rd record. address is common for all session in one cinema
 
UPDATE yurchuk.cinema_session set address = 'Kiev, Khreshchatyk'
where begin_time = '2011-11-11 06:05+0000' 
      AND movie_name = 'Harry Potter'
      AND hall_name = 'Red'
	  AND cinema_id = '1';
	 
select * from yurchuk.cinema_session;


//Repeat with static fields
drop table if exists yurchuk.cinema_session;

create table if not exists yurchuk.cinema_session(
	cinema_id text,
	name text STATIC,
	address text STATIC, 
	phone_num text STATIC,
	begin_time timestamp,
	movie_name text,
	hall_name text,
	age_limit smallint,
	sold_tickets smallint,
	premier boolean,
	primary key((cinema_id), begin_time, movie_name, hall_name)
);

use yurchuk;
INSERT INTO cinema_session (cinema_id, name, address, phone_num, begin_time, movie_name, hall_name, age_limit, sold_tickets, premier )
VALUES ('1', 'First', 'New York, 5 Avenue', '+380921231212', '2017-11-11 04:05+0000', 'Harry Potter', 'Red', 12, 43, true);

INSERT INTO cinema_session (cinema_id, name, address, phone_num, begin_time, movie_name, hall_name, age_limit, sold_tickets, premier )
VALUES ('2', 'Second', 'California, 23 Avenue', '+380967534445', '2017-11-03 12:05+0000', 'Baby', 'Red', 12, 35, false);

INSERT INTO cinema_session (cinema_id, name, address, phone_num, begin_time, movie_name, hall_name, age_limit, sold_tickets, premier )
VALUES ('1', 'First', 'New York, 5 Avenue', '+380921231212', '2011-11-11 06:05+0000', 'Harry Potter', 'Red', 12, 63, true);

select * from yurchuk.cinema_session;

//Wrong Update
UPDATE yurchuk.cinema_session set address = 'Kiev, Khreshchatyk'
where begin_time = '2011-11-11 06:05+0000' 
      AND movie_name = 'Harry Potter'
      AND hall_name = 'Red'
	  AND cinema_id = '1';
	  
//Update address for all sessiom in that cinema
UPDATE yurchuk.cinema_session set address = 'Kiev, Khreshchatyk', sold_tickets = 22
where begin_time = '2011-11-11 06:05+0000' 
      AND movie_name = 'Harry Potter'
      AND hall_name = 'Red'
	  AND cinema_id = '1';

select * from yurchuk.cinema_session;

//Drop all
drop table if exists yurchuk.cinema_session;
drop keyspace if exists yurchuk;