FROM node:16

ENV NPM_CONFIG_LOGLEVEL info

WORKDIR /site/microservices/notifications/

COPY docker/teplosocial-microservice-notifications/notifications-entrypoint.sh ../shell/notifications-entrypoint.sh

RUN chmod +x ../shell/notifications-entrypoint.sh

ENTRYPOINT ["../shell/notifications-entrypoint.sh"]

CMD ["npm", "run", "dev"]
