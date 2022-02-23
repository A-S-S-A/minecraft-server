# Use LTS version of JRE
FROM openjdk:17-slim

ARG MINECRAFT_VERSION=""

# Install dependencies
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y curl jq

# Create a folder for the server executable
WORKDIR /minecraft
COPY scripts/* /minecraft

# Download PaperMC binary
RUN /bin/sh get-paper.sh ${MINECRAFT_VERSION}

# Ports required by the Minecraft server
EXPOSE 25565/tcp
EXPOSE 19132/udp

# Declare volume and cd into it
VOLUME /data
WORKDIR /data

# Run the server
ENTRYPOINT ["java", "-jar", "/minecraft/paper.jar"]

