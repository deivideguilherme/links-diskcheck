# Links DiskCheck — Padrões de Desenvolvimento

> **Documento:** Padrões de Desenvolvimento
> **Versão:** 0.1.0
> **Data:** 2026-08-09
> **Status:** Em desenvolvimento
> **Plataforma-alvo:** Ubuntu Desktop 26.04 LTS
> **Linguagem principal:** Bash
> **Autor:** Deivide Guilherme

Este documento define os padrões utilizados durante o desenvolvimento do Links DiskCheck.

Seu objetivo é manter consistência, legibilidade, previsibilidade e facilidade de manutenção entre os módulos do projeto.

---

# 1. Princípios

O desenvolvimento deverá priorizar:

* legibilidade;
* simplicidade;
* previsibilidade;
* segurança;
* modularidade;
* responsabilidade única;
* tratamento explícito de erros;
* baixo acoplamento;
* reutilização controlada;
* compatibilidade com ShellCheck.

O código não deverá ser otimizado prematuramente.

A clareza da implementação deverá ser priorizada antes de micro-otimizações de desempenho.

---

# 2. Linguagem

A linguagem principal do projeto será:

```text
Bash
```

Os scripts deverão utilizar:

```bash
#!/usr/bin/env bash
```

O projeto deverá utilizar recursos compatíveis com a versão de Bash suportada pelo ambiente-alvo.

Quando uma funcionalidade depender de comportamento específico de uma versão, isso deverá ser validado antes da implementação.

---

# 3. Estrutura dos Scripts

Cada script deverá possuir uma estrutura previsível.

Modelo conceitual:

```text
Cabeçalho
    │
    ▼
Configurações locais
    │
    ▼
Constantes
    │
    ▼
Funções auxiliares
    │
    ▼
Funções públicas
    │
    ▼
Fluxo principal, quando aplicável
```

Nem todo módulo precisará possuir todas essas seções.

A estrutura deverá refletir a responsabilidade real do módulo.

---

# 4. Cabeçalho

Todos os scripts deverão iniciar com um cabeçalho padronizado.

Modelo:

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

O campo `Licença` deverá permanecer como `A definir` até que uma licença oficial seja escolhida.

---

# 5. Separação de Seções

Grandes seções deverão utilizar:

```bash
# =============================================================================
# Nome da seção
# =============================================================================
```

Exemplo:

```bash
# =============================================================================
# Configurações
# =============================================================================
```

Esse padrão deverá ser utilizado para facilitar a navegação visual.

---

# 6. Comentários de Funções

Comentários de funções deverão ser objetivos.

Padrão:

```bash
# -----------------------------------------------------------------------------
# Descrição objetiva da função
# -----------------------------------------------------------------------------
```

Exemplo:

```bash
# -----------------------------------------------------------------------------
# Carrega um módulo do projeto
# -----------------------------------------------------------------------------
load_module() {
    ...
}
```

Não será necessário documentar toda função com informações extensas.

Comentários adicionais deverão ser utilizados somente quando o comportamento não for evidente pelo próprio código.

---

# 7. Nomenclatura de Funções

Funções deverão utilizar:

```text
snake_case
```

Exemplos:

```bash
load_module()
detect_disks()
validate_device()
generate_report()
```

Evitar:

```bash
loadModule()
LoadModule()
LOAD_MODULE()
```

A nomenclatura deverá permanecer consistente em todo o projeto.

---

# 8. Nomenclatura de Variáveis

Variáveis locais deverão utilizar `snake_case`.

Exemplo:

```bash
local device_path
local device_model
local test_result
```

Constantes deverão utilizar letras maiúsculas quando apropriado:

```bash
readonly APP_NAME="Links DiskCheck"
readonly APP_VERSION="0.1.0"
```

---

# 9. Variáveis Locais

Funções deverão utilizar `local` para variáveis que não precisam ser globais.

Exemplo:

```bash
example_function() {
    local device_path="$1"
    local result
}
```

Isso reduz efeitos colaterais entre módulos.

---

# 10. Variáveis Globais

Variáveis globais deverão ser evitadas.

Quando uma variável precisar ser compartilhada entre módulos, sua existência e finalidade deverão ser claramente definidas.

Preferencialmente:

* configurações → `config/`;
* constantes → módulo responsável ou configuração;
* resultados → estruturas de retorno;
* estado global → somente quando tecnicamente necessário.

---

# 11. Constantes

Valores que não deverão ser alterados durante a execução poderão utilizar:

```bash
readonly
```

Exemplo:

```bash
readonly APP_NAME="Links DiskCheck"
readonly APP_VERSION="0.1.0"
```

Isso reduz alterações acidentais.

---

# 12. Quoting

Variáveis deverão ser colocadas entre aspas quando houver possibilidade de expansão indesejada.

Preferir:

```bash
printf '%s\n' "$device_path"
```

em vez de:

```bash
printf '%s\n' $device_path
```

Caminhos de arquivos e dispositivos deverão receber atenção especial.

---

# 13. `printf` em vez de `echo`

Para saída controlada, preferir:

```bash
printf '%s\n' "$message"
```

em vez de depender de comportamentos específicos de:

```bash
echo
```

Isso proporciona comportamento mais previsível.

---

# 14. Códigos de Retorno

Funções deverão utilizar códigos de retorno para indicar sucesso ou falha quando apropriado.

Padrão:

```text
0 → sucesso
não-zero → falha
```

O código específico poderá ser definido conforme a necessidade do módulo.

Erros importantes não deverão ser transformados silenciosamente em sucesso.

---

# 15. Tratamento de Erros

Erros deverão ser tratados explicitamente.

O código deverá evitar:

```bash
command
```

quando o resultado do comando for crítico e não houver tratamento posterior.

Quando apropriado:

```bash
if ! command; then
    ...
fi
```

ou:

```bash
if command; then
    ...
else
    ...
fi
```

O tratamento deverá considerar:

* código de retorno;
* saída do comando;
* contexto;
* possibilidade de recuperação;
* impacto sobre o diagnóstico.

---

# 16. Comandos Externos

Comandos externos deverão ser executados de forma controlada.

Antes da utilização de uma ferramenta crítica, deverá ser validada sua disponibilidade quando necessário.

Exemplo conceitual:

```text
ferramenta existe?
       │
   ┌───┴───┐
   │       │
  sim     não
   │       │
   ▼       ▼
executa   erro
```

Ferramentas utilizadas pelo projeto incluem:

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

---

# 17. Caminhos de Arquivos

O projeto deverá trabalhar preferencialmente com caminhos absolutos quando executar operações sobre arquivos críticos.

A raiz do projeto deverá ser determinada durante a inicialização.

Não deverá ser assumido que o usuário executará o programa a partir do diretório do projeto.

---

# 18. Dispositivos de Armazenamento

Dispositivos deverão ser tratados com extremo cuidado.

Exemplos:

```text
/dev/sda
/dev/sdb
/dev/nvme0n1
```

Não deverão ser utilizados caminhos de dispositivos construídos de maneira insegura.

Antes de operações críticas deverá existir validação do dispositivo.

---

# 19. Testes Destrutivos

Operações que possam modificar dados deverão ser claramente identificadas.

Antes de qualquer teste potencialmente destrutivo deverão ser considerados:

* dispositivo correto;
* compatibilidade;
* estado do dispositivo;
* confirmação;
* permissões;
* impacto;
* possibilidade de recuperação;
* registro em log.

Nenhum teste de escrita deverá ser implementado sem uma análise específica anterior.

---

# 20. Funções

Cada função deverá possuir uma responsabilidade clara.

Evitar funções que façam simultaneamente:

```text
detecção
+
execução de teste
+
logging
+
interface
+
decisão
```

Preferir:

```text
detecção → função específica
teste → função específica
logging → módulo de logging
decisão → Health Engine
interface → UI
```

---

# 21. Tamanho das Funções

Não será estabelecido um limite rígido de linhas.

Entretanto, funções excessivamente grandes deverão ser analisadas.

Quando uma função começar a possuir múltiplas responsabilidades, deverá ser considerada sua divisão.

A divisão deverá ocorrer por responsabilidade, e não simplesmente por quantidade de linhas.

---

# 22. Dependências entre Módulos

Os módulos deverão evitar carregar diretamente outros módulos sem necessidade.

O carregamento deverá ser coordenado pela infraestrutura definida para o projeto.

Dependências deverão ser claras e previsíveis.

Dependências circulares são proibidas.

---

# 23. `source`

Arquivos externos deverão ser carregados utilizando caminhos determinados de maneira segura.

Não deverá ser assumido que o diretório atual corresponde à raiz do projeto.

A infraestrutura do projeto deverá fornecer os caminhos necessários.

---

# 24. ShellCheck

Os scripts deverão ser compatíveis com ShellCheck.

A validação deverá ser realizada durante as etapas apropriadas do desenvolvimento.

Exemplo de validação:

```bash
shellcheck ./main.sh
```

Para conjuntos maiores de arquivos, a estratégia de validação será definida posteriormente.

Avisos não deverão ser simplesmente ignorados.

Quando um aviso não puder ou não precisar ser eliminado, a razão deverá ser compreendida e documentada quando necessário.

---

# 25. Formatação

O código deverá utilizar indentação consistente.

Padrão:

```text
4 espaços
```

Exemplo:

```bash
if condition; then
    command
fi
```

Não utilizar tabs para indentação do código.

---

# 26. Espaçamento

Deverá existir espaçamento suficiente para separar blocos lógicos.

Exemplo:

```bash
local device_path="$1"
local result

if ! validate_device "$device_path"; then
    return 1
fi

result="$(collect_data "$device_path")"
```

Evitar código excessivamente comprimido.

---

# 27. Retorno de Dados

Os módulos deverão retornar dados de maneira previsível.

Quando possível, deverá existir uma estrutura padronizada para resultados.

O formato definitivo será definido durante a implementação do mecanismo de coleta e do Health Engine.

Não criar estruturas diferentes para cada teste sem justificativa.

---

# 28. Logs

Os módulos deverão utilizar o sistema centralizado de logging quando ele estiver disponível.

Não criar mecanismos independentes de logging em cada módulo.

Isso evita formatos diferentes e facilita auditoria.

---

# 29. Interface

Módulos de backend não deverão exibir diretamente mensagens de interface sempre que isso puder ser evitado.

Preferir:

```text
módulo
   │
   ▼
resultado
   │
   ▼
UI
```

em vez de misturar:

```text
teste
+
printf para usuário
+
dialog
+
regra de aprovação
```

---

# 30. Health Engine

Nenhum módulo fora do Health Engine deverá implementar regras de aprovação ou reprovação.

É permitido que um módulo identifique:

```text
erro de execução
```

mas isso é diferente de decidir:

```text
REPROVADO PARA USO
```

A classificação final pertence ao Health Engine.

---

# 31. Comentários no Código

Comentários deverão explicar principalmente:

* intenção;
* comportamento não óbvio;
* motivo de uma decisão técnica específica;
* limitações relevantes.

Evitar comentários que simplesmente repitam o código.

Exemplo pouco útil:

```bash
# Incrementa contador
counter=$((counter + 1))
```

Exemplo útil:

```bash
# Mantém o contador separado do índice do dispositivo para preservar
# a correspondência com a lista apresentada na interface.
counter=$((counter + 1))
```

---

# 32. Segurança

O código deverá considerar:

* expansão de variáveis;
* caminhos com espaços;
* caracteres especiais;
* permissões;
* comandos externos;
* dispositivos incorretos;
* arquivos temporários;
* sinais;
* interrupções;
* privilégios administrativos.

Nenhum comando deverá ser executado com privilégios elevados sem necessidade.

---

# 33. Privilégios

A aplicação deverá solicitar privilégios administrativos somente quando necessário.

Não executar toda a aplicação como `root` por padrão.

A necessidade de privilégios deverá ser definida individualmente por operação.

---

# 34. Arquivos Temporários

Arquivos temporários deverão ser armazenados em:

```text
temp/
```

quando fizerem parte do fluxo controlado da aplicação.

Arquivos temporários deverão possuir nomes previsíveis apenas quando isso não representar risco de colisão ou segurança.

Quando apropriado, mecanismos seguros de criação de arquivos temporários deverão ser utilizados.

---

# 35. Limpeza

A aplicação deverá possuir mecanismo controlado para limpeza de recursos temporários.

A limpeza não deverá remover informações necessárias para investigação de falhas.

Em caso de erro, arquivos relevantes poderão ser preservados.

---

# 36. Sinais e Interrupções

Interrupções como:

```text
SIGINT
SIGTERM
```

deverão ser consideradas durante a implementação do fluxo principal.

A aplicação deverá buscar encerramento seguro quando uma interrupção ocorrer durante testes.

Operações críticas deverão ser avaliadas individualmente quanto à possibilidade de interrupção.

---

# 37. Timeouts

Testes externos deverão possuir timeout quando houver risco de permanecerem indefinidamente bloqueados.

O valor do timeout deverá ser definido de acordo com:

* tipo do teste;
* dispositivo;
* duração esperada;
* impacto.

Timeouts não deverão ser definidos arbitrariamente.

---

# 38. Compatibilidade

Antes da implementação de funcionalidades dependentes de ferramentas externas, deverão ser verificadas:

* versão;
* sintaxe;
* opções disponíveis;
* comportamento;
* limitações.

Documentação oficial deverá ser consultada quando a funcionalidade depender de versão específica.

---

# 39. Alterações Arquiteturais

Uma alteração que modifique:

* estrutura de diretórios;
* responsabilidades;
* dependências;
* fluxo de inicialização;
* Health Engine;
* formato de resultados;

deverá ser discutida antes da implementação.

Quando aprovada, deverá ser registrada em:

```text
docs/architecture/architecture-decisions.md
```

---

# 40. Processo de Implementação

Cada nova funcionalidade deverá seguir, preferencialmente:

```text
Definir
   ↓
Analisar dependências
   ↓
Implementar
   ↓
Validar
   ↓
Corrigir
   ↓
Documentar
   ↓
Versionar
```

Nenhuma etapa crítica deverá ser pulada.

---

# 41. Git

Antes de iniciar uma alteração significativa:

```bash
git status
```

deverá ser utilizado para verificar o estado do repositório.

Após uma alteração estável, deverão ser realizados:

```text
git status
git add
git commit
git push
```

conforme o fluxo definido no documento de Git.

---

# 42. Regra de Ouro

Antes de implementar uma funcionalidade, deverá ser possível responder:

1. Qual módulo é responsável?
2. Quais são suas entradas?
3. Quais são suas saídas?
4. De quais módulos depende?
5. Como os erros serão tratados?
6. Como será validada?
7. Como será registrada?
8. Como será revertida, quando aplicável?

Se essas respostas não estiverem claras, a implementação deverá ser analisada antes de começar.

---

# 43. Estado do Documento

Este documento representa os padrões de desenvolvimento definidos até o momento.

Novas regras poderão ser adicionadas conforme necessidades reais do projeto forem identificadas.

Alterações relevantes deverão ser discutidas antes de serem incorporadas.

---

# Histórico

| Versão | Data       | Alteração                                      |
| ------ | ---------- | ---------------------------------------------- |
| 0.1.0  | 2026-08-09 | Criação inicial dos padrões de desenvolvimento |

