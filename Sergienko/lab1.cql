Task:
    1. Create keyspace sergienko with replication_factor equal to 2.
    2. Change replication factor to 3.
    3. Create ERD according to task "User visits cinemas". Each entity should have three attributes, except primary key.
    4. Create tables, according to ERD without STATIC.
    5. Drop tables.
    6. Create tables, according to ERD with STATIC.
    7. Drop tables and keyspace.


Code:
    CREATE keyspace IF NOT EXISTS sergienko
    WITH replication = {
        'class': 'SimpleStrategy',
        'replication_factor': 2
    };

    ALTER keyspace sergienko
    WITH replication = {
        'class': 'SimpleStrategy',
        'replication_factor': 3
    };

    CREATE table IF NOT EXISTS sergienko.user_visits_cinemas(
        user_id         int,
        user_name       text,
        date_of_birth   date,
        user_address    text,
        licence_number  int,
        cinema_name     text,
        cinema_address  text,
        description     text,
        PRIMARY KEY (user_id, licence_number)
    );

    INSERT INTO sergienko.user_visits_cinemas(
            user_id,         
            user_name,       
            date_of_birth,   
            user_address,    
            licence_number,  
            cinema_name,     
            cinema_address,  
            description
        ) 
        values(
            1,
            'user1',
            '1990-04-20',
            'Kiev, Kovalskiy 5',
            1,
            'cinema1',
            'Kiev, Kovalskiy 5',
            'world'
        );

    INSERT INTO sergienko.user_visits_cinemas(
            user_id,         
            user_name,       
            date_of_birth,   
            user_address,    
            licence_number,  
            cinema_name,     
            cinema_address,  
            description
        ) 
        values(
            1,
            'other_user1',
            '1990-04-20',
            'Kiev, Kovalskiy 5',
            2,
            'cinema2',
            'Kiev, Kovalskiy 5',
            'world'
        );


    DROP TABLE sergienko.user_visits_cinemas;

    CREATE table IF NOT EXISTS sergienko.user_visits_cinemas(
        user_id         int,
        user_name       text    STATIC,
        date_of_birth   date    STATIC,
        user_address    text    STATIC,
        licence_number  int,
        cinema_name     text,
        cinema_address  text,
        description     text,
        PRIMARY KEY (user_id, licence_number)
    );

    DROP TABLE sergienko.user_visits_cinemas;
    DROP KEYSPACE sergienko;
