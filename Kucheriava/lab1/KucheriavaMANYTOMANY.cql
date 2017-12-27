CREATE KEYSPACE IF NOT EXISTS KucheriavaMANYTOMANY
WITH replication = {
	'class' : 'SimpleStrategy',
	'replication_factor' : 1
}
AND durable_writes = FALSE;

USE KucheriavaMANYTOMANY;

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

CREATE TABLE IF NOT EXISTS "Users" (
	user_id text,
	user_name frozen<full_name_type>,
	user_birthdate date,
	user_address text,
	user_workplace list<text>,
	user_contact tuple<set<text>, set<text>, map<text, text>>,
	user_documents set<text>,
	PRIMARY KEY ( user_id )
);

CREATE TABLE IF NOT EXISTS "Documents" (
	document_id text,
	document_type text,
	document_date date,
	document_provider text,
	document_signature set<frozen<signaturer>>,
	document_owner set<text>,
	PRIMARY KEY ( document_id )
);

USE KucheriavaMANYTOMANY;

INSERT INTO "Users" JSON '{
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
				{ "instagram":"@i_i", "vk":"id67890555"} ]
}';

INSERT INTO "Users" JSON '{
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
				{ "vk":"aaa"} ]
}';

BEGIN BATCH
INSERT INTO "Documents" JSON '{
 "document_id":"00",
 "document_type":"agreement",
 "document_date":"2017-08-05",
 "document_provider":"Aval Bank", 
 "document_signature":[
		{"position":"manager", 
		 "name":{
					"first_name":"A",
					"middle_name":"X",
					"last_name":"V"},
		"isSigned":"true"},
        {"position":"client",
         "name":{
				"first_name":"Ivan",
				"middle_name":"Ivanovitch",
				"last_name":"Ivanov"},
		"isSigned":"false"}
     ],
 "document_owner":["0"]
}';

UPDATE "Users" SET user_documents=user_documents+{'00'} WHERE user_id='0';
APPLY BATCH;


USE KucheriavaMANYTOMANY;
BEGIN BATCH
INSERT INTO "Documents" JSON '{
 "document_id":"22",
 "document_type":"diploma",
 "document_date":"2017-06-15",
 "document_provider":"KPI", 
 "document_signature":[
		{"position":"rector", 
		 "name":{
					"first_name":"M",
					"middle_name":"M",
					"last_name":"Zgurovskii"},
		"isSigned":"true"}
     ],
 "document_owner":["1"]
}';
UPDATE "Users" SET user_documents=user_documents+{'22'} WHERE user_id='1';
APPLY BATCH;

USE KucheriavaMANYTOMANY;
BEGIN BATCH
INSERT INTO "Documents" JSON '{
 "document_id":"33",
 "document_type":"merriage certificate",
 "document_date":"2018-01-30",
 "document_provider":"Registry office", 
 "document_signature":[
		{"position":"husband", 
		 "name":{
					"first_name":"Ivanov",
					"last_name":"Ivan"},
		"isSigned":"true"},
		{"position":"wife", 
		 "name":{
					"first_name":"Kucheriava",
					"last_name":"Nadiia"},
		"isSigned":"true"}
     ],
  "document_owner":["0","1"]
}';
UPDATE "Users" SET user_documents=user_documents+{'33'} WHERE user_id='0';
UPDATE "Users" SET user_documents=user_documents+{'33'} WHERE user_id='1';
APPLY BATCH;


USE KucheriavaMANYTOMANY;

UPDATE "User_documents" SET user_address = 'Lviv', user_workplace = user_workplace + [ 'SoftServe' ]
WHERE user_id = '0';

DELETE user_workplace [ 1 ] FROM "User_documents"
WHERE user_id = '0';


USE KucheriavaMANYTOMANY;
DROP KEYSPACE KucheriavaMANYTOMANY;

USE KucheriavaMANYTOMANY;
SELECT JSON * FROM "Users";
USE KucheriavaMANYTOMANY;
SELECT JSON * FROM "Documents";

USE KucheriavaMANYTOMANY;
SELECT * FROM "Users";

USE KucheriavaMANYTOMANY;
SELECT * FROM "Documents";
 