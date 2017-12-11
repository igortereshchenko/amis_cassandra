/**
Автомобілі і його заправки
Заправки і їх оборот
*/
create keyspace if not exists "moskal" with replication = {'class':'SimpleStrategy', 'replication_factor':1};

use moskal;

create type if not exists vehicle (
  plate_number text,
  model text,
  tank_volume float
);

create type if not exists petrol_type (
  name text,
  price float
);

create type if not exists purchase (
  volume float,
  price float
);

create type if not exists transaction_id (
  station_id bigint,
  user_id bigint,
  car frozen<vehicle>,
  petrol frozen<petrol_type>,
  time timestamp
);

create table if not exists oil_station (
  id bigint,
  last_oil_reserve_state map<frozen<petrol_type>, frozen<transaction_id>>,
  primary key(id)
);

create table if not exists driver (
  id bigint,
  cars_tanks map<frozen<vehicle>, frozen<transaction_id>>,
  last_balance_state frozen<transaction_id>,
  primary key(id)
);

create table transactions (
  id frozen<transaction_id>,

  station_id bigint,
  user_id bigint,
  car frozen<vehicle>,
  petrol frozen<petrol_type>,
  time timestamp,

  station_replenishment frozen<purchase>,
  purchase frozen<purchase>,
  station_volume float,
  car_tank_fullness float,
  user_balance float,
  //user_balance_ancestor frozen<transaction_id>,
  //car_tank_fullness_ancestor frozen<transaction_id>,
  //station_volume_ancestor frozen<transaction_id>,
  primary key(id)
);

create index idx_station_id on transactions(station_id);
create index idx_car on transactions(car);

create table wish_list (
  date date,
  driver_id bigint,
  wishes map<text, float>, // petrol -> desired volume
  primary key(date, driver_id)
);

//Create station
insert into oil_station (id, last_oil_reserve_state) values(1, null);

//Resupply oil_station
begin batch
insert into transactions ("id", station_id, petrol, time, "station_volume", station_replenishment)
    values ({station_id:1,petrol:{name:'A-95',price:35},time:'2017-11-19 09:00:00'}, 1, {name:'A-95',price:35},'2017-11-19 09:00:00', 1000, {volume:1000, price: 30});

update oil_station
    set last_oil_reserve_state[{name:'A-95',price:35}]={station_id:1,petrol:{name:'A-95',price:35},time:'2017-11-19 09:00:00'}
    where id = 1;
apply batch;

//Create user
begin batch

insert into transactions(id, user_id, car, time, car_tank_fullness, user_balance)
values ({
        user_id:1,
        car:{plate_number:'aa-0000-aa',model:'A4',tank_volume:60},
        time:'2017-11-19 10:00:00'
    },
    1, {plate_number:'aa-0000-aa',model:'A4',tank_volume:60},'2017-11-19 10:00:00',
    20,
    5000);

insert into driver(id, cars_tanks)
values(1, {
    {plate_number:'aa-0000-aa',model:'A4',tank_volume:60}:
        {
            user_id:1,
            car:{plate_number:'aa-0000-aa',model:'A4',tank_volume:60},
            time:'2017-11-19 10:00:00'
        }
    });

insert into wish_list(date, driver_id, wishes) values('2017-11-19', 1, {'A-95':50});

apply batch;

//Driver refills the tank
begin batch
insert into transactions(id, station_id, user_id, car, petrol, time, purchase, station_volume, car_tank_fullness, user_balance)
values ({
        station_id:1,
        user_id:1,
        car:{plate_number:'aa-0000-aa',model:'A4',tank_volume:60},
        petrol:{name:'A-95',price:35},
        time:'2017-11-19 10:00:00'
    },
    1, 1, {plate_number:'aa-0000-aa',model:'A4',tank_volume:60}, {name:'A-95',price:35}, '2017-11-19 10:00:00',
    {
       volume:10,
       price:35
    },
    990,
    30,
    4650);

update driver
set cars_tanks[{plate_number:'aa-0000-aa',model:'A4',tank_volume:60}] = {
        station_id:1,
        user_id:1,
        car:{plate_number:'aa-0000-aa',model:'A4',tank_volume:60},
        petrol:{name:'A-95',price:35},
        time:'2017-11-19 10:00:00'
    },
    last_balance_state={
        station_id:1,
        user_id:1,
        car:{plate_number:'aa-0000-aa',model:'A4',tank_volume:60},
        petrol:{name:'A-95',price:35},
        time:'2017-11-19 10:00:00'
    }
    where id=1;

update oil_station
set last_oil_reserve_state[{name:'A-95',price:35}] = {
        station_id:1,
        user_id:1,
        car:{plate_number:'aa-0000-aa',model:'A4',tank_volume:60},
        petrol:{name:'A-95',price:35},
        time:'2017-11-19 10:00:00'
    }
    where id = 1;

apply batch;

CREATE OR REPLACE FUNCTION cumulateRefills(state map<text,float>, plateNumber text, volume float)
RETURNS NULL ON NULL INPUT
RETURNS map<text,float>
LANGUAGE java
AS $$
	if(state.containsKey(platenumber)) {
	  state.put(platenumber,  (Long)state.get(platenumber) + volume); 
	} else {
	  state.put(platenumber, volume);
	}
	return state;
$$; 

CREATE OR REPLACE AGGREGATE aggregateRefills(text, float)
SFUNC cumulateRefills
STYPE map<text,float>
INITCOND {};

select aggregateRefills(car.plate_number, purchase.volume) from transactions where car ={plate_number:'aa-0000-aa',model:'A4',tank_volume:60};


CREATE OR REPLACE FUNCTION cumulateTurnover(state map<bigint,float>, station_id bigint, income float, outcome float)
CALLED ON NULL INPUT
RETURNS map<bigint,float>
LANGUAGE java
AS $$
    float turnover = 0;
    if (income != null) {
        turnover += income;
    }
    if (outcome != null) {
        turnover += outcome;
    }
    if (station_id != null) {
        if(state.containsKey(station_id)) {
          state.put(station_id,  (float)state.get(station_id) + turnover); 
        } else {
          state.put(station_id, turnover);
        }
    }
	return state;
$$; 

CREATE OR REPLACE AGGREGATE aggregateTurnover(bigint, float, float)
SFUNC cumulateTurnover
STYPE map<bigint,float>
INITCOND {};

select aggregateTurnover(station_id, station_replenishment.volume, purchase.volume) from transactions; 

drop keyspace moskal;
