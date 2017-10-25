//Create all table
drop table if exists pets;

CREATE TYPE IF NOT EXISTS meal(
	meal_name text,
	amount int
);

create table if not exists  pets(
	pet_id int,
	pet_name text,
	pet_meal set<frozen<meal>>,
	PRIMARY KEY(pet_id)
);

drop table if exists meal_warehouse;

create table if not exists  meal_warehouse(
    meal_name text,
    meal_left_amount int,
	PRIMARY KEY(meal_name)
);
create index on meal_warehouse (meal_left_amount);
//=========================

//Insert data into table==========
insert into pets json '{
	"pet_id":1,
	"pet_name" : "GoodBoy",
	"pet_meal": [{"meal_name": "Meet", "amount": 10}, {"meal_name": "Bone", "amount": 10}]
}';

insert into pets json '{
	"pet_id":2,
	"pet_name" : "Kesha",
	"pet_meal": [{"meal_name": "Corn", "amount": 1}]
}';

insert into meal_warehouse json '{
"meal_name": "Meat",
"meal_left_amount": 20
}';

insert into meal_warehouse json '{
"meal_name": "Bone",
"meal_left_amount": 20
}';

insert into meal_warehouse json '{
"meal_name": "Corn",
"meal_left_amount": 1
}';
//=============================


//Get all meal for my pet Kesha
select json pet_meal from pets
where pet_id = 2;

//Update amount at warehouse
update meal_warehouse
set  meal_left_amount = 0
where meal_name = 'Corn';

//Select all meal that have meal_left_amount = 0
select json *
from meal_warehouse
where meal_left_amount = 0;



