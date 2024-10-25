# first stage builds vue 
FROM node:22.7.0-alpine3.19 as build-stage

WORKDIR /app
COPY . .
RUN npm ci
RUN npm run build 


FROM caddy:2.6.4-alpine
COPY --from=build-stage /app/dist /var/www/frontend
COPY Caddyfile /etc/caddy/Caddyfile
    
