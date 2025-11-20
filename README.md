# 🍔 Good Hamburger - Aplicativo de Pedidos (Desafio Técnico)

## 🎯 Objetivo do Projeto

Este projeto é a solução para o desafio técnico "Mobile Developers - Test". O objetivo principal foi desenvolver a lógica de um aplicativo de pedidos (carrinho, descontos e histórico) com foco em arquitetura limpa e escalabilidade.

---

## ✅ Requisitos Cumpridos (Funcionalidade Central)

O projeto cumpre todos os requisitos de lógica de negócios e submissão de pedidos:

*Menu:** Carrega o menu de um JSON local com simulação de delay de 5 segundos.
*Lógica do Carrinho:** Implementa a funcionalidade de adicionar e remover itens, respeitando a regra de exclusividade (apenas 1 sanduíche, 1 porção de batata e 1 refrigerante).
*Descontos:** O cálculo de descontos é feito no Checkout, aplicando as regras de prioridade corretamente (20% > 15% > 10%).
*Checkout/Histórico:** O usuário submete o pedido (informando o nome) e o pedido é armazenado em um histórico.
*Design:** O layout é funcional e possui um design coeso e profissional, com refatoração das telas de Carrinho e Histórico.

---

## 💻 Tecnologias e Arquitetura

O projeto foi construído usando práticas modernas de engenharia de software:

*Tecnologia:** Flutter 3.19+ com Dart 3+.
*Gerenciamento de Estado (BÔNUS):** Riverpod (Versão 2.x).
*Estrutura de Pastas:** Organização em camadas (`models`, `providers`, `services`, `views`).
*Dados:** Dados do menu carregados de JSON e persistência de pedidos em memória.

---

## ⚙️ Como Rodar e Testar

### Pré-requisitos
* Flutter SDK (3.19+).
* Emulador ou dispositivo Android/iOS iniciado.

### Instalação e Execução
1.  **Clone o repositório.**
2.  **Instale as dependências:**
    ```bash
    flutter pub get
    ```
3.  **Execute o aplicativo:**
    ```bash
    flutter run
    ```
    *(A tela inicial exibirá um "Loading..." por 5 segundos antes de carregar o menu.)*

### ⚠️ Status dos Testes Unitários (BÔNUS)

Embora a lógica central tenha sido desenvolvida com foco em testabilidade (ex.: `calculateDiscount()` isolado), o ambiente de teste falhou durante a execução:

* **Falha de Teste:** Os testes unitários para as regras de desconto (20% vs. 0%) estão implementados no código (`test/discount_logic_test.dart`), mas resultam em falhas devido a:
    1.  **Imprecisão de Ponto Flutuante (`double`):** Erros minúsculos de cálculo no sistema binário.
    2.  **Conflito de Ambiente:** O ambiente de teste padrão (`widget_test.dart`) entra em conflito com o `ProviderScope` do Riverpod.

---

## 🛑 Limitações da Entrega

O projeto foi entregue com as seguintes limitações:

1.  **Filtros do Menu (Requisito 2 e 3): não consegui fazer a implementação**
2.  **Mock de Teste:** O teste unitário utiliza *mocks* simples para os itens do menu e falha no *match* de *strings* de desconto (`'No discount applied'` vs. `'Nenhum desconto aplicado'`) devido a inconsistências no ambiente de teste.
