# Use LTS version of JRE
FROM openjdk:17-slim

# Data volume
VOLUME /minecraft

# Install dependencies
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y curl

# Download PaperMC binary
RUN curl -L -o paper.jar https://papermc.io/api/v2/projects/paper/versions/1.18.1/builds/207/downloads/paper-1.18.1-207.jar

# Ports required by the Minecraft server
# - 25565 for Minecraft Java Edition server
# - 25575 for Minecraft Java Edition RCON connection
# - 19132 for Minecraft Bedrock Edition (hosted by GeyserMC)
EXPOSE 25565 25575 19132

# Run the server
CMD ["java", "-jar", "paper.jar"]
