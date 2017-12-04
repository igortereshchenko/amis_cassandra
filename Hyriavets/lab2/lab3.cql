create type if not exists item_add(
	quantity		int,
	datetime		timestamp
);

create table if not exists "User"(
	user_id			int,
	balance			float,
	primary key(user_id)
);

create table if not exists "Order" (
	user_id				int,
	order_id 			int,
	item 				map<text, int>,
	invoiced			boolean,
	datetime			timestamp,
	order_price			float,
	primary key(user_id, order_id)
);

create table if not exists "AvailableItems" (
	item_name 		text,
	price 			float,
	orders			map<int, frozen<item_add>>,
	new_items		map<int, frozen<item_add>>,   
	primary key(item_name)
);

create table if not exists "WarehouseTrans" (
	warehousetrans_id 	int,
	item 				map<text, int>,
	status				boolean,
	datetime			timestamp,
	primary key(warehousetrans_id)
);

//CREATE INDEX work_key ON "Order" (KEYS(item)); 

//add products in warehouse
begin batch
insert into "AvailableItems" JSON '{ "item_name":"Gamburger","price":"5", "new_items" : 
									{ "1" : {"quantity":"32","datetime":"1945-08-20"}}}';									
									
insert into "AvailableItems" JSON '{ "item_name":"cheezeburger","price":"6", "new_items" : 
									{ "1" : {"quantity":"32","datetime":"1945-08-20"}}}';
insert into "WarehouseTrans"	JSON '{"warehousetrans_id":"1","item" : 
									{ "Gamburger" :"32","cheezeburger":"32"}, 
										"datetime":	"1945-08-20", "status":"true"}';						
apply batch;
select * from "AvailableItems"; 

//new User
insert into "User"   JSON '{"user_id":"1","balance":"50000.83"}';

//create wishList
insert into "Order"	 JSON '{"user_id":"1", "order_id":"12","item" : 
									{ "Gamburger" :"2","cheezeburger":"1"}, 
										"datetime":	"1945-08-20", "invoiced":"false", "order_price": "16"}';	
											

//new order 
begin batch
UPDATE "AvailableItems"  
		SET	orders =  orders + { 12 : {"quantity":1,"datetime":'1945-08-20'}}
				where item_name = 'Gamburger';		
							
UPDATE "AvailableItems"  
		SET	orders =  orders + { 12 : {"quantity":1,"datetime":'1945-08-20'}}
				where item_name = 'cheezeburger';
UPDATE "Order" 
		SET	item = { 'Gamburger' :1,'cheezeburger':1}, order_price = 11, invoiced = true
			where user_id = 1 AND order_id = 12;		
UPDATE "User"
		SET balance = 49989.83		
			where user_id = 1;	
apply batch;




select * from "User";
select * from "Order";
select * from "AvailableItems";
