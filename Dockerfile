# FROM node:18
FROM node:20-alpine

WORKDIR /app
# Create a directory /app (if it does not exist) and make it the current working directory
# Think of it like running: cd /app

COPY nodeServer/package*.json ./nodeServer/
# copy files from local machine → into the container filesystem
WORKDIR /app/nodeServer

RUN npm install 
# Run All dependences 

WORKDIR /app
# now come again to root directory to copy rest code 
COPY . .
# Copy the rest of the application source code to the container
EXPOSE 3000

CMD ["node","nodeServer/index.js"]
