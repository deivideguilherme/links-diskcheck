# Links DiskCheck — Coding Style

> **Documento:** Padrão de Estilo de Código
> **Versão:** 0.1.0
> **Data:** 2026-08-09
> **Status:** Em desenvolvimento
> **Plataforma-alvo:** Ubuntu Desktop 26.04 LTS
> **Linguagem principal:** Bash
> **Autor:** Deivide Guilherme

Este documento define o padrão visual e estrutural utilizado nos scripts Bash do Links DiskCheck.

O objetivo é manter o código consistente, legível e previsível entre todos os módulos.

As regras aqui descritas complementam `development-standards.md`.

---

# 1. Shebang

Todo script executável deverá iniciar com:

```bash
#!/usr/bin/env bash
```

Não utilizar:

```bash
#!/bin/bash
```

como padrão do projeto.

A escolha de `/usr/bin/env` permite localizar o Bash através do ambiente configurado.

---

# 2. Cabeçalho

Todo script deverá possuir identificação básica.

Padrão:

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

O cabeçalho deverá permanecer simples.

Informações arquiteturais não deverão ser colocadas no cabeçalho.

---

# 3. Seções

Grandes blocos do arquivo deverão ser separados utilizando:

```bash
# =============================================================================
# Nome da seção
# =============================================================================
```

Exemplo:

```bash
# =============================================================================
# Constantes
# =============================================================================
```

---

# 4. Subseções

Quando uma seção possuir grupos menores de funções, utilizar:

```bash
# -----------------------------------------------------------------------------
# Nome da subseção
# -----------------------------------------------------------------------------
```

Exemplo:

```bash
# -----------------------------------------------------------------------------
# Funções Públicas
# -----------------------------------------------------------------------------
```

---

# 5. Funções

Funções deverão utilizar:

```bash
nome_da_funcao() {
    ...
}
```

Preferir a forma:

```bash
main() {
    ...
}
```

em vez de:

```bash
function main {
    ...
}
```

---

# 6. Comentários de Funções

Comentários deverão ser curtos e objetivos.

Exemplo:

```bash
# -----------------------------------------------------------------------------
# Fluxo principal da aplicação
# -----------------------------------------------------------------------------
main() {
    ...
}
```

Não é necessário transformar cada função em uma documentação extensa.

A função deverá ser compreensível pelo próprio código sempre que possível.

---

# 7. Espaçamento

Utilizar uma linha em branco para separar blocos logicamente diferentes.

Exemplo:

```bash
local device_path="$1"
local result

if ! validate_device "$device_path"; then
    return 1
fi

result="$(collect_data "$device_path")"
```

Evitar:

```bash
local device_path="$1"
local result
if ! validate_device "$device_path"; then
return 1
fi
result="$(collect_data "$device_path")"
```

---

# 8. Indentação

Utilizar quatro espaços.

Exemplo:

```bash
if condition; then
    command
fi
```

Funções aninhadas ou estruturas condicionais deverão manter o mesmo padrão.

Não utilizar tabs.

---

# 9. Condicionais

Preferir:

```bash
if condition; then
    command
fi
```

Para condições complexas, dividir em variáveis ou funções auxiliares quando isso melhorar a leitura.

Evitar condições excessivamente longas.

---

# 10. `case`

Utilizar `case` quando existirem múltiplas alternativas.

Exemplo:

```bash
case "$device_type" in
    sata)
        ...
        ;;
    nvme)
        ...
        ;;
    *)
        ...
        ;;
esac
```

Evitar grandes cadeias de `if/elif` quando `case` tornar a lógica mais clara.

---

# 11. Loops

Utilizar loops de acordo com a finalidade.

Exemplo:

```bash
for device in "${devices[@]}"; do
    ...
done
```

Para leitura controlada:

```bash
while IFS= read -r line; do
    ...
done
```

A escolha deverá priorizar legibilidade e segurança.

---

# 12. Arrays

Quando existir uma coleção de valores relacionados, utilizar arrays Bash.

Exemplo:

```bash
local devices=(
    "/dev/sda"
    "/dev/sdb"
)
```

Ao expandir arrays, utilizar:

```bash
"${devices[@]}"
```

Evitar:

```bash
"${devices[*]}"
```

quando for necessário preservar cada elemento individualmente.

---

# 13. Variáveis

Variáveis deverão utilizar `snake_case`.

Exemplo:

```bash
device_path
device_model
test_result
```

Evitar:

```bash
devicePath
DevicePath
DEVICEPATH
```

exceto para constantes.

---

# 14. Constantes

Constantes poderão utilizar letras maiúsculas:

```bash
readonly APP_NAME="Links DiskCheck"
readonly APP_VERSION="0.1.0"
```

Após declaradas, não deverão ser alteradas.

---

# 15. Variáveis Locais

Dentro de funções, utilizar:

```bash
local variable_name
```

ou:

```bash
local variable_name="$1"
```

Isso reduz efeitos colaterais entre funções.

---

# 16. Aspas

Variáveis deverão ser citadas quando apropriado.

Preferir:

```bash
printf '%s\n' "$device_path"
```

em vez de:

```bash
printf '%s\n' $device_path
```

Especialmente importante para:

* caminhos;
* nomes de arquivos;
* nomes de dispositivos;
* resultados de comandos;
* argumentos recebidos do usuário.

---

# 17. Command Substitution

Preferir:

```bash
result="$(command)"
```

em vez da sintaxe antiga:

```bash
result=`command`
```

---

# 18. `printf`

Utilizar `printf` para saída textual controlada.

Exemplo:

```bash
printf '%s\n' "$message"
```

Para mensagens formatadas:

```bash
printf 'Dispositivo: %s\n' "$device_path"
```

---

# 19. Redirecionamentos

Redirecionamentos deverão ser explícitos.

Exemplo:

```bash
command > "$output_file"
```

Para capturar stderr:

```bash
command 2> "$error_file"
```

Para capturar ambos:

```bash
command > "$output_file" 2>&1
```

A ordem dos redirecionamentos deverá ser entendida antes da utilização.

---

# 20. Códigos de Retorno

Sucesso:

```bash
return 0
```

Falha:

```bash
return 1
```

Códigos específicos poderão ser utilizados quando existir necessidade real de distinguir tipos de erro.

---

# 21. Verificação de Comandos

Quando a existência de uma ferramenta for relevante:

```bash
command -v smartctl
```

O tratamento definitivo dessa verificação deverá utilizar as funções apropriadas do projeto quando o módulo de validação estiver implementado.

---

# 22. Comparações

Para comparações numéricas, utilizar operadores apropriados:

```bash
if (( value > 0 )); then
    ...
fi
```

Para strings:

```bash
if [[ "$value" == "expected" ]]; then
    ...
fi
```

Preferir `[[ ]]` em Bash quando apropriado.

---

# 23. Testes de Arquivos

Utilizar os operadores apropriados.

Exemplo:

```bash
if [[ -f "$file_path" ]]; then
    ...
fi
```

Diretório:

```bash
if [[ -d "$directory_path" ]]; then
    ...
fi
```

Executável:

```bash
if [[ -x "$script_path" ]]; then
    ...
fi
```

---

# 24. `readonly`

Valores que não deverão mudar deverão ser protegidos:

```bash
readonly APP_NAME="Links DiskCheck"
```

Evitar alterar constantes posteriormente.

---

# 25. `local`

Variáveis internas de funções deverão utilizar `local`.

Exemplo:

```bash
get_device_model() {
    local device_path="$1"
    local device_model

    ...
}
```

---

# 26. Funções Públicas e Privadas

Quando necessário, o código poderá separar visualmente funções públicas e auxiliares.

Exemplo:

```bash
# =============================================================================
# Funções Privadas
# =============================================================================

# -----------------------------------------------------------------------------
# Valida um dispositivo
# -----------------------------------------------------------------------------
_validate_device() {
    ...
}

# =============================================================================
# Funções Públicas
# =============================================================================

# -----------------------------------------------------------------------------
# Detecta dispositivos disponíveis
# -----------------------------------------------------------------------------
detect_disks() {
    ...
}
```

O prefixo `_` poderá ser utilizado para funções internas quando isso deixar clara sua finalidade.

---

# 27. Função `main`

Quando um módulo possuir fluxo executável próprio, utilizar uma função `main()`.

Exemplo:

```bash
# =============================================================================
# Funções Públicas
# =============================================================================

# -----------------------------------------------------------------------------
# Fluxo principal da aplicação
# -----------------------------------------------------------------------------
main() {
    ...
}
```

Entretanto, módulos que forem exclusivamente bibliotecas não deverão possuir `main()` desnecessariamente.

---

# 28. Execução Condicional

Somente o ponto de entrada principal deverá controlar a execução automática da aplicação.

Módulos carregados por `source` não deverão executar testes ou fluxos inesperadamente durante o carregamento.

Isso é especialmente importante para:

```text
lib/
core/
detect/
engine/
parsers/
tests/
ui/
```

---

# 29. `source`

O carregamento de módulos deverá utilizar caminhos seguros e controlados pela infraestrutura do projeto.

Não assumir que:

```text
PWD = raiz do projeto
```

---

# 30. Mensagens

Mensagens destinadas ao usuário deverão utilizar a camada de interface apropriada.

Mensagens técnicas deverão utilizar o sistema de logging.

Evitar misturar:

```text
interface
+
logging
+
diagnóstico
```

na mesma função sem necessidade.

---

# 31. Logging

Quando o sistema de logging estiver implementado, módulos não deverão criar seus próprios arquivos de log arbitrariamente.

Utilizar a interface centralizada de logging.

---

# 32. Nomes de Arquivos

Scripts deverão utilizar nomes em:

```text
snake_case
```

Exemplos:

```text
smart.sh
nvme.sh
health.sh
manufacturer.sh
development_standards.md
```

Evitar espaços e caracteres especiais.

---

# 33. Nomes de Diretórios

Diretórios deverão utilizar nomes simples e descritivos.

Preferir:

```text
tests/
reports/
parsers/
```

Evitar:

```text
Testes de Disco/
Relatórios/
```

---

# 34. Comandos Longos

Comandos longos deverão ser quebrados para melhorar a leitura.

Exemplo:

```bash
some_command \
    --option-one "$value_one" \
    --option-two "$value_two" \
    --option-three "$value_three"
```

Não quebrar comandos de maneira que altere seu comportamento.

---

# 35. Strings Longas

Strings extensas poderão ser divididas quando isso melhorar a manutenção.

Evitar linhas excessivamente longas.

---

# 36. Código Morto

Não manter funções ou variáveis sem utilização somente porque poderão ser úteis no futuro.

Código experimental deverá ser removido ou isolado adequadamente.

---

# 37. Duplicação

Antes de criar uma função, verificar se existe função equivalente em:

```text
lib/
```

ou em outro módulo apropriado.

Não duplicar lógica sem justificativa.

---

# 38. Complexidade

Código mais curto não é necessariamente melhor.

A prioridade será:

```text
clareza
    ↓
correção
    ↓
segurança
    ↓
manutenção
    ↓
desempenho
```

Otimizações deverão ser justificadas por necessidade real.

---

# 39. Segurança

O estilo de código deverá considerar segurança como parte da implementação.

Atenção especial a:

* expansão de variáveis;
* entrada do usuário;
* caminhos;
* comandos externos;
* privilégios;
* arquivos temporários;
* dispositivos;
* testes de escrita.

---

# 40. ShellCheck

O código deverá ser revisado com ShellCheck.

Exemplo:

```bash
shellcheck ./main.sh
```

Os avisos deverão ser analisados individualmente.

Não utilizar supressões indiscriminadamente.

---

# 41. Exemplos de Código

Os exemplos presentes neste documento são ilustrativos.

Eles não representam necessariamente a implementação definitiva dos módulos.

A implementação real deverá seguir a arquitetura e os padrões definidos no projeto.

---

# 42. Regra de Consistência

Quando houver dúvida entre duas formas equivalentes de escrever determinado trecho, deverá ser escolhida a forma:

1. mais clara;
2. mais segura;
3. mais consistente com o projeto;
4. mais fácil de validar;
5. mais fácil de manter.

---

# 43. Estado do Documento

Este documento representa o padrão de estilo definido até o momento.

Novas regras poderão ser adicionadas conforme problemas reais forem identificados durante a implementação.

As regras não deverão ser adicionadas apenas por preferência estética sem benefício técnico ou de manutenção.

---

# Histórico

| Versão | Data       | Alteração                           |
| ------ | ---------- | ----------------------------------- |
| 0.1.0  | 2026-08-09 | Criação inicial do padrão de estilo |

