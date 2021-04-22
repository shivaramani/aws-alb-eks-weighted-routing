# docker login
# docker build -t example/reactuiapp .
# docker tag example/reactuiapp:latest shivaramani/reactuiapp
# docker push shivaramani/reactuiapp:latest

# pull official base image
FROM node:13.12.0-alpine

# set working directory
WORKDIR /app

# add `/app/node_modules/.bin` to $PATH
ENV PATH /app/node_modules/.bin:$PATH

# install app dependencies
COPY package.json ./
COPY package-lock.json ./
RUN npm install --silent
RUN npm install react-scripts@3.4.1 -g --silent

# add app
COPY . ./

RUN pwd

RUN ls ./


RUN mkdir -p /web
RUN cp -R build/* /web

FROM python:3.7.4
WORKDIR /root
RUN ls
COPY --from=0 /web .
RUN ls
CMD python3 -m http.server 8080