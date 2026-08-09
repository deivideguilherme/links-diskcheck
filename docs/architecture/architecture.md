# Links DiskCheck — Arquitetura

> **Documento:** Arquitetura do Projeto
> **Versão:** 0.1.0
> **Data:** 2026-08-09
> **Status:** Em desenvolvimento
> **Plataforma-alvo:** Ubuntu Desktop 26.04 LTS
> **Linguagem principal:** Bash
> **Autor:** Deivide Guilherme

---

## 1. Objetivo

Este documento define a arquitetura estrutural e funcional do Links DiskCheck.

Seu objetivo é estabelecer responsabilidades, dependências, fluxo de execução e limites entre os componentes da aplicação.

Alterações relevantes na arquitetura deverão ser justificadas, validadas e registradas na documentação de decisões arquitetônicas.

---

## 2. Princípios Arquiteturais

A arquitetura segue os seguintes princípios:

* Ponto único de entrada.
* Separação de responsabilidades.
* Responsabilidade única por módulo.
* Baixo acoplamento entre componentes.
* Reutilização de funções comuns.
* Centralização das regras de decisão.
* Coleta de dados separada da avaliação.
* Tratamento explícito de erros.
* Rastreabilidade das operações.
* Validação antes da execução de operações críticas.
* Desenvolvimento incremental.
* Compatibilidade com ShellCheck.

---

## 3. Ponto de Entrada

O único ponto de entrada da aplicação é:

```text
main.sh
```

O usuário não deverá executar diretamente os demais módulos.

O `main.sh` deverá:

1. Identificar a raiz do projeto.
2. Validar os componentes necessários para inicialização.
3. Acionar o `bootstrap.sh`.
4. Iniciar o fluxo principal da aplicação.

---

## 4. Bootstrap

O:

```text
bootstrap.sh
```

é responsável pela preparação do ambiente da aplicação.

Entre suas responsabilidades estão:

* carregar configurações;
* validar módulos necessários;
* carregar bibliotecas;
* carregar componentes do núcleo;
* carregar componentes da interface;
* carregar componentes de detecção;
* carregar componentes de teste;
* carregar parsers;
* carregar o Health Engine;
* carregar componentes de relatório.

O carregamento deverá utilizar uma rotina centralizada:

```text
load_module()
```

Essa abordagem evita que cada módulo precise conhecer diretamente a localização ou o mecanismo de carregamento de outros módulos.

---

## 5. Organização por Camadas

A aplicação será organizada conceitualmente nas seguintes camadas:

```text
┌─────────────────────────────┐
│            UI               │
├─────────────────────────────┤
│           CORE              │
├─────────────────────────────┤
│       DETECTION / TESTS     │
├─────────────────────────────┤
│          PARSERS            │
├─────────────────────────────┤
│       HEALTH ENGINE         │
├─────────────────────────────┤
│       REPORTS / LOGS        │
├─────────────────────────────┤
│            LIB              │
└─────────────────────────────┘
```

A separação é conceitual e representa responsabilidades, não necessariamente uma arquitetura de processos independentes.

---

## 6. Diretórios

### 6.1 `config/`

Responsável pelas configurações da aplicação.

Deve conter dados e parâmetros utilizados pelos módulos.

Não deve conter lógica de negócio.

---

### 6.2 `core/`

Responsável pelo núcleo da aplicação.

Deve coordenar o fluxo geral sem concentrar regras específicas de diagnóstico.

---

### 6.3 `detect/`

Responsável pela descoberta e identificação dos dispositivos.

Inclui informações como:

* discos físicos;
* interfaces;
* fabricante;
* modelo;
* firmware;
* capacidade;
* número de série;
* capacidades técnicas.

---

### 6.4 `engine/`

Responsável pela avaliação técnica dos resultados.

O Health Engine é a autoridade final sobre a classificação do dispositivo.

---

### 6.5 `lib/`

Contém funções reutilizáveis.

Exemplos:

* manipulação de strings;
* validação;
* filesystem;
* terminal;
* timers;
* logging;
* execução controlada de comandos.

---

### 6.6 `logs/`

Armazena os registros da aplicação.

Estrutura:

```text
logs/
├── runtime/
├── debug/
└── archive/
```

Cada finalidade deverá possuir seu próprio espaço de armazenamento.

---

### 6.7 `parsers/`

Contém os parsers específicos de fabricantes.

Fabricantes inicialmente previstos:

* Kingston;
* Samsung;
* Crucial;
* Patriot;
* Western Digital;
* SanDisk;
* Seagate;
* Dell;
* Genérico.

Os parsers deverão utilizar informações técnicas sempre que disponíveis.

---

### 6.8 `reports/`

Responsável pela geração e formatação dos relatórios.

---

### 6.9 `temp/`

Armazena arquivos temporários utilizados durante a execução.

A aplicação deverá controlar a criação, utilização e remoção desses arquivos.

Arquivos relevantes para diagnóstico de falhas poderão ser preservados.

---

### 6.10 `tests/`

Responsável pela execução dos testes de diagnóstico.

Os testes deverão:

* verificar compatibilidade;
* executar o teste;
* coletar resultados;
* registrar erros;
* retornar dados padronizados.

Os testes não deverão determinar diretamente o resultado final do dispositivo.

---

### 6.11 `ui/`

Responsável exclusivamente pela interação com o usuário.

Exemplos:

* menus;
* mensagens;
* progresso;
* diálogos;
* resumo final.

A interface não deverá conter regras de aprovação ou reprovação.

---

## 7. Fluxo Geral

O fluxo conceitual da aplicação será:

```text
                    Usuário
                       │
                       ▼
                    main.sh
                       │
                       ▼
                 bootstrap.sh
                       │
                       ▼
                Inicialização
                       │
                       ▼
                  Interface
                       │
                       ▼
             Seleção do dispositivo
                       │
                       ▼
                Detecção técnica
                       │
                       ▼
              Identificação do
                  fabricante
                       │
                       ▼
                  Carregamento
                   do parser
                       │
                       ▼
              Seleção dos testes
                       │
                       ▼
              Execução dos testes
                       │
                       ▼
             Coleta dos resultados
                       │
                       ▼
                 Health Engine
                       │
              ┌────────┴────────┐
              ▼                 ▼
           APROVADO          REPROVADO
              │                 │
              └────────┬────────┘
                       ▼
                   Relatório
                       │
                       ▼
                    Final
```

---

## 8. Separação entre Coleta e Decisão

Esta é uma decisão arquitetural fundamental.

Os módulos de coleta não deverão decidir se um dispositivo está saudável.

Exemplo:

```text
SMART
  │
  ├── coleta atributos
  ├── coleta resultados
  └── retorna dados
          │
          ▼
    Health Engine
          │
          ├── aplica regras
          ├── avalia severidade
          └── determina resultado
```

Isso evita que regras de aprovação sejam duplicadas em diferentes módulos.

---

## 9. Health Engine

O Health Engine deverá ser o único componente autorizado a determinar:

```text
APROVADO PARA USO
```

ou:

```text
REPROVADO PARA USO
```

Suas responsabilidades incluem:

* receber resultados;
* validar dados recebidos;
* aplicar regras;
* determinar severidade;
* identificar falhas críticas;
* correlacionar resultados;
* produzir justificativa técnica;
* determinar resultado final.

Novas regras de aprovação ou reprovação deverão ser implementadas exclusivamente no Health Engine.

---

## 10. Dependências entre Componentes

As dependências deverão seguir uma direção controlada.

Conceitualmente:

```text
main.sh
   │
   ▼
bootstrap.sh
   │
   ▼
config
   │
   ▼
lib
   │
   ▼
core
   │
   ├──────────────┐
   ▼              ▼
detect           ui
   │
   ▼
parsers
   │
   ▼
tests
   │
   ▼
engine
   │
   ▼
reports
```

A estrutura exata de carregamento será definida durante a implementação do bootstrap.

---

## 11. Regra de Dependências

Um módulo deverá depender somente de componentes que estejam abaixo ou no mesmo nível arquitetural quando isso for necessário e justificado.

Não deverá existir dependência circular.

Exemplo proibido:

```text
A → B
B → C
C → A
```

Dependências compartilhadas deverão ser preferencialmente movidas para `lib/`.

---

## 12. Comunicação entre Módulos

Os módulos deverão preferencialmente comunicar resultados através de:

* variáveis bem definidas;
* códigos de retorno;
* estruturas padronizadas;
* arquivos temporários quando necessário;
* funções públicas claramente estabelecidas.

A implementação deverá evitar depender de variáveis globais sem justificativa.

---

## 13. Execução de Comandos Externos

Ferramentas externas como:

```text
smartctl
nvme
fio
badblocks
hdparm
lsblk
blkid
udevadm
iostat
journalctl
```

deverão ser executadas de maneira controlada.

A aplicação deverá:

1. verificar disponibilidade;
2. validar parâmetros;
3. executar;
4. capturar saída;
5. capturar código de retorno;
6. registrar erros;
7. disponibilizar o resultado ao módulo responsável.

---

## 14. Operações Críticas

Operações potencialmente destrutivas ou de impacto elevado deverão possuir:

* validação prévia;
* confirmação quando aplicável;
* identificação inequívoca do dispositivo;
* tratamento de erros;
* timeout quando aplicável;
* registro detalhado;
* mecanismo de interrupção segura quando possível.

Particular atenção deverá ser dada a testes de escrita e testes que possam modificar dados.

---

## 15. Logs

Os logs deverão permitir reconstruir a execução da aplicação.

Sempre que tecnicamente possível deverão registrar:

* início;
* fim;
* etapa;
* dispositivo;
* comando;
* resultado;
* erro;
* tempo;
* decisão.

O log técnico deverá possuir informações suficientes para investigação posterior.

---

## 16. Relatórios

O relatório deverá utilizar os resultados efetivamente coletados durante a execução.

Não deverá inventar ou inferir dados ausentes.

O resultado final deverá conter justificativa técnica quando houver reprovação.

---

## 17. Tratamento de Erros

Erros não deverão ser ocultados.

Cada camada deverá tratar somente os erros sob sua responsabilidade.

Quando um erro não puder ser tratado localmente, deverá ser propagado para uma camada superior.

O encerramento da aplicação deverá preservar informações necessárias para diagnóstico.

---

## 18. Escalabilidade

A arquitetura deverá permitir:

* inclusão de novos fabricantes;
* inclusão de novos testes;
* inclusão de novas regras;
* inclusão de novos formatos de relatório;
* substituição da interface;
* expansão da detecção de hardware.

A inclusão de uma nova funcionalidade não deverá exigir alterações desnecessárias em módulos não relacionados.

---

## 19. Compatibilidade

A plataforma primária será:

```text
Ubuntu Desktop 26.04 LTS
```

A compatibilidade com outras distribuições poderá ser considerada futuramente, mas não constitui requisito inicial.

A compatibilidade das ferramentas deverá ser validada conforme as versões efetivamente disponíveis no ambiente.

---

## 20. Validação Arquitetural

Antes da implementação de componentes relevantes deverão ser verificadas:

* responsabilidade do módulo;
* dependências;
* caminho de carregamento;
* tratamento de erros;
* impacto sobre módulos existentes;
* compatibilidade;
* necessidade de atualização da documentação.

Alterações estruturais relevantes deverão ser registradas em `architecture-decisions.md`.

---

## 21. Estado do Documento

Este documento representa a arquitetura aprovada até a data indicada no cabeçalho.

A arquitetura poderá evoluir durante o desenvolvimento.

Mudanças relevantes deverão:

1. Ser justificadas.
2. Ser discutidas antes da implementação.
3. Ser registradas.
4. Ser validadas.
5. Ser refletidas na documentação correspondente.

---

## Histórico

| Versão | Data       | Alteração                    |
| ------ | ---------- | ---------------------------- |
| 0.1.0  | 2026-08-09 | Criação inicial do documento |

