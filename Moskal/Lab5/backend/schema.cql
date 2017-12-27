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

create table if not exists gas_station (
  id timeuuid,
  name text,
  last_oil_reserve_state map<frozen<petrol_type>, timeuuid>,
  primary key(id)
);

create table if not exists driver (
  id timeuuid,
  name text,
  cars_tanks map<frozen<vehicle>, timeuuid>,
  last_balance_state timeuuid,
  primary key(id)
);

create table transactions (
  id timeuuid,

  station_id timeuuid,
  driver_id timeuuid,
  car frozen<vehicle>,
  petrol frozen<petrol_type>,
  time timestamp,

  station_replenishment frozen<purchase>,
  purchase frozen<purchase>,
  station_volume float,
  car_tank_usage float,
  car_tank_fullness float,
  user_balance float,
  user_balance_replenishment float,
  //user_balance_ancestor frozen<transaction_id>,
  //car_tank_fullness_ancestor frozen<transaction_id>,
  //station_volume_ancestor frozen<transaction_id>,
  primary key(id)
);

create index idx_station_id on transactions(station_id);
create index idx_driver_id on transactions(driver_id);
create index idx_car on transactions(car);

create table wish_list (
  date date,
  driver_id timeuuid,
  wishes map<text, float>, // petrol -> desired volume
  primary key(date, driver_id)
);


CREATE OR REPLACE FUNCTION cumulateTurnover(state map<frozen<petrol_type>,float>, petrol petrol_type, income float, outcome float)
CALLED ON NULL INPUT
RETURNS map<frozen<petrol_type>,float>
LANGUAGE java
AS $$
   float turnover = 0;
   if (income != null) {
       turnover += income;
   }
   if (outcome != null) {
       turnover += outcome;
   }
   if (petrol != null) {
       if(state.containsKey(petrol)) {
         state.put(petrol,  (float)state.get(petrol) + turnover); 
       } else {
         state.put(petrol, turnover);
       }
   }
return state;
$$; 

CREATE OR REPLACE AGGREGATE aggregateTurnover(petrol_type, float, float)
SFUNC cumulateTurnover
STYPE map<frozen<petrol_type>,float>
INITCOND {};

select aggregateTurnover(station_id, station_replenishment.volume, purchase.volume) from transactions; 

CREATE OR REPLACE FUNCTION cumulateRefills(state map<frozen<Vehicle>,float>, vehicle Vehicle, volume float)
RETURNS NULL ON NULL INPUT
RETURNS map<frozen<Vehicle>,float>
LANGUAGE java
AS $$
if(state.containsKey(vehicle)) {
  state.put(vehicle,  (Long)state.get(vehicle) + volume);
} else {
  state.put(vehicle, volume);
}
return state;
$$;

CREATE OR REPLACE AGGREGATE aggregateRefills(Vehicle, float)
SFUNC cumulateRefills
STYPE map<frozen<Vehicle>,float>
INITCOND {};
select aggregaterefills(car, purchase.volume) from transactions where driver_id=86d2fdb9-ea6a-11e7-a703-f0761c1be2e3;

drop keyspace moskal;
