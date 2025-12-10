# <img width="24" height="24" alt="calendario" src="https://github.com/user-attachments/assets/cdd86e7a-3e24-419e-afe6-506eed960720" /> Sistema de Eventos

**Professor**: Emilio C. Rodrigues

**Integrantes do Grupo**

🌸 Nancy M. Yuzawa - CP3025641 </br>
🌸 Rafaela F. Santos - CP3026353

## Descrição do Projeto

Este projeto consiste no desenvolvimento de um sistema completo para gestão de eventos, composto por uma API RESTful (backend em Django) e um Aplicativo Mobile (frontend em Flutter).

## Funcionalidades Principais
1. Autenticação: Login e Cadastro de novos usuários.

2. Gestão de Eventos (CRUD): Cadastro completo de eventos com datas e descrição.

3. Gestão de Participantes (CRUD): Cadastro de pessoas com nome, email e telefone.

4. Gestão de Atividades (CRUD): Programação do evento (palestras/workshops/etc) vinculada a um evento pai.

5. Inscrições: Funcionalidade extra para vincular participantes dentro de um evento.

## Telas

<img width="859" height="1510" alt="1" src="https://github.com/user-attachments/assets/69b0917f-63a4-4742-8b44-f3bfb1bf40e5" />
<img width="896" height="1588" alt="2" src="https://github.com/user-attachments/assets/5bbd0d2f-c2b4-4563-bcbf-534f4a10380a" />


## Tecnologias Utilizadas

**Backend (API)**
- Linguagem: Python
- Framework: Django
- API Toolkit: Django Rest Framework (DRF)
- Banco de Dados: SQLite3 (Padrão do Django)
- Autenticação: Token Authentication (DRF)

**Frontend (App)**
- Framework: Flutter
- Linguagem: Dart
- **Pacotes Principais:**
  - http: Para comunicação com a API.
  - intl: Para formatação de datas.

## Endpoints da API
A API roda por padrão em http://127.0.0.1:8000/ (ou 10.0.2.2:8000 no emulador Android).

1. Autenticação
- `POST /api/cadastro/` - Cria um novo usuário.
- `POST /api-token-auth/` - Realiza login e retorna o Token.

2. Eventos (Entidade Principal)
- `GET /api/eventos/` - Lista todos.
- `GET /api/eventos/{id}/` - Detalhes de um evento.
- `POST /api/eventos/` - Cria evento.
- `PUT /api/eventos/{id}/` - Atualiza evento.
- `DELETE /api/eventos/{id}/` - Remove evento.

3. Participantes
- `GET /api/participantes/` - Lista pessoas.
- `POST /api/participantes/` - Cadastra pessoa.
- `PUT /api/participantes/{id}/` - Atualiza dados.
- `DELETE /api/participantes/{id}/` - Remove pessoa.

4. Atividades (Programação do Evento)
- `GET /api/atividades/` - Lista atividades.
- `POST /api/atividades/` - Cria atividade vinculada a um evento.
- `PUT /api/atividades/{id}/` - Atualiza atividade.
- `DELETE /api/atividades/{id}/` - Remove atividade.

## Como Executar o Projeto
| ***É necessário rodar o Backend e o Frontend simultaneamente em terminais separados.***

**Passo 1: Executando a API (Backend)**
1. Verifica a versão do Python:
```
py --version ou python --version
```
2. Na raiz do projeto `Sistema-de-Eventos`, criar um ambiente virtual:
```
python -m venv venv ou py -m venv venv
```
3. Ativar o ambiente virtual:
```
venv\Scripts\activate
```
4. Instalar o Django:
```
pip install django
```
5. Instalar as dependências adicionais:
```
pip install django==5.1 psycopg2-binary django-crispy-forms
pip install -r requirements.txt
```
6. Criar/atualizar as dependências que estão dentro do arquivo `requirements.txt`:
```
pip freeze > requirements.txt
```
7. Sincronizar seus models.py com o banco de dados:
```
python manage.py migrate
```
8. Rodar o servidor Django:
```
python manage.py runserver
```

**Passo 2: Executando o App (Frontend)**
1. Abrir o terminal na pasta `front`:
```
cd front
```
2. Ver a versão do Flutter
```
flutter --version
```
3. Baixar as dependências
```
flutter pub get
```
4. Rodar o projeto direto no chrome
```
flutter run -d chrome
```
***OBS: Pode escolher rodar em outro ambiente.***
