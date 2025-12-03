# <img width="24" height="24" alt="calendario" src="https://github.com/user-attachments/assets/cdd86e7a-3e24-419e-afe6-506eed960720" /> Sistema de Eventos

**Professor**: Emilio Carlos Rodrigues

**Integrantes do Grupo**

🌸 Nancy Miyuki Yuzawa - CP3025641 </br>
🌸 Rafaela Ferreira Dos Santos - CP3026353

## Descrição do Projeto

Este projeto consiste no desenvolvimento de um aplicativo mobile Flutter integrado a uma API própria, cujo objetivo é gerenciar eventos.
O sistema permite cadastrar, listar, atualizar e excluir eventos, atendendo aos requisitos CRUD do trabalho.

O tema escolhido foi um Sistema de Eventos, permitindo que o usuário registre informações como nome do evento, data, local e descrição.

## Tecnologias Utilizadas

- Flutter
- Dart
- http (para requisições HTTP)

 ### API Backend
 - Python (Flask ou FastAPI) ou Node.js (Express)
 - Banco de dados (SQLite/MySQL/PostgreSQL) — escolha do grupo
 - JSON como formato de resposta

## Entidade Principal — Evento

Modelo usado pela API:

```
{
  "id": 1,
  "nome": "Semana da Tecnologia",
  "data": "2025-11-12",
  "local": "Auditório Principal",
  "descricao": "Evento com palestras e workshops."
}
```

## Endpoints da API
1. **Listar todos os eventos**
   </br>GET /eventos
   </br> ⤷ Retorna uma lista com todos os eventos cadastrados.

2. **Buscar um evento pelo ID**
   </br>GET /eventos/{id}
   </br>⤷ Retorna apenas o evento correspondente ao ID informado.

3. **Criar um novo evento**
   </br>POST /eventos
   </br>⤷ Corpo esperado:
   
  ```
  {
    "nome": "Hackathon Universitário",
    "data": "2025-09-01",
    "local": "Laboratório 3",
    "descricao": "Competição de programação."
  }
  ```
4. **Atualizar um evento existente**
  </br>PUT /eventos/{id}
  </br>⤷ Corpo esperado:
  
  ```
  {
    "nome": "Hackathon Atualizado",
    "data": "2025-09-01",
    "local": "Laboratório 4",
    "descricao": "Versão atualizada do evento."
  }
  ```

  5. **Excluir um evento**
  </br>DELETE /eventos/{id}
  </br>⤷ Remove o evento correspondente ao ID informado.

## Funcionalidades do Aplicativo
- Listar eventos provenientes da API
- Cadastrar novos eventos
- Editar eventos existentes
- Excluir eventos
- Interface simples, clara e funcional

## Como Executar o Projeto
1. **Rodando a API**
   </br></br>Entre na pasta da API e execute:
   ```
   python app.py
   ```
   A API irá iniciar em:
   ``
   http://localhost:8000 (ou porta configurada pelo grupo)
   `` 


3. **Rodando o Aplicativo Flutter**
   </br></br>Dentro da pasta do app, execute:
   ```
   flutter pub get
   flutter run
   ```
   O app será aberto no emulador ou celular conectado.
