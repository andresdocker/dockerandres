# Usa la imagen base de Jenkins con Java 17
FROM jenkins/jenkins:2.462.3-jdk17

# Cambia a usuario root para instalar dependencias
USER root

# Actualiza el sistema y añade soporte para Docker CLI
RUN apt-get update && \
    apt-get install -y lsb-release && \
    curl -fsSLo /usr/share/keyrings/docker-archive-keyring.asc https://download.docker.com/linux/debian/gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.asc] https://download.docker.com/linux/debian $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list && \
    apt-get update && \
    apt-get install -y docker-ce-cli && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Cambia de nuevo a usuario Jenkins
USER jenkins

# Instala los plugins necesarios
RUN jenkins-plugin-cli --plugins "blueocean docker-workflow pipeline git credentials-binding slack"

# Documentación sobre la imagen (opcional)
LABEL maintainer="TuNombre <tuemail@example.com>"
LABEL description="Jenkins personalizado con soporte para Docker y plugins esenciales"

# Puertos expuestos por Jenkins
EXPOSE 8080 50000
