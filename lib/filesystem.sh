#!/usr/bin/env bash

# =============================================================================
# Links DiskCheck
# Módulo: filesystem.sh
# Descrição: Operações genéricas relacionadas ao sistema de arquivos.
# Autor: Deivide Guilherme
# Versão: 1.0.0
# Licença: A definir
# =============================================================================

# -----------------------------------------------------------------------------
# Cria um diretório caso ele ainda não exista.
# -----------------------------------------------------------------------------
create_directory()
{
    [[ "$#" -eq 1 ]] || return 1
    [[ -d "$1" ]] || mkdir -p -- "$1"
}

# -----------------------------------------------------------------------------
# Obtém o tamanho de um arquivo em bytes.
# -----------------------------------------------------------------------------
get_file_size()
{
    [[ "$#" -eq 1 ]] || return 1
    [[ -f "$1" ]] || return 1

    stat --format='%s' -- "$1"
}

# -----------------------------------------------------------------------------
# Obtém o tamanho de um diretório em bytes.
# -----------------------------------------------------------------------------
get_directory_size()
{
    [[ "$#" -eq 1 ]] || return 1
    [[ -d "$1" ]] || return 1

    du --bytes --summarize -- "$1" | awk '{print $1}'
}
