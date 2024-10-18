# Parâmetros gerais
PROJECT_NAME="{{cookiecutter.app_name}}"
SERVICE_NAME="{{cookiecutter.service_name}}"

ROOT_FRONTEND=/var/www/automacao.tce.go.gov.br/$PROJECT_NAME

ROOT_SOFTWARES=/var/softwaresTCE
ROOT_BACKEND=$ROOT_SOFTWARES"/"$PROJECT_NAME

GIT_REPO_NAME="{{ cookiecutter.git_repo_name }}"
GIT_REPO_OWNER="{{ cookiecutter.git_repo_owner }}"
GIT_REPO_LINK="https://github.com/$GIT_REPO_OWNER/$GIT_REPO_NAME.git"

APACHE_CONFIG_DIR="/etc/httpd/conf.d"
APACHE_CONFIG_FILE="{{ cookiecutter.apache_config_name }}"

HTACCESS_FILE="scripts/htaccess"

# Configurações
AUTO_HABILITAR_SERVICO=true
