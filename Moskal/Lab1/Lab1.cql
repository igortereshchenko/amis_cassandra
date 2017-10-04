/*
Task:
1. Create keyspace named as "moskal" with replication factor 7.
2. Alter keyspace named as "moskal" with replication factor 8 using command ALTER.
3. Create table which describes 1 to N relation "User purchase books from store". Each entity should have atleast 3 attributes in addition to key attributes.
4. Populate table from step 3 with data.
5. Update record to create example of nonconsistent data.
6. Recreate table so attributes of main entity are marked with static keyword.
7. Populate table from step 6 with data.
8. Update record and check that data are still consistent.
9. Drop created tables and keyspaces
*/

-- 1
create keyspace if not exists "moskal" with replication = {'class':'SimpleStrategy', 'replication_factor':7};

-- 2
alter keyspace "moskal" with replication = {'class':'SimpleStrategy', 'replication_factor':8};

use "moskal";

-- 3
create table if not exists purchased_books(
    user_email text,
    user_first_name text,
    user_last_name text,
    user_birthday date,
    book_isbn text,
    bookstore_name text,
    book_title text,
    book_description text,
    book_year int,
    PRIMARY KEY(user_email, book_isbn, bookstore_name)
);

-- 4
insert into purchased_books(user_email, user_first_name, user_last_name, user_birthday, book_isbn, bookstore_name, book_title, book_description, book_year)
values ('u1@gmail.com', 'John', 'Smith', '1970-01-01', '0000-0001', 'Amazon', 'The C Programming Language', 'Bestseller', 1978);

insert into purchased_books(user_email, user_first_name, user_last_name, user_birthday, book_isbn, bookstore_name, book_title, book_description, book_year)
values ('u1@gmail.com', 'John', 'Smith', '1970-01-01', '0000-0002', 'Amazon', 'The Go Programming Language', 'Bestseller', 2015);

insert into purchased_books(user_email, user_first_name, user_last_name, user_birthday, book_isbn, bookstore_name, book_title, book_description, book_year)
values ('u2@gmail.com', 'Rob', 'Pike', '1956-01-01', '0000-0002', 'Amazon', 'The Go Programming Language', 'Bestseller', 2015);

select * from purchased_books;

-- 5
update purchased_books set user_birthday='2000-12-31' where user_email='u1@gmail.com' and book_isbn='0000-0001' and bookstore_name='Amazon';
select user_email, user_first_name, user_last_name, user_birthday from purchased_books where user_email='u1@gmail.com';

-- 6
drop table purchased_books;
create table if not exists purchased_books(
    user_email text,
    user_first_name text STATIC,
    user_last_name text STATIC,
    user_birthday date STATIC,
    book_isbn text,
    bookstore_name text,
    book_title text,
    book_description text,
    book_year int,
    PRIMARY KEY(user_email, book_isbn, bookstore_name)
);

-- 7
insert into purchased_books(user_email, user_first_name, user_last_name, user_birthday, book_isbn, bookstore_name, book_title, book_description, book_year)
values ('u1@gmail.com', 'John', 'Smith', '1970-01-01', '0000-0001', 'Amazon', 'The C Programming Language', 'Bestseller', 1978);

insert into purchased_books(user_email, user_first_name, user_last_name, user_birthday, book_isbn, bookstore_name, book_title, book_description, book_year)
values ('u1@gmail.com', 'John', 'Smith', '1970-01-01', '0000-0002', 'Amazon', 'The Go Programming Language', 'Bestseller', 2015);

insert into purchased_books(user_email, user_first_name, user_last_name, user_birthday, book_isbn, bookstore_name, book_title, book_description, book_year)
values ('u2@gmail.com', 'Rob', 'Pike', '1956-01-01', '0000-0002', 'Amazon', 'The Go Programming Language', 'Bestseller', 2015);

select * from purchased_books;

-- 8
update purchased_books set user_birthday='2000-12-31', book_year=1978 where user_email='u1@gmail.com' and book_isbn='0000-0001' and bookstore_name='Amazon';
select user_email, user_first_name, user_last_name, user_birthday from purchased_books where user_email='u1@gmail.com';

-- 9
drop table purchased_books;
drop keyspace moskal;
