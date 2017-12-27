//drop type if exists username;
//drop type if exists wish_credit;
drop table if exists user;
drop table if exists bank;
drop table if exists credit;
drop table if exists bankOperation;
//drop table if exists wish_list;
//drop function if exists countBankFinal;
drop function if exists stateGroupSum;
//drop function if exists countBank;
drop function if exists stateGroup;
drop function if exists groupFinal;



CREATE TYPE IF NOT EXISTS user_name(
	firstname text,
	middlename text,
	lastname text
);

//CREATE TYPE IF NOT EXISTS wish_credit(
//	bank_id int,
//	credit_id int
//);

create table if not exists user(
	user_id uuid,
	fio FROZEN<user_name>,
	balance float,
	PRIMARY KEY(user_id)
);

create table if not exists  bank(
	bank_id uuid,
	bank_name text,
	users set<uuid>,
	PRIMARY KEY(bank_id)
);

create table if not exists credit(
	credit_id uuid,
	percent float,
	term int,
	debt float,
	PRIMARY KEY(credit_id)
);

create table if not exists  bankOperation(
	bank_operation_id uuid,
	user_id uuid,
	bank_id uuid,
	credit_id uuid,
	remaining int,
	user_balance_account int, 
	operation_date timestamp,
	PRIMARY KEY(bank_operation_id)
);


//create table if not exists user(
//	user_id int,
//	fio FROZEN<user_name>,
//	balance float,
//	PRIMARY KEY(user_id)
//);
//
//create table if not exists  bank(
//	bank_id int,
//	bank_name text,
//	users set<int>,
//	PRIMARY KEY(bank_id)
//);
//
//create table if not exists credit(
//	credit_id int,
//	percent float,
//	term int,
//	debt float,
//	PRIMARY KEY(credit_id)
//);

//credit_id = 1, remaining = 15000, user_balance = null взяв кредит
//credit_id = 1 bank_id =1  user_id = 1 remaining = null user_balance = null хоче кредит

//create table if not exists  bankOperation(
//	bank_operation_id int,
//	user_id int,
//	bank_id int,
//	credit_id int,
//	remaining int,
//	user_balance_account int, 
//	operation_date timestamp,
//	PRIMARY KEY(bank_operation_id)
//);

//create table if not exists wish_list(
//	user_wish_id int,
//	user_id int,
//	wish_list MAP<text, FROZEN<wish_credit>>, //<date,wish>
//	PRIMARY KEY (user_wish_id)
//);
//
//insert into user JSON '{
//	"user_id":1,
//	"fio": {"firstname":"Vasyl","middlename":"Mykolayovych","lastname":"Borovetc"},
//	"balance":2000
//}';
//
//insert into bank JSON '{
//	"bank_id":1,
//	"bank_name":"Alpha"
//}';
//
//insert into bank JSON '{
//	"bank_id":2,
//	"bank_name":"Privat"
//}';
//
//
//BEGIN BATCH
//	UPDATE bank
//	SET users = {1}
//	WHERE bank_id = 1;
//	
//	insert into credit JSON '{
//		"credit_id":1,
//		"debt":2000,
//		"percent": 1,
//		"term": 8
//	}';
//	
//	insert into credit JSON '{
//		"credit_id":2,
//		"debt":1500,
//		"percent": 0.5,
//		"term": 2
//	}';
//	
//	insert into credit JSON '{
//		"credit_id":3,
//		"debt":0,
//		"percent": 1,
//		"term": 3
//	}';
//	
//
//	insert into bankOperation JSON '{
//		"bank_operation_id":1,
//		"user_id": 1,
//		"credit_id":1,
//		"bank_id":1,
//		"remaining":2000,
//		"operation_date": "2017-12-01"
//	}';
//	
//	insert into wish_list JSON '{
//		"user_wish_id":1,
//		"user_id":1,
//		"wish_list":{
//			"2017-12-02":{
//				"bank_id":1,
//				"credit_id":2
//			}
//		}
//	}';
	
//APPLY BATCH;
// 
//BEGIN BATCH
//insert into bankOperation JSON '{
//		"bank_operation_id":2,
//		"user_id": 1,
//		"bank_id":1,
//		"credit_id":1,
//		"remaining":1000,
//		"user_balance_account":1000,
//		"operation_date": "2017-12-02"
//	}';
//
//UPDATE user
//	SET balance = 18000
//	WHERE user_id = 1;
//	
//APPLY BATCH;
//
//BEGIN BATCH
//insert into bankOperation JSON '{
//		"bank_operation_id":3,
//		"user_id": 1,
//		"bank_id":1,
//		"credit_id":1,
//		"remaining":0,
//		"user_balance_account": 1000,
//		"operation_date": "2017-12-03"
//	}';
//
//UPDATE user
//	SET balance = 0
//	WHERE user_id = 1;
//	
//APPLY BATCH;
//
//BEGIN BATCH
//insert into bankOperation JSON '{
//		"bank_operation_id":4,
//		"user_id": 1,
//		"bank_id":1,
//		"operation_date": "2017-12-24"
//	}';
//
//UPDATE user
//	SET balance = 0
//	WHERE user_id = 1;
//	
//APPLY BATCH;

//
//sum money for bank
CREATE OR REPLACE FUNCTION stateGroupSum( state tuple<int,int>, credit_id uuid, user_balance_account int, remaining int  )
CALLED ON NULL INPUT
RETURNS tuple<int,int>
LANGUAGE java AS $$
	if (credit_id != null) {
		if (user_balance_account != null) state.setInt(0,state.getInt(0)+user_balance_account);
		if (remaining != null && user_balance_account == 0) state.setInt(1,state.getInt(1)+remaining);
	}
	return state; 
$$;

CREATE OR REPLACE AGGREGATE groupBySum(uuid, int, int) 
SFUNC stateGroupSum
STYPE tuple<int,int>
INITCOND (0,0);

//CREATE INDEX ON bankOperation (bank_id);

SELECT groupBySum(credit_id, user_balance_account, remaining)  from bankOperation where bank_id =73d2f0da-89d2-4fe8-8683-7f108626eb51;


// sum credit count on banks for user
CREATE OR REPLACE FUNCTION stateGroup( state map<uuid,int>, bank_id uuid, credit_id uuid, user_balance_account int,  remaining int)
CALLED ON NULL INPUT
RETURNS map<uuid,int>
LANGUAGE java AS '
	Integer count = (Integer) state.get(bank_id);
	if (credit_id != null){
		if ( remaining > 0 && user_balance_account == 0){
			if (count == null) count = 1; 
			else count++;
			if (credit_id != null ) state.put(bank_id, count); 
		}
	}
	return state; 
' ;

CREATE OR REPLACE AGGREGATE groupBy(uuid, uuid, int, int) 
SFUNC stateGroup
STYPE map<uuid,int>
FINALFUNC groupFinal
INITCOND {};

CREATE OR REPLACE FUNCTION groupFinal (state map<uuid,int>)
    CALLED ON NULL INPUT
    RETURNS int
    LANGUAGE java
    AS $$
	java.util.Map<java.util.UUID, Integer> hashMap = (java.util.Map) state;
	int count = 0;
	for(java.util.Map.Entry<java.util.UUID, Integer> entry : hashMap.entrySet()) {
    	int value = entry.getValue();
		count++;
	}
	return count;
$$;


CREATE INDEX ON bankOperation (user_id);
CREATE INDEX ON bankOperation (remaining);
CREATE INDEX ON bankOperation (user_balance_account);
CREATE INDEX ON bankOperation (bank_id);
CREATE INDEX ON bankOperation (credit_id);
CREATE INDEX ON bankOperation (operation_date);



//CREATE INDEX ON credit (debt);


Select * from bankOperation;
Select * from user;
SELECT groupBy(bank_id , credit_id, user_balance_account, remaining)  from  bankOperation where user_id =7895f583-b1ca-4363-9c10-f8da5a76bb12;

