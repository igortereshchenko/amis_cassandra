create keyspace if not exists rudnyk
with replication = {
	'class': 'SimpleStrategy',
	'replication_factor': 1
};


create type if not exists user_name(
	firstname text,
	middlename text,
	surname text
);


drop type if exists user_name;
drop table if exists user_documents;
drop table if exists document_users;


create table if not exists user_documents (
	user_email text,
	user_full_name FROZEN<user_name>,
	user_birthdate date,
	user_address text,
	
	documents set<text>,
	
	primary key(user_email)
);

create table if not exists document_users (
	document_title text,
	document_description text,
	document_date date,
	document_chapters List<text>,
	
	users set<text>, 
	
	primary key(document_title)
);



BEGIN BATCH

insert into user_documents json '{
	"user_email": "first@gmail.com",
	"user_birthdate": "2010-11-11" ,
	"user_address": "first user address",
	"user_full_name": {"firstname": "first", "middlename": "middle", "surname": "sur"},	

	"documents": ["doc1"]
}';

insert into user_documents json '{
	"user_email": "second@gmail.com",
	"user_birthdate": "2017-01-01" ,
	"user_address": "second address",
	"user_full_name": {"firstname": "name 1", "middlename": "name 2", "surname": "name 3"},	

	"documents": ["doc1", "doc2"]
}';

insert into document_users json '{
	"document_title": "doc1",
	"document_description": "doc description",
	"document_date": "2011-11-11",
	"document_chapters": ["a", "b", "c"],
	
	"users": ["first@gmail.com", "second@gmail.com"]
}';

insert into document_users json '{
	"document_title": "doc2",
	"document_description": "doc description",
	"document_date": "2015-11-11",
	
	"users": ["second@gmail.com"]
}';

APPLY BATCH;


select json * from user_documents;

select json * from document_users;
