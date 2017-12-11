
 drop table if exists "airport";
// 
 create table if not exists "airport"(
 	airport text,
 	planes SET<text>,
 	plane_isleave boolean,
 	primary Key (airport)
 );
 
DROP TABLE IF EXISTS "user_expences";

CREATE TABLE "user_expences" (
     user_name text,
     user_balance float static,
     service_code int,
     service_description text,
     service_iswish boolean,
     service_price float,
     
     PRIMARY KEY (user_name, service_code)
  );
  
DROP TABLE IF EXISTS "wish_list";

CREATE TABLE "wish_list" (
	
   flight_id int,
   flight_price float,
   flight_from text,
   flight_to text,
   flight_iswish boolean,
    PRIMARY KEY (flight_id)
);

 INSERT INTO "wish_list" (flight_id, flight_price, flight_from, flight_to, flight_iswish)
  VALUES (1, 25, 'Kiev', 'Paris', false );
  
   INSERT INTO "wish_list" (flight_id, flight_price, flight_from, flight_to, flight_iswish)
  VALUES (2, 45, 'Lviv', 'Moscow', true );
  
   INSERT INTO "wish_list" (flight_id, flight_price, flight_from, flight_to, flight_iswish)
  VALUES (3, 550, 'Kiev', 'New-York', false );

SELECT * FROM "wish_list";

 
  BEGIN BATCH

  INSERT INTO "user_expences" (user_name, user_balance) VALUES ('user1', 50) IF NOT EXISTS;
  
  INSERT INTO "user_expences" (user_name, service_code, service_description, service_iswish, service_price)
    VALUES ('user1', 3, 'wash car', false, 25.40);
    
  INSERT INTO "user_expences" (user_name, service_code,  service_description, service_iswish, service_price)
    VALUES ('user1', 2, 'watch film', false, 10);
    
  INSERT INTO "user_expences" (user_name, service_code,  service_description, service_iswish, service_price)
    VALUES ('user1', 1, 'fly abroad', true, 45);
    
APPLY BATCH;

SELECT * FROM "user_expences";

//find out current balance
SELECT DISTINCT user_balance FROM  "user_expences" WHERE user_name='user1';


BEGIN BATCH
    
 UPDATE "user_expences" SET service_iswish=false 
  	WHERE user_name='user1' AND  service_code = 1;
    
 UPDATE "user_expences" SET service_iswish=true 
  	WHERE user_name='user1' AND  service_code = 2;
  	
 UPDATE "user_expences" SET service_iswish=false 
  	WHERE user_name='user1' AND  service_code = 3;
  	
  	
 UPDATE "user_expences" 
  SET user_balance = 40
  	WHERE user_name='user1' IF user_balance=50;
 
APPLY BATCH;

SELECT * FROM "user_expences";

////////////////////////////////
DROP TABLE IF EXISTS flying_info;

CREATE TABLE IF NOT EXISTS flying_info(
	airport text, 
	day int, 
	arrived int,
	departured int,
	user_name text, 
	count counter, 
	
	PRIMARY KEY((airport),day,arrived,departured, user_name)
);

//date  
UPDATE flying_info SET count=count+20 WHERE airport='SmthAirport'
 AND day=20151221
 AND arrived=1
 AND departured=12
 AND user_name = 'Bob';
 
UPDATE flying_info SET count=count+50 WHERE airport='SmthAirport'
 AND day=20151221 
 AND arrived=2 
 AND departured=11
 AND user_name = 'Bob';
 
UPDATE flying_info SET count=count+93 WHERE airport='SmthAirport' 
	AND day=20151221 
	AND arrived=3 
	AND departured=10
	AND user_name = 'Bob';
//date 
UPDATE flying_info SET count=count+10 WHERE airport='SmthAirport'
 AND day=20151222
 AND arrived=4 
 AND departured=9
 AND user_name = 'Ann';
 
UPDATE flying_info SET count=count+74 WHERE airport='SmthAirport'
 AND day=20151222 
 AND arrived=5 
 AND departured=8
 AND user_name = 'Ann';
 
UPDATE flying_info SET count=count+24 WHERE airport='SmthAirport'
 AND day=20151222 
 AND arrived=6 
 AND departured=7
 AND user_name = 'Carl';
 //date 
UPDATE flying_info SET count=count+35 WHERE airport='SmthAirport' 
 AND day=20151223 
 AND arrived=7 
 AND departured=6
 AND user_name = 'Carl';
 
UPDATE flying_info SET count=count+26 WHERE airport='SmthAirport' 
 AND day=20151223 
 AND arrived=8 
 AND departured=5
 AND user_name = 'John';
 
UPDATE flying_info SET count=count+131 WHERE airport='SmthAirport'
 AND day=20151223 
 AND arrived=9 
 AND departured=4
 AND user_name = 'Bob';

 
SELECT * FROM flying_info;


//count arrived planes
CREATE OR REPLACE FUNCTION flyingCounter(state map<int,bigint>, arrived int, count counter)
RETURNS NULL ON NULL INPUT
RETURNS map<int,bigint>
LANGUAGE java
AS $$
	if(state.containsKey(arrived)) {
	  state.put(arrived,  (Long)state.get(arrived) + count); 
	} else {
	  state.put(arrived, count);
	}
	return state;
$$; 


CREATE OR REPLACE AGGREGATE groupCountByArrived(int, counter)
	SFUNC flyingCounter
	STYPE map<int,bigint>
	INITCOND {};
	
	
SELECT groupCountByArrived(arrived,count) 
	FROM flying_info 
	WHERE airport='SmthAirport'
	AND day>=20151221 AND day<=20151223;

	
//count departured planes
CREATE OR REPLACE FUNCTION flyingCounter(state map<int,bigint>, departured int, count counter)
RETURNS NULL ON NULL INPUT
RETURNS map<int,bigint>
LANGUAGE java
AS $$
	if(state.containsKey(departured)) {
	  state.put(departured,  (Long)state.get(departured) + count); 
	} else {
	  state.put(departured, count);
	}
	return state;
$$; 


CREATE OR REPLACE AGGREGATE groupCountByDepartured(int, counter)
	SFUNC flyingCounter
	STYPE map<int,bigint>
	INITCOND {};
	
	
	
SELECT groupCountByDepartured(departured,count) 
	FROM flying_info 
	WHERE airport='SmthAirport'
	AND day>=20151221 AND day<=20151223;
	

///////final function for arrived

CREATE OR REPLACE FUNCTION countArrived(state map<int,bigint>)
RETURNS NULL ON NULL INPUT
RETURNS bigint
LANGUAGE java 
AS $$
	if(state.containsKey("arrived")) {
	 return (Long)state.get("arrived");
	} else {
	 return 0L;
}$$;





CREATE OR REPLACE AGGREGATE groupCountByArrived(int, counter)
	SFUNC flyingCounter
	STYPE map<int,bigint>
	FINALFUNC countArrived
	INITCOND {};
	
	
SELECT groupCountByArrived(arrived,count) 
	FROM flying_info 
	WHERE airport='SmthAirport'
	AND day>=20151221 AND day<=20151223;	
	
	
-----------------------------------------------------
///////final function for departured

CREATE OR REPLACE FUNCTION countArrived(state map<int,bigint>)
RETURNS NULL ON NULL INPUT
RETURNS bigint
LANGUAGE java 
AS $$
	if(state.containsKey("arrived")) {
	 return (Long)state.get("arrived");
	} else {
	 return 0L;
}$$;


CREATE OR REPLACE AGGREGATE groupCountByArrived(int, counter)
	SFUNC flyingCounter
	STYPE map<int,bigint>
	FINALFUNC countArrived
	INITCOND {};
	
	
SELECT groupCountByArrived(arrived,count) 
	FROM flying_info 
	WHERE airport='SmthAirport'
	AND day>=20151221 AND day<=20151223;	
	
///////////////////
CREATE OR REPLACE FUNCTION countDeparturedState(state map<int, frozen<set<int>>>, airport_id int, user_name text)
    CALLED ON NULL INPUT
    RETURNS tuple<int, frozen<set<int>>>
    LANGUAGE java
    AS $$
  <INTEGER>Set aiports = new Set<INTEGET>();
  if (state.containsKey(user_name)) {
   state.put(user_name, flying_info.add(airport));
  }
        return state;
    $$;

CREATE OR REPLACE FUNCTION countDeparturedFinal (state map<int,frozen<set<int>>)
    CALLED ON NULL INPUT
    RETURNS map<int, int>
    LANGUAGE java
    AS $$
  for (int i=0; i < state.size(); i++){
   state.put(user_name, i);
  }
        return state;
    $$;

CREATE OR REPLACE AGGREGATE countAirport(int, int)
    SFUNC countDeparturedState
    STYPE tuple<int, frozen<set<int>>>
    INITCOND (0, 0);

SELECT countBank(airport, user_name) from flying_info;
  
  

 

