FROM mhart/alpine-node:8

RUN apk add --no-cache bash
RUN mkdir -p /home/service

WORKDIR /home/service
COPY package.json /home/service
COPY . /home/service

RUN yarn install

EXPOSE 4040

CMD [ "yarn", "start" ]