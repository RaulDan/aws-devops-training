CREATE TABLE "product" (
    "id" varchar(64) PRIMARY KEY,
    "name" varchar(128)
);

CREATE TABLE "order" (
    "id" varchar(64) PRIMARY KEY,
    "date_time" timestamp,
    "customer" varchar(128)
);

CREATE TABLE "order_item" (
    "product_id" varchar(64) REFERENCES "product"("id"),
    "order_id" varchar(64) REFERENCES "order"("id"),
    "quantity" int,
     PRIMARY KEY("product_id", "order_id")
);