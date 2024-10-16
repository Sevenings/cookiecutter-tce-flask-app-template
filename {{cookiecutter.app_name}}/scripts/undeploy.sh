#!/bin/bash

# Parâmetros de Undeploy
# ----------------------------

source ./scripts/config.sh


# Realizar o Undeploy
# ----------------------------

# Apagar frontend estático do diretório /var/www
sudo rm -r $ROOT_FRONTEND

# Apagar backend da pasta /var/softwaresTCE
sudo rm -r $ROOT_BACKEND

# Remover o serviço criado
sudo rm /usr/lib/systemd/system/$SERVICE_NAME

# Remover configuração do Apache
sudo rm "$APACHE_CONFIG_DIR/$APACHE_CONFIG_FILE"
