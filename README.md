# mysql_connector
Dart MySQL Connector


This example uses docker to create a container running the mysql server with ADminer as a administration tool.

The password for root user is my_password

Before you run the program, run the docker file 
    
    docker-compose -f stack.yml up
    
This will set up the mysql server 
You will need to open ADminer

http://localhost:8080

create a database called 'example'

Then run the dart code, this will connect to the database, drop tables, create tables, add data, read data.
These are all good examples of how you can use Dart to interact with mySQL.

