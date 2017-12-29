CREATE KEYSPACE bd
WITH replication = {
	'class' : 'SimpleStrategy',
	'replication_factor' : 1
};

use bd;

create table if not exists buyer
(
	buyer_id int,
	buyer_name text,
	buyer_balance float,
	primary key (buyer_id)
);

// if pokypka then -, if postavka then + for count and price
create table if not exists operations
(
	operation_id int,
	operation_date date,
	product_name text,
	product_count int,
	product_price float,
	wh_name text,
	producer_name text,
	buyer_id int,
	primary key (operation_id, operation_date)
);

create index buyer_id on operations (buyer_id);

//data
INSERT INTO buyer JSON 
'{ 
	"buyer_id":1,
	"buyer_name":"Кармен Тотунховая",
	"buyer_balance": 100.0 
}';

INSERT INTO buyer JSON 
'{ 
	"buyer_id":2,
	"buyer_name":"Вася Пупкін",
	"buyer_balance": 0 
}';

UPDATE buyer
	SET buyer_balance=200 
WHERE buyer_id=2;

//postavka
INSERT INTO operations JSON 
'{ 
	"operation_id": 1,
	"operation_date": "2017-12-23",
	"product_name": "Картопля",
 	"product_count": 100,
	"product_price": -10,
	"wh_name": "АТБ",
	"producer_name": "УКРПоле",
	"buyer_id": null
}';

INSERT INTO operations JSON 
'{ 
	"operation_id": 2,
	"operation_date": "2017-12-23",
	"product_name": "Морква",
 	"product_count": 100,
	"product_price": -20,
	"wh_name": "АТБ",
	"producer_name": "УКРТеплиця",
	"buyer_id": null
}';

INSERT INTO operations JSON 
'{ 
	"operation_id": 3,
	"operation_date": "2017-12-23",
	"product_name": "Кукурудза",
 	"product_count": 100,
	"product_price": -30,
	"wh_name": "АТБ",
	"producer_name": "Бондюель",
	"buyer_id": null
}';

//pokypka
BEGIN BATCH

INSERT INTO operations JSON 
'{ 
	"operation_id": 4,
	"operation_date": "2017-12-24",
	"product_name": "Картопля",
 	"product_count": -1,
	"product_price": 10,
	"wh_name": "АТБ",
	"producer_name": null,
	"buyer_id": 1
}';

UPDATE buyer 
  SET buyer_balance = 90 
  	WHERE buyer_id=1;

APPLY BATCH;


//pokypka
BEGIN BATCH

INSERT INTO operations JSON 
'{ 
	"operation_id": 5,
	"operation_date": "2017-12-24",
	"product_name": "Морква",
 	"product_count": -1,
	"product_price": 20,
	"wh_name": "АТБ",
	"producer_name": null,
	"buyer_id": 2
}';

UPDATE buyer 
  SET buyer_balance = 180 
  	WHERE buyer_id=2;

APPLY BATCH;

select *from operations;
select *from buyer;


////how many buyer bought smth
CREATE OR REPLACE FUNCTION cumulateSum(state map<int,int>, buyer_id int)
RETURNS NULL ON NULL INPUT
RETURNS map<int,int>
LANGUAGE java
AS $$
	if(state.containsKey(buyer_id)) 
	{
	  state.put(buyer_id,  ((int)state.get(buyer_id)) + 1); 
	} 
	else 
	{
	  state.put(buyer_id, 1);
	}
	return state;
$$; 

CREATE OR REPLACE AGGREGATE groupCountByProduct(int)
	SFUNC cumulateSum
	STYPE map<int,int>
	INITCOND {};
	
SELECT groupCountByProduct(buyer_id) 
	FROM operations;
	
	
/////how many prod wh sold
CREATE OR REPLACE FUNCTION calcSum(state map<text,int>, product_name text, product_price float)
RETURNS NULL ON NULL INPUT
RETURNS map<text,int>
LANGUAGE java
AS $$
	if(product_price > 0)
		return state;

	if(state.containsKey(product_name)) {
	 state.put(product_name,  ((int)state.get(product_name)) + 1); 
	} 
	else 
	{
	  state.put(product_name, 1);
	}
	return state;
$$; 

CREATE OR REPLACE AGGREGATE calcProduct(text, float)
	SFUNC calcSum
	STYPE map<text,int>
	INITCOND {};
	
SELECT calcProduct(product_name, product_price) 
	FROM operations;
