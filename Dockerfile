FROM node:lts-alpine as builder
WORKDIR /usr/src/app
COPY package.json package-lock.json /usr/src/app/
RUN npm set progress=false && npm i
COPY . /usr/src/app/
RUN npx ng build --prod
FROM nginx:stable-alpine
RUN rm -rf /etc/nginx/sites-enabled/default
COPY --from=builder /usr/src/app/nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=builder /usr/src/app/gzip.conf /etc/nginx/conf.d/gzip.conf
EXPOSE 80
RUN rm -rf /usr/share/nginx/html/*
COPY --from=builder /usr/src/app/dist /usr/share/nginx/html/