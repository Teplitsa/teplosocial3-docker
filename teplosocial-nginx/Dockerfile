FROM debian:buster

RUN apt-get update
RUN apt-get install -y nginx
RUN apt-get install -y nano
RUN apt-get install -y vim

COPY custom.conf /etc/nginx/conf.d/

CMD ["nginx", "-g", "daemon off;"]
