FROM maven:3.8.4-openjdk-11-slim as builder
WORKDIR /opt/online-shop/
COPY . .

