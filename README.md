# Property Graph feature of Oracle Database

The Docker-based setup instruction for the Property Graph feature of Oracle Database.

**The scripts here are my own. Not Oracle's official material.**

Architecture:

![](https://user-images.githubusercontent.com/4862919/80330080-632e9a00-886e-11ea-822e-0a96e40dbbf9.jpg)

After setting up this demo environment, please try:

- [customer_360](https://github.com/ryotayamanaka/customer_360) - Customer 360 analysis in banking [3-tier deployment]
- [online_retail](https://github.com/ryotayamanaka/online_retail) - Recommendation system in online retail [3-tier deployment]
- [moneyflows](https://github.com/ryotayamanaka/moneyflows) - Find patterns from large money transfer networks [3-tier deployment]
- [mule_account](./graphs/mule_account/README.md) - Fake account detection in fraud analysis [3-tier deployment]
- [shortest-path](https://github.com/ryotayamanaka/shortest-path) - Simple example of shortest path queries [PGX standalone]
- [call-tree](https://github.com/ryotayamanaka/call-tree) - Call tree analysis example using reachability queries [PGX standalone]

## Build Docker Image for Oracle Database

Clone `docker-images` repository.

    $ cd <your-work-directory>
    $ git clone https://github.com/oracle/docker-images.git

Download Oracle Database.

* [Oracle Database 19.3.0 for Linux x86-64 (ZIP)](https://www.oracle.com/database/technologies/oracle-database-software-downloads.html)

Put `LINUX.X64_193000_db_home.zip` under:
* `docker-images/OracleDatabase/SingleInstance/dockerfiles/19.3.0/`

Build the image.

    $ cd docker-images/OracleDatabase/SingleInstance/dockerfiles/
    $ bash buildDockerImage.sh -v 19.3.0 -e

## Clone this Repository

    $ cd <your-work-directory>
    $ git clone https://github.com/ryotayamanaka/oracle-pg.git -b 21.1

## Download and Extract Packages for Graph Server and Client

Go to the following pages and download the packages.

* [Oracle Graph Server and Client 21.1](https://www.oracle.com/database/technologies/spatialandgraph/property-graph-features/graph-server-and-client/graph-server-and-client-downloads.html)
* [Oracle JDK 11](https://www.oracle.com/java/technologies/javase-jdk11-downloads.html) (No cost for personal use and development use)

Put the following files to `oracle-pg/packages/`
 
- oracle-graph-21.1.0.x86_64.rpm
- oracle-graph-client-21.1.0.zip
- oracle-graph-plsql-21.1.0.zip
- jdk-11.0.10_linux-x64_bin.rpm

Run the following script to extract packages:

    $ cd oracle-pg/
    $ sh extract.sh

## Start a Container (Database)

Start the containers for **Oracle Database** only first.

    $ cd oracle-pg/
    $ docker-compose up database
    ...
    database_1      | Completing Database Creation
    ...
    database_1      | #########################
    database_1      | DATABASE IS READY TO USE!
    database_1      | #########################

**This job takes time.**

## Configure Database

Connect to the Oracle Database server. See [Appendix 1](#appendix-1) if you get an error.

    $ cd oracle-pg/
    $ docker-compose exec database sqlplus sys/WELcome123##@orclpdb1 as sysdba

Configure Property Graph features. This script was extracted from oracle-graph-plsql-xx.x.x.zip.

    SQL> @/home/oracle/scripts/oracle-graph-plsql/19c_and_above/opgremov.sql
    SQL> @/home/oracle/scripts/oracle-graph-plsql/19c_and_above/catopg.sql

Create user roles (graph_developer, graph_administrator, and PGX roles) and sample users (graph_dev, graph_admin).

    SQL> @/home/oracle/scripts/create_roles.sql
    SQL> @/home/oracle/scripts/create_users.sql
    SQL> EXIT

## Start Containers (Graph Server and Jupyter)

Build and pull images, create containers, and start them.

    $ cd oracle-pg/
    $ docker-compose up

**This job takes time.** `Cnt+C` to stop all containers.

Access Graph Visualization and Zeppelin to start graph analytics. Please use **FireFox**.

* Graph Visualization - https://localhost:7007/ui/ (User: graph_dev, Password: WELcome123##)
* Jupyter - http://localhost:8888/

To stop, restart, or remove the containers, see [Appendix 2](#appendix-2).

## Appendix 1

You need to start the container if it is stopped.

    $ cd oracle-pg/
    $ docker-compose start database

You will get this error when you try to connect before the database is created.

    $ docker-compose exec database sqlplus sys/Welcome1@localhost:1521/orclpdb1 as sysdba
    ...
    ORA-12514: TNS:listener does not currently know of service requested in connect

To check the progress, see logs.

    $ cd oracle-pg/
    $ docker-compose logs -f database

`Cnt+C` to quit.

## Appendix 2

To start, stop, or restart the containers.

    $ cd oracle-pg/
    $ docker-compose start|stop|restart

To remove the docker containers.

    $ cd oracle-pg/
    $ docker-compose down
