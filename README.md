# Links DiskCheck

> **Status do projeto:** Em desenvolvimento ativo
> **Versão atual:** 0.1.0
> **Plataforma-alvo:** Ubuntu Desktop 26.04 LTS
> **Linguagem principal:** Bash

O **Links DiskCheck** é uma aplicação modular para diagnóstico técnico de dispositivos de armazenamento, desenvolvida com foco em confiabilidade, rastreabilidade, segurança e redução de falsos positivos e falsos negativos.

O projeto foi concebido para analisar diferentes tipos de dispositivos de armazenamento, incluindo HDDs, SSDs SATA e SSDs NVMe, utilizando ferramentas especializadas do ecossistema Linux.

> **Importante:** o projeto encontra-se em desenvolvimento. A arquitetura e os componentes estão sendo implementados e validados de forma incremental.

---

## Objetivo

O objetivo principal do Links DiskCheck é fornecer uma ferramenta profissional capaz de realizar uma avaliação técnica abrangente de dispositivos de armazenamento e determinar, de forma centralizada e justificável, se o dispositivo está:

```text
APROVADO PARA USO
```

ou:

```text
REPROVADO PARA USO
```

A decisão final será realizada exclusivamente pelo **Health Engine**, com base nos dados efetivamente coletados pelos módulos de diagnóstico.

Os módulos responsáveis pela coleta e execução dos testes não poderão aprovar ou reprovar diretamente um dispositivo.

---

## Princípios do Projeto

O desenvolvimento do Links DiskCheck segue os seguintes princípios:

* Confiabilidade antes de velocidade.
* Legibilidade antes de otimização.
* Modularidade.
* Responsabilidade única dos módulos.
* Centralização das regras de decisão.
* Tratamento explícito de erros.
* Rastreabilidade completa dos testes.
* Ausência de decisões baseadas em hipóteses não confirmadas.
* Minimização de falsos positivos.
* Minimização de falsos negativos.
* Compatibilidade com ShellCheck.
* Desenvolvimento incremental.
* Validação antes de cada avanço.
* Versionamento contínuo com Git.
* Evitar retrabalho por meio de decisões arquiteturais documentadas.

---

## Arquitetura

A aplicação possui um único ponto de entrada:

```text
main.sh
    │
    ▼
bootstrap.sh
    │
    ├── Configuração
    │
    ├── Bibliotecas
    │
    ├── Core
    │
    ├── Interface
    │
    ├── Detecção
    │
    ├── Testes
    │
    ├── Parsers
    │
    ├── Health Engine
    │
    └── Relatórios
```

O usuário deverá executar somente:

```bash
./main.sh
```

Os demais módulos serão carregados internamente pela aplicação.

---

## Fluxo de Inicialização

O fluxo planejado da aplicação é:

```text
Usuário
   │
   ▼
main.sh
   │
   ├── identifica a raiz do projeto
   │
   ├── valida bootstrap.sh
   │
   ▼
bootstrap.sh
   │
   ├── carrega configurações
   │
   ├── carrega bibliotecas
   │
   ├── carrega módulos Core
   │
   ├── carrega interface
   │
   ├── carrega detecção
   │
   ├── carrega testes
   │
   ├── carrega parsers
   │
   ├── carrega Health Engine
   │
   └── carrega relatórios
   │
   ▼
Aplicação inicializada
```

O carregamento dos módulos será centralizado na função:

```text
load_module()
```

A função será responsável por validar e carregar os módulos de maneira padronizada.

---

## Estrutura do Projeto

```text
links-diskcheck/
│
├── main.sh
├── bootstrap.sh
├── README.md
│
├── config/
│   ├── defaults.conf
│   ├── colors.conf
│   ├── timeouts.conf
│   └── logging.conf
│
├── core/
│   ├── application.sh
│   ├── dispatcher.sh
│   └── shutdown.sh
│
├── detect/
│   ├── capabilities.sh
│   ├── disks.sh
│   ├── interfaces.sh
│   └── manufacturer.sh
│
├── engine/
│   ├── health.sh
│   ├── rules.sh
│   └── severity.sh
│
├── lib/
│   ├── arrays.sh
│   ├── commands.sh
│   ├── filesystem.sh
│   ├── logger.sh
│   ├── strings.sh
│   ├── terminal.sh
│   ├── timers.sh
│   ├── utils.sh
│   └── validators.sh
│
├── logs/
│   ├── runtime/
│   ├── debug/
│   └── archive/
│
├── parsers/
│   ├── crucial.sh
│   ├── dell.sh
│   ├── generic.sh
│   ├── kingston.sh
│   ├── patriot.sh
│   ├── samsung.sh
│   ├── sandisk.sh
│   ├── seagate.sh
│   └── wd.sh
│
├── reports/
│   ├── formatter.sh
│   └── generator.sh
│
├── temp/
│
├── tests/
│   ├── badblocks.sh
│   ├── collector.sh
│   ├── fio.sh
│   ├── hdparm.sh
│   ├── nvme.sh
│   ├── performance.sh
│   ├── selftest.sh
│   └── smart.sh
│
├── ui/
│   ├── dialog.sh
│   ├── menu.sh
│   ├── messages.sh
│   ├── progress.sh
│   └── summary.sh
│
└── docs/
    ├── architecture/
    │   ├── architecture.md
    │   └── architecture-decisions.md
    │
    ├── development/
    │   ├── coding-style.md
    │   ├── development-standards.md
    │   └── git-workflow.md
    │
    └── roadmap.md
```

A estrutura poderá evoluir durante o desenvolvimento, porém alterações estruturais deverão ser justificadas, validadas e documentadas.

---

## Responsabilidade dos Diretórios

### `config/`

Centraliza configurações da aplicação.

Os arquivos de configuração deverão conter somente dados e definições necessárias à aplicação, não devendo conter lógica de negócio ou execução automática.

---

### `core/`

Contém componentes responsáveis pelo núcleo de execução da aplicação e pelo fluxo geral do sistema.

---

### `detect/`

Responsável pela descoberta e identificação dos dispositivos e respectivas características.

---

### `engine/`

Contém o **Health Engine** e os componentes relacionados à avaliação técnica.

É neste domínio que deverão estar centralizadas as regras responsáveis pela decisão final.

---

### `lib/`

Contém funções reutilizáveis compartilhadas por diferentes módulos da aplicação.

---

### `logs/`

Armazena os registros produzidos pela aplicação.

A estrutura prevê separação entre:

* execução;
* depuração;
* arquivamento.

---

### `parsers/`

Contém parsers específicos para fabricantes e dispositivos.

Fabricantes inicialmente previstos:

* Kingston
* Samsung
* Crucial
* Patriot
* Western Digital
* SanDisk
* Seagate
* Dell
* Genérico

Os parsers deverão utilizar, sempre que possível, informações técnicas provenientes de:

* Vendor.
* Model Number.
* Firmware.
* SMART.
* NVMe Identify Controller.

O nome comercial do dispositivo não deverá ser utilizado como única fonte de identificação.

---

### `reports/`

Responsável pela geração e formatação dos relatórios técnicos.

---

### `temp/`

Armazena arquivos temporários utilizados durante a execução.

Arquivos temporários relevantes para diagnóstico deverão ser preservados quando uma falha exigir investigação posterior.

---

### `tests/`

Contém os módulos responsáveis pela execução e coleta dos testes.

Os módulos de teste deverão:

1. Executar o teste quando compatível.
2. Coletar os resultados.
3. Validar os resultados obtidos.
4. Retornar dados padronizados.
5. Informar erros.
6. Não tomar a decisão final sobre aprovação ou reprovação.

---

### `ui/`

Contém os componentes responsáveis pela interface de terminal.

A implementação poderá utilizar:

* `dialog`;
* `whiptail`;
* equivalente compatível.

---

## Ferramentas

Quando apropriado, a aplicação poderá utilizar:

```text
smartctl
nvme-cli
fio
badblocks
hdparm
lsblk
blkid
udevadm
iostat
journalctl
```

A disponibilidade, versão e compatibilidade das ferramentas deverão ser verificadas antes da execução dos testes correspondentes.

---

## Testes Planejados

A execução dos testes dependerá do tipo, interface, características e compatibilidade do dispositivo.

### SMART

* SMART Short.
* SMART Extended.
* Self-Test.
* Atributos SMART.
* Temperatura.
* Horas de uso.
* Power Cycles.
* Media Errors.
* CRC.
* Pending Sectors.
* Reallocated Sectors.
* Offline Uncorrectable.

### SSD

Quando suportado pelo dispositivo:

* Wear Level.
* TBW.
* Percentage Used.
* Indicadores específicos do fabricante.

### NVMe

Quando suportado:

* NVMe Health Log.
* Percentage Used.
* Data Units Read.
* Data Units Written.
* Media and Data Integrity Errors.
* Error Information Log.
* Temperatura.
* Indicadores de vida útil.

### Desempenho

Quando aplicável:

* Leitura sequencial.
* Leitura aleatória.
* Escrita controlada.
* Testes utilizando `fio`.

### Superfície

Quando aplicável e tecnicamente seguro:

* `badblocks`.
* Testes de leitura.

A aplicação deverá validar previamente a compatibilidade e o impacto de cada teste.

---

## Health Engine

O **Health Engine** é o componente responsável pela decisão final sobre o estado do dispositivo.

Os demais módulos deverão somente coletar e fornecer informações.

### Fluxo

```text
Testes
   │
   ▼
Resultados padronizados
   │
   ▼
Health Engine
   │
   ├── Avaliação das regras
   ├── Classificação de severidade
   ├── Identificação de falhas críticas
   └── Justificativa técnica
   │
   ▼
Resultado final
```

As regras de aprovação e reprovação deverão existir exclusivamente no Health Engine.

---

## Falhas Críticas

Quando ocorrer uma condição definida como crítica pelo Health Engine, o teste ou fluxo correspondente deverá ser interrompido imediatamente, quando tecnicamente seguro.

A aplicação não deverá mascarar falhas críticas para produzir um resultado aparentemente positivo.

---

## Tratamento de Falhas

O projeto deverá tratar explicitamente falhas relacionadas a:

* Dependências.
* Permissões.
* Dispositivos.
* Ferramentas.
* Comandos.
* Timeout.
* Comunicação com dispositivos.
* Testes interrompidos.
* Dados inválidos.
* Dados incompletos.
* Falhas inesperadas.

Nenhum erro deverá ser ocultado.

Em caso de falha inesperada, a aplicação deverá:

1. Registrar o erro.
2. Identificar a etapa afetada.
3. Preservar informações relevantes.
4. Informar o usuário.
5. Encerrar ou continuar somente quando tecnicamente seguro.

---

## Logs

A aplicação deverá produzir registros técnicos e simplificados.

### Log técnico

Deverá registrar, quando aplicável:

* Comandos executados.
* Saídas dos comandos.
* SMART.
* NVMe.
* Tempos.
* Resultados.
* Erros.
* Decisões do Health Engine.
* Justificativas.
* Informações relevantes do dispositivo.

### Log simplificado

Deverá apresentar:

* Dispositivo.
* Etapa.
* Progresso.
* Tempo.
* Resultado.

---

## Relatórios

Ao final da execução deverá ser produzido um relatório contendo:

* Identificação completa do dispositivo.
* Ferramentas utilizadas.
* Testes executados.
* Resultados individuais.
* Falhas encontradas.
* Conclusão técnica.
* Resultado final.
* Justificativas técnicas quando houver reprovação.

O resultado final deverá ser apresentado explicitamente como:

```text
APROVADO PARA USO
```

ou:

```text
REPROVADO PARA USO
```

---

## Padrões de Desenvolvimento

Todos os scripts Bash deverão:

* utilizar shebang;
* possuir identificação do módulo;
* possuir breve descrição;
* informar o autor;
* informar a versão;
* informar a licença quando definida;
* utilizar funções com responsabilidade única;
* utilizar nomenclatura consistente;
* utilizar variáveis locais dentro das funções;
* utilizar `readonly` para constantes;
* evitar duplicação;
* utilizar `printf` quando apropriado;
* utilizar recursos próprios do Bash de maneira consistente;
* possuir tratamento de erros;
* ser compatíveis com ShellCheck.

### Cabeçalho dos scripts

O padrão será:

```bash
#!/usr/bin/env bash
#
# -----------------------------------------------------------------------------
# Projeto    : Links DiskCheck
# Módulo     : <nome-do-módulo>.sh
# Descrição  : <descrição breve>
# Autor      : Deivide Guilherme
# Versão     : 0.1.0
# Licença    : A definir
# -----------------------------------------------------------------------------
```

### Separação de seções

```bash
# =============================================================================
# Nome da seção
# =============================================================================
```

### Comentários de funções

```bash
# -----------------------------------------------------------------------------
# Descrição objetiva da função
# -----------------------------------------------------------------------------
```

Comentários adicionais deverão ser utilizados somente quando realmente agregarem informação.

---

## Versionamento

O projeto utiliza Git para controle de versão.

Alterações relevantes deverão ser versionadas em marcos funcionais.

Um commit deverá representar preferencialmente:

* funcionalidade concluída;
* etapa validada;
* mudança arquitetural relevante;
* correção significativa;
* documentação concluída.

Não deverão ser priorizados commits contendo estados incompletos ou não validados.

Antes de cada marco de versionamento deverão ser realizados os testes e as validações correspondentes.

---

## Desenvolvimento Incremental

O desenvolvimento seguirá o seguinte processo:

```text
Definição
   │
   ▼
Implementação
   │
   ▼
Validação
   │
   ▼
Correção, se necessário
   │
   ▼
Documentação
   │
   ▼
Marco estável
   │
   ▼
Git commit
```

Alterações destrutivas ou de grande impacto não deverão ser agrupadas sem necessidade.

---

## Requisitos

### Sistema Operacional

Plataforma principal:

```text
Ubuntu Desktop 26.04 LTS
```

### Linguagem

```text
Bash
```

A utilização de outra linguagem somente deverá ocorrer mediante justificativa técnica e autorização.

### Ferramentas

As ferramentas necessárias deverão ser validadas antes da execução dos testes correspondentes.

---

## Estado Atual

O projeto encontra-se na fase inicial de construção da infraestrutura.

### Arquitetura

* [x] Definição da arquitetura inicial.
* [x] Definição da estrutura de diretórios.
* [x] Definição do ponto único de entrada.
* [x] Definição do conceito do bootstrap.
* [x] Definição do carregamento através de `load_module()`.
* [x] Definição das listas ordenadas de módulos.
* [x] Definição das convenções iniciais de código.
* [x] Definição da estratégia de documentação.

### Implementação

* [x] Estrutura física inicial criada.
* [x] `main.sh` implementado.
* [ ] `bootstrap.sh` definitivo validado.
* [ ] Configuração centralizada.
* [ ] Inventário definitivo de módulos.
* [ ] Sistema de logs.
* [ ] Sistema de validação.
* [ ] Sistema de utilidades.

### Diagnóstico

* [ ] Detecção de dispositivos.
* [ ] Detecção de interfaces.
* [ ] Identificação de fabricantes.
* [ ] Parsers.
* [ ] SMART.
* [ ] NVMe.
* [ ] Testes de desempenho.
* [ ] Badblocks.
* [ ] Health Engine.
* [ ] Relatórios.
* [ ] Interface completa.

---

## Roadmap

### Fase 1 — Infraestrutura

* [x] Arquitetura inicial.
* [x] Estrutura de diretórios.
* [x] Definição do ponto de entrada.
* [x] Definição do bootstrap.
* [ ] Documentação base.
* [ ] Configuração centralizada.
* [ ] Inventário de módulos.
* [ ] Bootstrap definitivo.
* [ ] Sistema de logs.
* [ ] Sistema de validação.
* [ ] Sistema de utilidades.
* [ ] Sistema de encerramento.

### Fase 2 — Descoberta de Hardware

* [ ] Detecção de discos físicos.
* [ ] Exclusão de partições.
* [ ] Detecção de interfaces.
* [ ] Identificação de fabricante.
* [ ] Identificação de modelo.
* [ ] Identificação de firmware.
* [ ] Identificação de capacidade.
* [ ] Identificação de número de série.
* [ ] Identificação das características do dispositivo.

### Fase 3 — Parsers

* [ ] Kingston.
* [ ] Samsung.
* [ ] Crucial.
* [ ] Patriot.
* [ ] Western Digital.
* [ ] SanDisk.
* [ ] Seagate.
* [ ] Dell.
* [ ] Genérico.

### Fase 4 — Diagnóstico

* [ ] SMART.
* [ ] NVMe.
* [ ] Self-Test.
* [ ] Temperatura.
* [ ] Indicadores de desgaste.
* [ ] Testes de leitura.
* [ ] Testes de desempenho.
* [ ] Badblocks.
* [ ] Testes de escrita controlados.

### Fase 5 — Health Engine

* [ ] Modelo de resultados.
* [ ] Severidades.
* [ ] Regras.
* [ ] Falhas críticas.
* [ ] Avaliação final.
* [ ] Justificativas técnicas.
* [ ] Resultado APROVADO/REPROVADO.

### Fase 6 — Interface

* [ ] Menu principal.
* [ ] Seleção de dispositivo.
* [ ] Configuração de testes.
* [ ] Feedback de execução.
* [ ] Progresso.
* [ ] Resumo final.

### Fase 7 — Relatórios

* [ ] Relatório técnico.
* [ ] Relatório simplificado.
* [ ] Identificação completa.
* [ ] Resultados.
* [ ] Justificativas.
* [ ] Resultado final.

### Fase 8 — Validação Final

* [ ] Testes unitários.
* [ ] Testes de integração.
* [ ] Testes com HDD.
* [ ] Testes com SSD SATA.
* [ ] Testes com NVMe.
* [ ] Testes de falhas.
* [ ] Testes de timeout.
* [ ] Testes de permissões.
* [ ] Testes de dependências.
* [ ] Validação ShellCheck.
* [ ] Revisão da documentação.

---

## Documentação

A documentação técnica será mantida em `docs/`.

### Arquitetura

```text
docs/architecture/
```

Documentos:

* `architecture.md`
* `architecture-decisions.md`

### Desenvolvimento

```text
docs/development/
```

Documentos:

* `coding-style.md`
* `development-standards.md`
* `git-workflow.md`

### Roadmap

```text
docs/roadmap.md
```

O README funciona como porta de entrada para a documentação, enquanto os documentos internos deverão conter os detalhes técnicos correspondentes.

---

## Licença

A licença do projeto ainda não foi definida.

Até que uma licença seja formalmente escolhida, os arquivos deverão utilizar:

```text
Licença: A definir
```

---

## Contribuição

O modelo formal de contribuição será definido posteriormente, juntamente com:

* política de branches;
* padrão de commits;
* revisão de código;
* pull requests;
* testes obrigatórios;
* critérios de aceitação.

---

## Aviso

O Links DiskCheck está em desenvolvimento.

Os resultados produzidos pela aplicação deverão ser interpretados de acordo com os dados efetivamente coletados e com as limitações técnicas de cada dispositivo, interface, firmware, ferramenta e método de teste.

Nenhum teste individual deverá ser utilizado isoladamente quando o diagnóstico exigir correlação entre múltiplas fontes de informação.

---

## Histórico do Documento

| Versão | Data       | Alteração                 |
| ------ | ---------- | ------------------------- |
| 0.1.0  | 2026-08-09 | Criação inicial do README |

---

**Links DiskCheck — diagnóstico de armazenamento com foco em confiabilidade, rastreabilidade e decisão técnica.**

