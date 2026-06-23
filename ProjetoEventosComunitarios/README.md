# 🎉 Sistema de Gerenciamento de Eventos Comunitários

## 📌 Descrição do Projeto

Este projeto foi desenvolvido para a disciplina de **Programação Orientada a Objetos** do CEFET-RJ.

O sistema tem como objetivo auxiliar na organização e gerenciamento de eventos comunitários, permitindo o cadastro de usuários, criação de eventos, inscrição de participantes e geração de relatórios.

O sistema simula o funcionamento de uma prefeitura comunitária que gerencia eventos como palestras, oficinas, feiras e cursos.

---

## 🎯 Objetivo

Desenvolver um sistema completo utilizando:

- Conceitos de Programação Orientada a Objetos
- Persistência de dados com banco relacional (MySQL)
- Interface gráfica com Swing
- Implementação de regras de negócio

---

## ⚙️ Funcionalidades do Sistema

### 👤 Usuários
- Cadastro de usuários
- Tipos de usuário:
  - ORGANIZADOR
  - VOLUNTARIO
  - PUBLICO

---

### 📅 Eventos
- Cadastro de eventos
- Definição de:
  - Título
  - Descrição
  - Data e hora
  - Capacidade
  - Categoria
  - Local

---

### 📝 Inscrições
- Inscrição de usuários em eventos
- Associação entre usuário e evento

---

### 📊 Relatórios
- Exibição de inscrições realizadas
- Visualização de participantes por evento

---

## 🧠 Regras de Negócio Implementadas

O sistema possui validações importantes para garantir seu correto funcionamento:

### ✅ 1. Verificação de lotação
- O sistema impede a inscrição quando o evento atinge a capacidade máxima.

### ✅ 2. Inscrição duplicada
- Um usuário não pode se inscrever mais de uma vez no mesmo evento.

### ✅ 3. Validação de campos obrigatórios
- Campos essenciais (nome, email, data etc.) devem ser preenchidos.

### ✅ 4. Validação de data
- Não é permitido cadastrar eventos com data no passado.

---

## 🛠️ Tecnologias Utilizadas

- Java
- Swing (Interface gráfica)
- JDBC (Conexão com banco de dados)
- MySQL
- VS Code

---

## 🗄️ Banco de Dados

O sistema utiliza um banco de dados relacional com as seguintes principais tabelas:

- `usuario`
- `evento`
- `inscricao`
- `participacao`
- `categoria_evento`
- `local_evento`
- `voluntario_evento`
- `relatorio`

---

## 💻 Interface do Sistema

O sistema possui:

- Tela de cadastro de usuário
- Tela de cadastro de evento
- Tela de inscrição
- Tela de relatório

--- 

## 🔀 Variações Escolhidas

Foram implementadas algumas melhorias em relação ao modelo básico:

✅ Interface simplificada de inscrição

O usuário se inscreve usando email
Evita uso de IDs manuais


✅ Uso de ComboBox

Seleção de eventos via lista
Evita erros de digitação


✅ Separação de data e hora

Data: YYYY-MM-DD
Hora: HH:MM
Facilita entrada de dados


✅ Validação direta na interface

Erros tratados com mensagens
Melhor experiência do usuário


✅ Relatórios com JTable

Exibição de dados em tabela
Integração direta com SQL

---

## Execução

✅ Como rodar o projeto

Abrir o projeto no VS Code
Garantir que o banco está rodando
Executar:
src/main/Main.java


✅ O sistema abre com:

Cadastrar Usuário
Cadastrar Evento
Inscrição
Relatório

---

## ⚙️ Configuração do Banco de Dados

### 1️⃣ Criar o banco:

```sql
CREATE DATABASE sistema_eventos_comunitarios;