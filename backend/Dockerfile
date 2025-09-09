# ---------- Build stage ----------
FROM maven:3.9-eclipse-temurin-21 AS build
WORKDIR /workspace

# Copia prima i descriptor per sfruttare la cache
COPY pom.xml .
# (opzionale) scarica dipendenze per cache più stabile
RUN --mount=type=cache,target=/root/.m2 mvn -q -e -DskipTests dependency:go-offline

# Copia il codice e compila
COPY src ./src
RUN --mount=type=cache,target=/root/.m2 mvn -q -e -DskipTests package

# ---------- Runtime stage ----------
FROM eclipse-temurin:21-jre AS runtime
WORKDIR /app

# Crea un utente non-root
RUN useradd -r -s /sbin/nologin spring
USER spring

# Copia il JAR dal build stage
COPY --from=build /workspace/target/*.jar /app/app.jar

# Porta di default di Spring Boot
EXPOSE 8080

# Variabili utili (override con -e se vuoi)
ENV JAVA_OPTS="-XX:+ExitOnOutOfMemoryError" \
    SERVER_PORT="8080" \
    SPRING_PROFILES_ACTIVE="default"

# Avvio
ENTRYPOINT ["sh","-lc","exec java $JAVA_OPTS -Dserver.port=$SERVER_PORT -jar /app/app.jar"]
