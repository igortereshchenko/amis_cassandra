create table if not exists "Order" (
	order_id 			int,
	item 				map<text, int>,
	primary key(order_id)
);

create table if not exists "AvailableItems" (
	item_name 		text,
	quantity		int,
	price 			float,
	primary key(item_name)
);

create table if not exists "Invoice" (
	order_id 			int,
	item 				map<text, int>,
	orderitemtime    	timestamp,
	primary key(order_id)
);
CREATE INDEX work_key ON "Order" (KEYS(item)); 

//add products in warehouse
insert into "AvailableItems" JSON '{ "item_name":"Gamburger", "quantity":"13", "price":"4.5"}';
insert into "AvailableItems" JSON '{ "item_name":"Cheeseburger", "quantity":"2", "price":"5.5"}';

//add new order
insert into "Order" JSON '{ "order_id":"1", "item":{"Gamburger":"7","Cheeseburger":"2"}}';

//change order
UPDATE "Order"
  SET item['Cheeseburger']=  4
  	WHERE order_id  = 1;  


select item from "Order"
	where item CONTAINS KEY 'Cheeseburger';

select price, quantity from "AvailableItems"
	where item_name = 'Cheeseburger';
	
select price, quantity from "AvailableItems"
	where item_name = 'Gamburger';
	
//change order to warehouse quantity 
UPDATE "Order"
  SET item['Cheeseburger']=  4
  	WHERE order_id  = 2;  	

//create invoice only 1 time
insert into "Invoice" JSON '{ "order_id":"1", "item":{"Gamburger":"7","Cheeseburger":"2"},"orderitemtime":"2012-12-31 00:00:00"}';
update "AvailableItems"
	set quantity = 0
		where item_name = 'Cheeseburger';
		
update "AvailableItems"
	set quantity = 6
		where item_name = 'Gamburger';	
		

select * from "Order";
select *from "Invoice";
select * from "AvailableItems";
