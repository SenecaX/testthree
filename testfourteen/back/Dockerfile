FROM node:16-alpine AS build
WORKDIR /app
COPY package*.json yarn.lock ./
RUN yarn install
COPY . .
RUN yarn build

FROM node:16-alpine
WORKDIR /app
COPY --from=build /app/dist ./dist
COPY package*.json yarn.lock ./
RUN yarn install --production
CMD ["node", "dist/app.js"]
EXPOSE 3000

