#!/usr/bin/env bash

# =============================================================================
# Links DiskCheck
# Módulo: utils.sh
# Descrição: Funções utilitárias genéricas da aplicação.
# Autor: Deivide Guilherme
# Versão: 0.1.0
# Licença: A definir
# =============================================================================

# =============================================================================
# Verificações
# =============================================================================

# -----------------------------------------------------------------------------
# Verifica se um comando está disponível no sistema.
#
# Retorno:
#   0 - comando disponível
#   1 - comando indisponível ou argumento ausente
# -----------------------------------------------------------------------------
is_command_available()
{
    local command_name="${1:-}"

    [[ -n "${command_name}" ]] || return 1
    command -v "${command_name}" >/dev/null 2>&1
}

# -----------------------------------------------------------------------------
# Verifica se um arquivo existe e pode ser lido.
#
# Retorno:
#   0 - arquivo válido e legível
#   1 - arquivo inexistente, ilegível ou argumento ausente
# -----------------------------------------------------------------------------
is_file_readable()
{
    local file_path="${1:-}"

    [[ -n "${file_path}" ]] || return 1
    [[ -f "${file_path}" && -r "${file_path}" ]]
}

# -----------------------------------------------------------------------------
# Verifica se um diretório existe e pode ser acessado.
#
# Retorno:
#   0 - diretório válido e acessível
#   1 - diretório inexistente, inacessível ou argumento ausente
# -----------------------------------------------------------------------------
is_directory()
{
    local directory_path="${1:-}"

    [[ -n "${directory_path}" ]] || return 1
    [[ -d "${directory_path}" && -x "${directory_path}" ]]
}
