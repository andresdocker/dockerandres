# Usa la imagen base de Jenkins con Java 17
FROM jenkins/jenkins:2.462.3-jdk17

# Cambia a usuario root para instalar dependencias
USER root

# Actualiza el sistema y añade el soporte para docker-cli
RUN apt-get update && apt-get install -y lsb-release \
  && curl -fsSLo /usr/share/keyrings/docker-archive-keyring.asc \
  https://download.docker.com/linux/debian/gpg \
  && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.asc] \
  https://download.docker.com/linux/debian $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list \
  && apt-get update && apt-get install -y docker-ce-cli \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# Cambia nuevamente a usuario Jenkins
USER jenkins

# Instala los plugins necesarios con el CLI de plugins de Jenkins
RUN jenkins-plugin-cli --plugins "blueocean docker-workflow"

# Establece el punto de entrada predeterminado para el contenedor
ENTRYPOINT ["/usr/bin/tini", "--", "/usr/local/bin/jenkins.sh"]
