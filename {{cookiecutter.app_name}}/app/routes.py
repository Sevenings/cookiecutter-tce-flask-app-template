from flask import jsonify
from app import app


RAIZ = '/{{ cookiecutter.app_name }}'


""" WEB PAGE 
------------------------------------------""" 

@app.route('/')    # Rota para testes locais
@app.route(RAIZ + '/')
@app.route(RAIZ + '/index')
def index():
    return "Hello"


""" API
------------------------------------------""" 

@app.route(RAIZ + '/api/hello')
def hello():
    return "Hello from {{ cookiecutter.project_name }}"

