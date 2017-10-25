drop table if exists userbank;
drop table if exists bankuser;

CREATE TYPE IF NOT EXISTS user_name(
	firstname text,
	middlename text,
	lastname text
);

CREATE TYPE IF NOT EXISTS  payment_history(
	user_payment float,
	payment_date timestamp,
	percent float,
	debt float
);

create table if not exists userbank(
	user_id int,
	fio FROZEN<user_name>,
	history MAP<text, FROZEN<payment_history>>,
	PRIMARY KEY(user_id)
);


create table if not exists  bankuser(
	bank_name text,
	users set<int>,
	PRIMARY KEY(bank_name)
);

insert into userbank JSON '{
	"user_id":1,
	"fio": {"firstname":"Boris","middlename":"Olegovich","lastname":"Lymar"},
	"history": {"Alpha":{"payment_date":"2016-09-20","debt":5000,"percent":1,"user_payment":5000}}
}';

insert into bankuser JSON '{
"bank_name":"Alpha",
"users":[1]
}';
