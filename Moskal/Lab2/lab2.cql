te keyspace if not exists "moskal" with replication = {'class':'SimpleStrategy', 'replication_factor':1};

use moskal;

create table oil_station (
  id bigint,
  oil_reserve map<text, double>, //{'A-98' -> 100.},
  last_reserve_update timeuuid,
  primary key(id)
);

create table driver (
  id bigint,
  cars map<text, frozen<tuple<text, text, double>>>, // 'XX-0000-XX' -> <'BMW', 'A-98', 50.>,
  primary key(id)
);

create table purchase (
  station_id bigint,
  purchase_id timeuuid,
  driver_id bigint,
  car_number text,
  requested double,
  fulfilled double,
  processed boolean,
  primary key(station_id, purchase_id)
);
	
insert into oil_station(id, oil_reserve, last_reserve_update) values(1, {'A-95': 1000.,'A-98': 2000.}, e20d7290-b96f-11e7-aba8-59e4aadf0108/*now()*/);
insert into oil_station(id, oil_reserve, last_reserve_update) values(2, {'A-95': 2000.,'A-98': 4000.}, e20d7290-b96f-11e7-aba8-59e4aadf0108/*now()*/);

select * from oil_station;

insert into driver(id, cars) values(1, {'AA-1111-AA':('BMW','A-98',50.), 'AA-1111-AB':('AUDI','A-98',60.)});
insert into driver(id, cars) values(2, {'AB-1111-AA':('BMW2','A-98',50.), 'AB-1111-AB':('AUDI2','A-98',60.)});

select * from driver;

//create requests
insert into purchase(station_id, purchase_id, driver_id, car_number, requested, fulfilled, processed)
values(1, 71c0e740-b971-11e7-aba8-59e4aadf0108/*now()*/, 1, 'AA-1111-AA', 100., 0., false);
insert into purchase(station_id, purchase_id, driver_id, car_number, requested, fulfilled, processed)
values(1, 71c15c71-b971-11e7-aba8-59e4aadf0108/*now()*/, 2, 'AB-1111-AA', 150., 0., false);
select * from purchase;

select last_reserve_update from oil_station where id=2;
//e20d7290-b96f-11e7-aba8-59e4aadf0108

select * from purchase where station_id=1 and purchase_id >e20d7290-b96f-11e7-aba8-59e4aadf0108 order by purchase_id limit 1;
//1,71c0e740-b971-11e7-aba8-59e4aadf0108,AA-1111-AA,1,0.0,false,100.0

select cars from driver where id=1;
//"{'AA-1111-AA': ('BMW','A-98',50.0), 'AA-1111-AB': ('AUDI','A-98',60.0)}"
select oil_reserve from oil_station where id=1;
//"{'A-95': 1000.0, 'A-98': 2000.0}"

update oil_station set oil_reserve['A-98']=1950, last_reserve_update=71c0e740-b971-11e7-aba8-59e4aadf0108 where id=1;
update purchase set fulfilled = 50, processed=true where station_id=1 and purchase_id=71c0e740-b971-11e7-aba8-59e4aadf0108;

drop keyspace moskal;
