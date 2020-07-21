FROM node:lts-slim

# set working directory
WORKDIR /app

# add node modules to path
ENV PATH /app/node_modules/.bin:$PATH

# install app dependencies
COPY package.json ./
COPY package-lock.json ./
RUN npm install
RUN npm install react-scripts@3.4.1 -g

# add app
COPY . ./

# react client port
EXPOSE 3000

CMD [ "npm", "start" ]