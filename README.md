# Agenda Viagem

Agenda Viagem é um aplicativo Flutter que permite aos usuários registrar e gerenciar suas experiências de viagem. Os usuários podem adicionar entradas de viagem com informações como título, descrição, localização, data e uma nota de 0 a 10 as viagens.

## Funcionalidades

- Adicionar, editar e excluir entradas de viagem
- Selecionar uma data para a entrada de viagem

## Tecnologias Utilizadas

- Flutter
- Dart
- intl (para formatação de datas)
- Firebase Firestore (para armazenamento em nuvem)
- Firebase Auth (para autenticação de usuários)

## Estrutura do Projeto

- `lib/`: Contém o código-fonte do aplicativo.
- `service/`: Contém classes auxiliares para o CRUD do Firestore, como `firestore_service.dart`.
- `view/`: Contém as telas do aplicativo.
  
## Banco de Dados

O aplicativo utiliza o **Firebase Firestore** para armazenar as entradas de viagem na nuvem. As principais operações de banco de dados incluem:

- **Adicionar**: Criação de novas entradas de viagem no Firestore.
- **Editar**: Atualização de entradas existentes.
- **Excluir**: Remoção de entradas do Firestore.
- **Consulta**: Recuperação de entradas de viagem do Firestore, com suporte a consultas em tempo real.

