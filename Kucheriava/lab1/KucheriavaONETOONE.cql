CREATE KEYSPACE IF NOT EXISTS KucheriavaONETOONE
WITH replication = {
	'class' : 'SimpleStrategy',
	'replication_factor' : 1
}
AND durable_writes = FALSE;

USE KucheriavaONETOONE;

CREATE TYPE IF NOT EXISTS full_name_type (
	first_name text,
	middle_name text,
	last_name text
);

CREATE TYPE IF NOT EXISTS signaturer (
	position text,
	name frozen<full_name_type>,
	isSigned boolean
);

CREATE TABLE IF NOT EXISTS "User_documents" (
	user_id text,
	user_name frozen<full_name_type>,
	user_birthdate date,
	user_address text,
	user_workplace list<text>,
	user_contact tuple<set<text>, set<text>, map<text, text>>,
	document_id text,
	document_type text,
	document_date date,
	document_provider text,
	document_signature set<frozen<signaturer>>,
	PRIMARY KEY ( user_id )
);

USE KucheriavaONETOONE;

INSERT INTO "User_documents" JSON '{
 "user_id":"0",
 "user_name":{
	"first_name":"Ivan",
	"middle_name":"Ivanovitch",
	"last_name":"Ivanov"
 },
 "user_address":"Kyiv",
 "user_birthdate":"1990-04-09", 
 "user_workplace":["Luxoft","Epam"],
 "user_contact":[ ["John@gmail.com", "Ivan@ukr.net"],
				["+380976534800", "+380631234890"], 
				{ "instagram":"@i_i", "vk":"id67890555"} ],
 "document_id":"001",
 "document_type":"passport",
 "document_date":"2017-08-05",
 "document_provider":"Ukraine", 
 "document_signature":[
		{"position":"manager", 
		 "name":{
					"first_name":"A",
					"middle_name":"X",
					"last_name":"V"},
		"isSigned":"true"},
        {"position":"national",
         "name":{
				"first_name":"Ivan",
				"middle_name":"Ivanovitch",
				"last_name":"Ivanov"},
		"isSigned":"false"}
     ]
}';

USE KucheriavaONETOONE;
INSERT INTO "User_documents" JSON '{
 "user_id":"0",
 "user_name":{
	"first_name":"Ivan",
	"middle_name":"Ivanovitch",
	"last_name":"Ivanov"
 },
 "user_address":"Kyiv",
 "user_birthdate":"1990-04-09", 
 "user_workplace":["Luxoft","Epam"],
 "user_contact":[ ["John@gmail.com", "Ivan@ukr.net"],
				["+380976534800", "+380631234890"], 
				{ "instagram":"@i_i", "vk":"id67890555"} ],
 "document_id":"002",
 "document_type":"passport_new",
 "document_date":"2018-06-15",
 "document_provider":"Ukraine", 
 "document_signature":[
		{"position":"national", 
		 "name":{
				"first_name":"Ivan",
				"middle_name":"Ivanovitch",
				"last_name":"Ivanov"},
		"isSigned":"true"}
     ]
}';

USE KucheriavaONETOONE;
INSERT INTO "User_documents" JSON '{
 "user_id":"1",
 "user_name":{
	"first_name":"Nadiia",
	"last_name":"Kucheriava"
 },
 "user_address":"Kyiv",
 "user_birthdate":"1995-06-02", 
 "user_workplace":["Epam"],
 "user_contact":[ ["nnn@gmail.com", "NK@epam.com"],
				["+380634577800"], 
				{ "vk":"aaa"} ],
 "document_id":"111",
 "document_type":"passport",
 "document_date":"2017-07-03",
 "document_provider":"GB", 
 "document_signature":[
		{"position":"national", 
		 "name":{
					"first_name":"Nadiia",
					"last_name":"Kucheriava"},
		"isSigned":"true"}
     ]
}';


USE KucheriavaONETOONE;

UPDATE "User_documents" SET user_address = 'Lviv', user_workplace = user_workplace + [ 'SoftServe' ]
WHERE user_id = '0';

DELETE user_workplace [ 1 ] FROM "User_documents"
WHERE user_id = '0';

USE KucheriavaONETOONE;

BEGIN BATCH
	UPDATE "User_documents" SET document_signature = { {
		position : 'client',
		name : {
			first_name : 'Petro',
			middle_name : 'Petrovich',
			last_name : 'Petrov'
		},
		isSigned : false
	} }
	WHERE user_id = '0';

	UPDATE "User_documents" SET user_name = {
		first_name : 'Petro',
		middle_name : 'Petrovich',
		last_name : 'Petrov'
	}
	WHERE user_id = '0';
APPLY BATCH;


USE KucheriavaONETOONE;
DROP KEYSPACE KucheriavaONETOONE;

USE KucheriavaONETOONE;
SELECT JSON * FROM "User_documents";

USE KucheriavaONETOONE;
SELECT * FROM "User_documents";
 