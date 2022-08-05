FROM node:16

ENV NPM_CONFIG_LOGLEVEL info

WORKDIR /site/teplosocial/teplosocial-frontend/
COPY package*.json .
RUN npm install
COPY . .

ENV PATH /site/teplosocial/teplosocial-frontend/node_modules/.bin:$PATH

CMD ["npm", "run", "dev"]
