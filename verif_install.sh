#!/bin/bash

# Codes couleurs pour la lisibilité (vert, rouge, reset)
COLOR_GREEN="\033[32m"
COLOR_RED="\033[31m"
COLOR_RESET="\033[0m"


# Liste des commandes à tester
COMMANDS=(
	"curl"
	"wget"
	"gpg"
 	"git"
 	"php"
 	"mysql"
 	"code"
 	"composer"
 	"symfony"
 	"dbeaver-ce"
)


for cmd in "${COMMANDS[@]}"; do
  if command -v "$cmd" >/dev/null 2>&1; then
    echo -e "***** $cmd -> ${COLOR_GREEN}TRUE${COLOR_RESET} *****"
  else
    echo -e "***** $cmd -> ${COLOR_RED}FALSE${COLOR_RESET} *****"
  fi
done
