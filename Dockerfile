FROM node:16-alpine  as frontend
WORKDIR /frontend
COPY ui .
RUN npm ci --quiet
RUN npm run build

FROM maven:3.8.4-openjdk-11-slim as backend
WORKDIR /backend
COPY src ./src
COPY pom.xml .
COPY --from=frontend /frontend/build src/main/resources/static
RUN mvn install

FROM amazoncorretto:17-alpine
WORKDIR /opt/online-shop
COPY --from=backend /backend/target/online-shop-0.0.1-SNAPSHOT.jar ./online-shop.jar
ADD https://github.com/ufoscout/docker-compose-wait/releases/download/2.12.1/wait .
RUN chmod +x ./wait
CMD ./wait && java -jar online-shop.jar
EXPOSE 8080
