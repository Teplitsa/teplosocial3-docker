FROM node:16

ENV NPM_CONFIG_LOGLEVEL info

WORKDIR /site/nextjs/

COPY docker/teplosocial-frontend/frontend-entrypoint.sh ../shell/frontend-entrypoint.sh

RUN chmod +x ../shell/frontend-entrypoint.sh

ENTRYPOINT ["../shell/frontend-entrypoint.sh"]

CMD ["npm", "run", "dev"]
