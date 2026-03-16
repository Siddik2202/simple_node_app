## This is simple node js app, 

There Have a form and backend connection with mysql. 

when You submit the form then the data will store in mysql db.

### Here are the step to run on docker with EC2 instance server

1) Host a instance then clone you repository from your github using 

```bash
sudo git clone https://github.com/Siddik2202/simple_node_app.git
```

2) Create Dockerfile for your project. You get this from root folder. And run 
```bash
docker build -t simple-node-app .
```

3) After we need to run this image but make sure you connect with db there have many method to do that
   
   3.1) Create a network 1st to connect with db
```bash
docker network create simple-app-network
```
   3.2) Using init.sql (Your Current Method) If you have 
```bash
   docker run -d --name db --network simple-app-network -e MYSQL_ROOT_PASSWORD=root -v $(pwd)/init.sql:/docker-entrypoint-initdb.d/init.sql -p 3306:3306 mysql:8
```
   3.3) Create Database Manually Inside Container. First start MySQL container:
```bash
docker run -d --name db -e MYSQL_ROOT_PASSWORD=root -p 3306:3306 mysql:8
```
   Then enter under container ```bash  docker exec -it db mysql -u root -p  ```
   And then you need to manually run SQL
```bash
CREATE DATABASE sampledb;

USE sampledb;

CREATE TABLE nodeuser (
id INT AUTO_INCREMENT PRIMARY KEY,
name VARCHAR(100),
mobile VARCHAR(15),
email VARCHAR(100)
);
```

   3.4) Execute SQL File After Container Starts: Instead of mounting init.sql, you can run it later.
```bash
docker exec -i db mysql -u root -p sampledb < init.sql
```

   3.5 Application Creates Tables (Auto Migration) Your Node.js backend can create tables automatically.
   When Node app starts -> Check if table exists -> Create if not
   
   3.6 Using Docker Compose (Most Used in DevOps. We also do this one the next step.

Now I use method 1, After that your MySQL container start Attach to simple-app-network and automatically Run init.sql also Create database + table

4. Then run your node container with network:
   you cannot create another container with the same name, even if the existing container is Exited. If then remove ```bash
   docker rm container-name
```
```bash
docker run -d --name simple-node --network simple-app-network -p 3000:3000 simple-node-app
```
    
5. So here we have three images where
      node -> we don't run this image directly. It is only used to build your app image. (runtime environment)
      simple-node-app -> Our Backend Application
      mysql:8 -> This image runs the MySQL database server. Your Node backend connects to it using: db (database server)
      Make sure you enable your port 22, 443, 80 and 3000

6. To check data:
```bash
docker exec -it db mysql -u root -p
# eneter passoword root and then 
SHOW DATABASES;
USE sampledb;
SHOW TABLES;
SELECT * FROM nodeuser;
DESCRIBE nodeuser;
```

7. Now we will add volumn for data persistance. Create volumen then remove db and attach or run with volumn and you also need to restart your application container
```bash
docker volume create mysql-data
docker rm -f db
docker run -d --name db --network simple-app-network -e MYSQL_ROOT_PASSWORD=root -v mysql-data:/var/lib/mysql -v $(pwd)/init.sql:/docker-entrypoint-initdb.d/init.sql mysql:8

# Now you get error because when you connect with new database you application attach with old
docker restart simple-node
# Now works fine
```










iii) update your nodeServer/index.js to Docker, MySQL runs in another container, accessible via a container name like db. especially important when running in Docker

iv) It's better to use docker-compose other you need to run seperately db and app after create docker images. 

v) Then create docker-compose.yml file, here we pass environment two times because db environment work for itself. and app environment works for pass the value with app.

vi) Run this command docker-compose up -d --build It will build and run container. All the method and steps (network, volume, db & app) are written here.

vii) Here we use healthcheck for avoing error Econnrefused Error, means app run befor db or mysql ready.

viii) docker exec -it < container id > mysql -u your_set_password -p and give password . show databases; SELECT * FROM your_table; You can see your data.

ix) For that you should enable 3000 (from app) and 8080 (alternative port of http 80 for docker container) port .

 
### For CICD Approach

1. 1st of all set up agent node from master beacuse jenkins work as a master-slave architechture.

2. Then I have a besic_jenkins or jenkins (both are correct) file set this in grovvy syntax enable github pooling and you can also attach github webhooks.

3. And This will work smoothly also enable port.

   THSNK YOU SO MUCH !
