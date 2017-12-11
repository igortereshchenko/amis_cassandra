drop type if exists username;
drop table if exists user;
drop table if exists bank;
drop table if exists bankOperation;
drop table if exists wish_list;
drop type if exists wish_credit;
drop table if exists credit;
drop function if exists countBankFinal;
drop function if exists countBankState;
drop function if exists countBank;

CREATE TYPE IF NOT EXISTS user_name(
	firstname text,
	middlename text,
	lastname text
);

CREATE TYPE IF NOT EXISTS wish_credit(
	bank_id int,
	credit_id int
);

create table if not exists user(
	user_id int,
	fio FROZEN<user_name>,
	balance float,
	PRIMARY KEY(user_id)
);

create table if not exists  bank(
	bank_id int,
	bank_name text,
	users set<int>,
	PRIMARY KEY(bank_id)
);

create table if not exists credit(
	credit_id int, 
	bank_id int,
	user_id int,
	percent float,
	term int,
	PRIMARY KEY(credit_id)
);

create table if not exists  bankOperation(
	bank_operation_id int,
	user_id int,
	credit_id int,
	operation_date timestamp,
	debt float,
	PRIMARY KEY(bank_operation_id)
);

create table if not exists wish_list(
	user_wish_id int,
	user_id int,
	wish_list MAP<text, FROZEN<wish_credit>>, //<date,wish>
	PRIMARY KEY (user_wish_id)
);

insert into user JSON '{
	"user_id":1,
	"fio": {"firstname":"Vasyl","middlename":"Mykolayovych","lastname":"Borovetc"},
	"balance":2000
}';

insert into bank JSON '{
	"bank_id":1,
	"bank_name":"Alpha"
}';


BEGIN BATCH
	UPDATE bank
	SET users = {1}
	WHERE bank_id = 1;
	
	insert into credit JSON '{
		"credit_id":1,
		"bank_id":1,
		"user_id":1,
		"percent": 1,
		"term": 3
	}';
	
	insert into credit JSON '{
		"credit_id":2,
		"user_id":1,
		"bank_id":1,
		"percent": 0.5,
		"term": 2
	}';
	
	insert into bankOperation JSON '{
		"bank_operation_id":1,
		"user_id": 1,
		"credit_id":1,
		"debt":20000,
		"operation_date": "2017-12-01"
	}';
	
	insert into wish_list JSON '{
		"user_wish_id":1,
		"user_id":1,
		"wish_list":{
			"2017-12-02":{
				"bank_id":1,
				"credit_id":2
			}
		}
	}';
	
APPLY BATCH;
 
BEGIN BATCH
insert into bankOperation JSON '{
		"bank_operation_id":2,
		"user_id": 1,
		"credit_id":1,
		"debt":18000,
		"operation_date": "2017-12-02"
	}';

UPDATE user
	SET balance = 18000
	WHERE user_id = 1;
	
APPLY BATCH;

BEGIN BATCH
insert into bankOperation JSON '{
		"bank_operation_id":3,
		"user_id": 1,
		"credit_id":1,
		"debt":16500,
		"operation_date": "2017-12-03"
	}';

UPDATE user
	SET balance = 16500
	WHERE user_id = 1;
	
APPLY BATCH;

CREATE OR REPLACE FUNCTION countBankState(state map<int, frozen<set<int>>>, bank_id int, user_id int)
    CALLED ON NULL INPUT
    RETURNS tuple<int, frozen<set<int>>>
    LANGUAGE java
    AS $$
		Set<Integer> banks = new HashSet<>();
		if (state.containsKey(user_id)) {
			state.put(user_id, banks.add(bank_id));
		}
        return state;
    $$;

CREATE OR REPLACE FUNCTION countBankFinal (state map<int,frozen<set<int>>>)
    CALLED ON NULL INPUT
    RETURNS tuple<int, int>
    LANGUAGE java
    AS $$
		Map<Integer, Integer> banks = new Map<Integer, Integer>();
		for (int i=0; i < state.size(); i++){
			state.put(user_id, i);
		}
        return state;
    $$;

CREATE OR REPLACE AGGREGATE countBank(int, int)
    SFUNC countBankState
    STYPE tuple<int, frozen<set<int>>>
    FINALFUNC countBankFinal
    INITCOND (0, 0);

//Select * from bankOperation;
SELECT countBank(bank_id, user_id) from credit;
