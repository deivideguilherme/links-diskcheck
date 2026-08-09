# Links DiskCheck — Decisões Arquitetônicas

> **Documento:** Decisões Arquitetônicas
> **Versão:** 0.1.0
> **Data:** 2026-08-09
> **Status:** Em desenvolvimento
> **Plataforma-alvo:** Ubuntu Desktop 26.04 LTS
> **Linguagem principal:** Bash
> **Autor:** Deivide Guilherme

Este documento registra decisões arquitetônicas relevantes tomadas durante o desenvolvimento do Links DiskCheck.

Seu objetivo é preservar o contexto técnico das decisões e evitar que escolhas já analisadas sejam repetidas ou alteradas sem justificativa.

Decisões futuras deverão ser adicionadas ao final deste documento.

---

# ADR-001 — Linguagem principal

## Status

**Aprovada**

## Decisão

O Links DiskCheck será desenvolvido prioritariamente em **Bash**.

## Justificativa

Bash possui integração direta com as principais ferramentas Linux utilizadas pelo projeto, incluindo:

* `smartctl`;
* `nvme-cli`;
* `fio`;
* `badblocks`;
* `hdparm`;
* `lsblk`;
* `blkid`;
* `udevadm`;
* `iostat`;
* `journalctl`.

A utilização de Bash também reduz dependências adicionais e mantém a aplicação próxima da camada operacional do sistema.

## Consequência

A arquitetura deverá priorizar:

* modularidade;
* funções pequenas;
* validação rigorosa;
* tratamento explícito de erros;
* compatibilidade com ShellCheck.

Outra linguagem somente deverá ser considerada quando existir justificativa técnica significativa e mediante autorização.

---

# ADR-002 — Ponto único de entrada

## Status

**Aprovada**

## Decisão

Somente `main.sh` deverá ser executado diretamente pelo usuário.

## Justificativa

Um único ponto de entrada:

* simplifica a inicialização;
* reduz possibilidades de execução incorreta;
* centraliza validações;
* facilita manutenção;
* torna o fluxo previsível.

## Consequência

Os demais módulos deverão ser carregados pela infraestrutura da aplicação.

---

# ADR-003 — Uso de `bootstrap.sh`

## Status

**Aprovada**

## Decisão

A preparação e inicialização dos componentes será centralizada em:

```text
bootstrap.sh
```

## Justificativa

Separar o ponto de entrada da preparação da aplicação evita sobrecarregar o `main.sh`.

O `main.sh` deverá permanecer pequeno e responsável pelo início do fluxo.

O `bootstrap.sh` será responsável pela preparação do ambiente e carregamento dos módulos.

---

# ADR-004 — Carregamento através de `load_module()`

## Status

**Aprovada**

## Decisão

O carregamento dos módulos deverá ser realizado através de uma função centralizada:

```text
load_module()
```

## Justificativa

Evita chamadas `source` espalhadas pelo projeto e permite centralizar:

* validação de existência;
* validação de carregamento;
* tratamento de erros;
* registro de módulos carregados;
* comportamento padronizado.

## Consequência

Os módulos não deverão carregar arbitrariamente outros módulos.

---

# ADR-005 — Separação por responsabilidade

## Status

**Aprovada**

## Decisão

O projeto será dividido em módulos com responsabilidades específicas.

## Justificativa

Um projeto Bash de diagnóstico pode rapidamente se tornar difícil de manter quando toda a lógica fica concentrada em poucos scripts.

A separação permite:

* manutenção isolada;
* testes específicos;
* menor acoplamento;
* maior legibilidade;
* expansão gradual.

## Consequência

Cada módulo deverá possuir responsabilidade clara e evitar lógica pertencente a outras camadas.

---

# ADR-006 — Separação entre coleta e decisão

## Status

**Aprovada**

## Decisão

Os módulos de diagnóstico deverão coletar dados, enquanto o **Health Engine** será responsável pela decisão final.

## Justificativa

Evitar que cada teste possua suas próprias regras de aprovação ou reprovação.

Sem essa separação, seria possível encontrar regras diferentes em:

```text
smart.sh
nvme.sh
badblocks.sh
fio.sh
```

Isso aumentaria o risco de inconsistências.

## Consequência

Os módulos de teste deverão retornar resultados estruturados e informações de erro.

As regras de decisão deverão existir exclusivamente no Health Engine.

---

# ADR-007 — Health Engine centralizado

## Status

**Aprovada**

## Decisão

O Health Engine será a única autoridade responsável pela classificação final do dispositivo.

## Justificativa

A avaliação de um dispositivo de armazenamento exige correlação entre diferentes fontes de informação.

Um único atributo ou teste não deverá necessariamente determinar o resultado final isoladamente.

Centralizar as regras permite:

* consistência;
* rastreabilidade;
* evolução das regras;
* auditoria;
* redução de falsos positivos;
* redução de falsos negativos.

## Consequência

Novas regras de aprovação ou reprovação deverão ser implementadas no Health Engine.

---

# ADR-008 — Parsers específicos por fabricante

## Status

**Aprovada**

## Decisão

O projeto utilizará parsers específicos para fabricantes conhecidos e um parser genérico.

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

## Justificativa

Fabricantes podem apresentar atributos, nomenclaturas e informações específicas.

Um parser dedicado permite interpretar corretamente dados específicos quando necessário.

## Consequência

A identificação não deverá depender exclusivamente do nome comercial.

Sempre que possível serão utilizadas informações como:

* Vendor;
* Model Number;
* Firmware;
* SMART;
* NVMe Identify Controller.

---

# ADR-009 — Interface separada da lógica

## Status

**Aprovada**

## Decisão

Os componentes de interface serão mantidos no diretório:

```text
ui/
```

## Justificativa

A interface não deverá conter lógica de diagnóstico ou regras de aprovação.

Isso permite alterar a interface sem modificar o mecanismo de diagnóstico.

## Consequência

Componentes como:

```text
menu.sh
dialog.sh
messages.sh
progress.sh
summary.sh
```

deverão permanecer relacionados à interação com o usuário.

---

# ADR-010 — Configuração separada da lógica

## Status

**Aprovada**

## Decisão

As configurações deverão permanecer em:

```text
config/
```

## Justificativa

Separar dados configuráveis da lógica facilita:

* manutenção;
* ajustes de parâmetros;
* leitura;
* auditoria;
* futura expansão.

## Consequência

Arquivos de configuração não deverão executar lógica de negócio.

---

# ADR-011 — Biblioteca compartilhada

## Status

**Aprovada**

## Decisão

Funções reutilizáveis deverão ser centralizadas em:

```text
lib/
```

## Justificativa

Evitar duplicação de funções em múltiplos módulos.

Exemplos incluem:

* validações;
* manipulação de strings;
* filesystem;
* timers;
* terminal;
* logging;
* execução de comandos.

## Consequência

Antes de criar uma função utilitária nova, deverá ser verificado se já existe funcionalidade equivalente em `lib/`.

---

# ADR-012 — Logs separados por finalidade

## Status

**Aprovada**

## Decisão

Os logs serão organizados em:

```text
logs/
├── runtime/
├── debug/
└── archive/
```

## Justificativa

Separar os registros facilita:

* diagnóstico;
* acompanhamento da execução;
* manutenção;
* arquivamento.

## Consequência

Cada tipo de log deverá possuir finalidade clara.

---

# ADR-013 — Documentação versionada

## Status

**Aprovada**

## Decisão

A documentação técnica será mantida dentro do próprio repositório Git.

## Justificativa

Decisões arquitetônicas e padrões de desenvolvimento não devem depender exclusivamente do histórico da conversa.

A documentação versionada:

* preserva contexto;
* facilita manutenção;
* reduz perda de conhecimento;
* permite acompanhar evolução;
* facilita futuras contribuições.

## Consequência

Alterações arquitetônicas relevantes deverão atualizar a documentação correspondente.

---

# ADR-014 — Desenvolvimento incremental

## Status

**Aprovada**

## Decisão

O projeto será desenvolvido incrementalmente.

Cada etapa deverá ser:

1. Definida.
2. Implementada.
3. Validada.
4. Documentada quando necessário.
5. Versionada quando atingir um marco estável.

## Justificativa

Reduz o risco de introduzir múltiplas alterações simultaneamente e dificulta a identificação da causa de eventuais problemas.

## Consequência

Não serão agrupadas alterações não relacionadas sem necessidade.

---

# ADR-015 — Validação antes do avanço

## Status

**Aprovada**

## Decisão

Uma etapa não deverá ser considerada concluída sem validação.

## Justificativa

A validação incremental reduz o risco de carregar erros para etapas posteriores.

## Consequência

Antes de avançar para uma nova etapa deverão ser verificados os resultados esperados da etapa atual.

---

# ADR-016 — Git como parte do processo de desenvolvimento

## Status

**Aprovada**

## Decisão

O Git será utilizado continuamente durante o desenvolvimento.

Marcos estáveis deverão ser versionados.

## Justificativa

O projeto possui evolução incremental e alterações arquitetônicas relevantes.

O versionamento permite:

* histórico;
* recuperação;
* comparação;
* auditoria;
* rollback.

## Consequência

Antes de iniciar uma alteração significativa deverá ser considerado o estado atual do repositório.

Após um marco estável, deverá ser recomendado um commit.

---

# ADR-017 — Estrutura física criada antecipadamente

## Status

**Aprovada**

## Decisão

A estrutura inicial de diretórios e arquivos do projeto poderá ser criada antecipadamente, antes da implementação de cada módulo.

## Justificativa

Isso permite visualizar desde o início a arquitetura completa e facilita a organização do desenvolvimento incremental.

## Consequência

A existência física de um arquivo não significa que sua implementação esteja concluída.

O estado funcional de cada módulo deverá ser determinado separadamente.

---

# ADR-018 — Comentários de funções objetivos

## Status

**Aprovada**

## Decisão

Comentários de funções deverão ser objetivos e descrever diretamente o que acontece naquele ponto do código.

Exemplo:

```bash
# -----------------------------------------------------------------------------
# Fluxo principal da aplicação
# -----------------------------------------------------------------------------
main() {
    ...
}
```

## Justificativa

Comentários excessivamente detalhados podem dificultar a leitura e aumentar a manutenção da documentação interna do código.

Detalhes arquitetônicos ou comportamentos complexos deverão ser documentados em locais apropriados.

## Consequência

Comentários adicionais somente deverão ser utilizados quando forem necessários para explicar comportamento não óbvio.

---

# ADR-019 — Convenção de separação visual

## Status

**Aprovada**

## Decisão

O código utilizará comentários padronizados para separar grandes seções.

Padrão:

```bash
# =============================================================================
# Nome da seção
# =============================================================================
```

Funções utilizarão:

```bash
# -----------------------------------------------------------------------------
# Descrição objetiva da função
# -----------------------------------------------------------------------------
```

## Justificativa

Melhora a navegação visual do código sem adicionar excesso de comentários.

---

# ADR-020 — Padrão de cabeçalho dos scripts

## Status

**Aprovada**

## Decisão

Todos os scripts Bash do projeto deverão possuir cabeçalho padronizado.

O padrão inicial será:

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

## Justificativa

Padroniza a identificação dos arquivos e facilita manutenção e auditoria.

## Consequência

Novos scripts deverão seguir o padrão estabelecido.

---

# ADR-021 — Compatibilidade com ShellCheck

## Status

**Aprovada**

## Decisão

O código deverá ser desenvolvido buscando compatibilidade com ShellCheck.

## Justificativa

ShellCheck permite identificar diversos problemas comuns em scripts Bash, incluindo:

* expansão incorreta;
* variáveis não definidas;
* quoting inadequado;
* construções potencialmente perigosas;
* problemas de portabilidade dentro do Bash.

## Consequência

A validação com ShellCheck fará parte das etapas apropriadas de testes e revisão.

---

# ADR-022 — Plataforma-alvo

## Status

**Aprovada**

## Decisão

A plataforma principal de desenvolvimento e execução será:

```text
Ubuntu Desktop 26.04 LTS
```

## Justificativa

Permite controlar melhor:

* versão do Bash;
* kernel;
* ferramentas;
* comportamento do sistema;
* dependências.

## Consequência

Compatibilidade com outras distribuições não será requisito inicial.

---

# ADR-023 — Operações potencialmente destrutivas

## Status

**Aprovada**

## Decisão

Testes que possam modificar dados deverão possuir tratamento especial.

Isso inclui principalmente operações de escrita.

## Justificativa

O Links DiskCheck trabalha diretamente com dispositivos de armazenamento.

Uma identificação incorreta ou execução inadequada pode resultar em perda de dados.

## Consequência

Operações potencialmente destrutivas deverão possuir:

* identificação inequívoca do dispositivo;
* validação prévia;
* confirmação quando aplicável;
* tratamento de erros;
* logs;
* possibilidade de interrupção segura quando tecnicamente possível.

---

# ADR-024 — Nenhuma decisão baseada em dados ocultos

## Status

**Aprovada**

## Decisão

O sistema não deverá ocultar erros, resultados negativos ou informações relevantes para produzir uma classificação positiva.

## Justificativa

O objetivo principal do projeto é reduzir falsos positivos e falsos negativos.

Ocultar falhas comprometeria diretamente a confiabilidade do diagnóstico.

## Consequência

Resultados incompletos, erros e limitações deverão ser registrados e considerados pelo fluxo de avaliação conforme as regras definidas no Health Engine.

---

# Histórico

| Versão | Data       | Alteração                                   |
| ------ | ---------- | ------------------------------------------- |
| 0.1.0  | 2026-08-09 | Criação inicial das decisões arquitetônicas |

