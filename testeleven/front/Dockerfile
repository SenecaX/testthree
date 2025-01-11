FROM node:16-alpine AS build
WORKDIR /app
COPY package*.json yarn.lock ./
RUN yarn install
COPY . .
RUN yarn build

FROM node:16-alpine
WORKDIR /app
COPY --from=build /app/dist ./dist
RUN yarn global add serve
CMD ["serve", "-s", "dist", "-l", "5000"]
EXPOSE 5000

