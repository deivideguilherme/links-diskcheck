#!/usr/bin/env bash

# =============================================================================
# Links DiskCheck
# Módulo: commands.sh
# Descrição: Funções para execução controlada de comandos externos.
# Autor: Deivide Guilherme
# Versão: 0.1.0
# Licença: A definir
# =============================================================================

# =============================================================================
# Execução de comandos
# =============================================================================

# -----------------------------------------------------------------------------
# Executa um comando externo.
#
# O comando e seus argumentos devem ser recebidos separadamente.
#
# Retorno:
#   Código de retorno do comando executado.
#   1 - nenhum comando informado.
# -----------------------------------------------------------------------------
run_command()
{
    [[ "$#" -gt 0 ]] || return 1

    "$@"
}
