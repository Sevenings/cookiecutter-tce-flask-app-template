#!/bin/bash

# Atenção:
# Este Script deve ser executado na raiz do projeto
# Ou pela makefile através do "make deploy"


# Parâmetros de Deploy
# ----------------------------

source ./scripts/config.sh


# Atualizar projeto do git
# ----------------------------

echo "[Deploy] Verificando atualizações do projeto..."
git pull


# Realizar o Deploy
# ----------------------------

# Copia o frontend para o diretório reconhecido pelo apache.
echo "[Deploy] Instalando o Frontend..."
if [ ! -e $ROOT_FRONTEND ]; then
    sudo rm -r $ROOT_FRONTEND   # Apaga os arquivos antigos
fi
sudo mkdir -p $ROOT_FRONTEND
sudo cp "app/templates/index.html" $ROOT_FRONTEND"/index.html"
sudo cp -r "app/static" $ROOT_FRONTEND"/static"

# Copia o arquivo htaccess para o diretório do frontend
if [ -e $HTACCESS_FILE ]; then
    echo "[Deploy] Instalando o arquido htaccess..."
    sudo cp $HTACCESS_FILE $ROOT_FRONTEND"/.htaccess"
fi

# Se existir, dá um git pull para atualizar os conteudos
if [ -e $ROOT_BACKEND ]; then
    echo "[Deploy] Projeto antigo do backend encontrado, atualizando arquivos..."

    dir_atual=$(pwd)
    cd $ROOT_BACKEND
    git pull
    cd $dir_atual
    
else # Se não houver a pasta do Backend, a cria e clona o repositório para ela
    echo "[Deploy] Projeto do backend não encontrado, criando os arquivos..."

    # Cria a pasta dos softwares, caso não exista
    sudo mkdir -p $ROOT_SOFTWARES

    # Clona o repositório para o diretório dos softwares
    git clone $GIT_REPO_LINK
    sudo mv $GIT_REPO_NAME $ROOT_BACKEND
fi

# Antes de realizar o setup, altera as permissões de escrita dos arquivos do Backend para o usuário atual
sudo chown -R $(whoami) $ROOT_BACKEND

# Realiza o setup do projeto
dir_atual=$(pwd)
cd $ROOT_BACKEND
make setup
cd $dir_atual

# Adiciona permissão de execução ao deploy.sh
if [ ! -x "$ROOT_BACKEND/scripts/deploy.sh" ]; then
    sudo chmod +x "$ROOT_BACKEND/scripts/deploy.sh"
fi


# Configuração do Apache
# ------------------------------------
if [ -e "./scripts/$APACHE_CONFIG_FILE" ]; then
    echo "[Deploy] Arquivo de configuração apache encontrado, copiando para a pasta de configuração..."
    sudo cp "./scripts/$APACHE_CONFIG_FILE" "$APACHE_CONFIG_DIR/$APACHE_CONFIG" 
fi


# Copia o serviço para sua pasta
echo "Instalando o serviço..."
if [ -e "/usr/lib/systemd/system/$SERVICE_NAME" ]; then   # Antes de copiar, remove o arquivo anterior
    sudo rm "/usr/lib/systemd/system/$SERVICE_NAME"   
fi
sudo cp scripts/$SERVICE_NAME /usr/lib/systemd/system/$SERVICE_NAME


# Habilita o serviço 
if ! systemctl is-enabled "$SERVICE_NAME" && [ $AUTO_HABILITAR_SERVICO ]; then
    echo "[Deploy] Serviço está desabilitado. Habilitando..."
    sudo systemctl enable "$SERVICE_NAME"
fi


# Ativa o serviço
echo "Ativando o serviço..."
make service-reload
make service-restart

