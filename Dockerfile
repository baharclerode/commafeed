FROM maven:3.5.2-jdk-8 AS builder

WORKDIR /build

COPY bower.json gulp gulpfile.js package.json pom.xml mvnw /build/
COPY dev /build/dev/
COPY src /build/src/
COPY maven /build/maven/

RUN echo '{ "allow_root": true }' > /root/.bowerrc
RUN mvnw clean install

FROM openjdk:8-jre-alpine

EXPOSE 8082
EXPOSE 8084
WORKDIR /server/
ENTRYPOINT ["/usr/bin/java", "-jar", "/server/server.jar"]
CMD ["server", "/server/config.yml.example"]
COPY --from=builder /build/target/commafeed.jar /server/server.jar
COPY config.yml.example /server/config.yml.example
