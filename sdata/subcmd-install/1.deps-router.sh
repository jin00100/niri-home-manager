# Dependency installation router for iNiR
# This script is meant to be sourced.

# shellcheck shell=bash

printf "${STY_CYAN}[$0]: 1. Install dependencies${STY_RST}\n"

#####################################################################################
# Route to the appropriate installer based on OS
#####################################################################################

case "$OS_GROUP_ID" in
  arch)
    printf "${STY_GREEN}Using Arch Linux installer${STY_RST}\n"
    source ./sdata/dist-arch/install-deps.sh
    ;;
    
  debian|ubuntu)
    printf "${STY_GREEN}Using Debian/Ubuntu installer${STY_RST}\n"
    source ./sdata/dist-debian/install-deps.sh
    ;;
    
  *)
    printf "${STY_YELLOW}Distribution $OS_GROUP_ID is not officially supported (Arch and Debian/Ubuntu supported).${STY_RST}\n"
    return 1
    ;;
esac
