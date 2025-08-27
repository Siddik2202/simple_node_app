## This is simple node js app, 

There Have a form and backend connection with mysql. 

when You submit the form then the data will store in mysql db.

### Here are the step to run on docker with EC2 instance server

i) Host a instance then clone you repository from your github using sudo git clone < your project url >

ii) Create Dockerfile for your project 

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
