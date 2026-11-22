# Arena+ — Backend

Backend inicial do **Arena+**, um Sistema de Gestão de Competições e Campeonatos Amadores, desenvolvido como projeto acadêmico do curso de Engenharia de Software.

## Objetivo

Disponibilizar uma API REST para apoiar a administração de campeonatos, equipes, inscrições, partidas e resultados, além de permitir a consulta pública de jogos e classificações.

## Tecnologias iniciais

- Java 21
- Spring Boot 3.5.7
- Maven
- Spring Web
- Jakarta Bean Validation
- JUnit 5 / Spring Boot Test

> A persistência e a modelagem definitiva do banco de dados ainda serão alinhadas com o integrante responsável pelo banco. Por isso, esta primeira versão não contém conexão com MySQL nem entidades JPA definitivas.

## Organização atual

```text
src/
├── main/
│   ├── java/br/com/arenaplus/
│   │   ├── ArenaPlusApplication.java
│   │   └── controller/
│   │       ├── HealthController.java
│   │       └── PublicInfoController.java
│   └── resources/
│       └── application.properties
└── test/
    └── java/br/com/arenaplus/
        └── ArenaPlusApplicationTests.java
```

A estrutura será ampliada gradualmente com `controller`, `service`, `repository`, `entity`, `dto`, `enums`, `security` e `exception`, conforme as funcionalidades forem implementadas.

## Requisitos previstos para o desenvolvimento

### Funcionais

- RF01 — Autenticação do organizador.
- RF02 — Gerenciamento de campeonatos.
- RF03 — Gerenciamento de equipes.
- RF04 — Gerenciamento de partidas.
- RF05 — Registro e confirmação de resultados.
- RF06 — Classificação calculada a partir dos resultados confirmados.
- RF07 — Consulta pública de campeonatos, jogos, resultados e classificação, sem exigir login.
- RF08 — Funcionalidades do diretor de equipe, conforme validação do escopo.
- RF09 — Dashboard do organizador.
- RF10 — Histórico de alterações relevantes.

### Regras de negócio principais

1. Uma equipe não pode ser inscrita duas vezes no mesmo campeonato.
2. Uma equipe não pode jogar contra ela mesma.
3. Só pode existir resultado para partida cadastrada e não cancelada.
4. A classificação considera somente resultados confirmados.
5. Pontuação padrão: vitória = 3, empate = 1 e derrota = 0.
6. Alterações de resultados devem recalcular a classificação e registrar o responsável.
7. Campeonato encerrado bloqueia novas inscrições e resultados, salvo reabertura administrativa registrada.
8. Critérios de desempate: pontos, vitórias, saldo de pontos e pontos marcados.

### Requisitos não funcionais

- Segurança e autorização por perfil.
- Validação de dados no backend.
- Integridade dos dados.
- Histórico de auditoria.
- Organização em camadas.
- DTOs para entrada e saída.
- Tratamento padronizado de erros.
- Testes automatizados.
- Documentação da API e instruções de execução.


