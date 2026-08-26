#!/usr/bin/env bash

# =============================================================================
# Links DiskCheck
# Módulo: config.sh
# Descrição: Define as configurações globais da aplicação.
# Autor: Deivide Guilherme
# Versão: 0.1.0
# Licença: A definir
# =============================================================================

# =============================================================================
# Configurações da aplicação
# =============================================================================

readonly APP_NAME="Links DiskCheck"
readonly APP_VERSION="0.1.0"

# =============================================================================
# Diretórios da aplicação
# =============================================================================

readonly PROJECT_ROOT="${PROJECT_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"

# shellcheck disable=SC2034
readonly LOG_DIR="${PROJECT_ROOT}/logs"

# shellcheck disable=SC2034
readonly REPORT_DIR="${PROJECT_ROOT}/reports"

# shellcheck disable=SC2034
readonly TEMP_DIR="${PROJECT_ROOT}/temp"

# =============================================================================
# Funções públicas
# =============================================================================

# -----------------------------------------------------------------------------
# Valida se as configurações básicas foram carregadas corretamente.
# -----------------------------------------------------------------------------
config_validate()
{
    [[ -n "${APP_NAME}" ]] || return 1
    [[ -n "${APP_VERSION}" ]] || return 1
    [[ -d "${PROJECT_ROOT}" ]] || return 1

    return 0
}
