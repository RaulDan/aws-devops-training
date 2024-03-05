## DevOps Demo App (Online Shop)
### Running it locally

You need a locally running Postgres 11 (or newer) database. This can be set up using docker via

```bash
docker run --name online-shop-db -e POSTGRES_PASSWORD=postgres -p 5432:5432 -d postgres:11
```

You also need to have Java 11 (or newer) installed locally. 
 - Download one of the JARs in the [project releases](releases/).
 - Set the following environment variables:

```
SPRING_DATASOURCE_URL=jdbc:postgresql://localhost:5432/postgres
SPRING_DATASOURCE_USERNAME=postgres
SPRING_DATASOURCE_PASSWORD=postgres
```

 - And then start the app by running:

```bash
java -jar ./online-shop-v0.0.1.jar
```

