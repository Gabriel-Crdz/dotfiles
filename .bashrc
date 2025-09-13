# ============================
# ~/.bashrc - Dotfiles OpenSUSE
# ============================

# ----------------------------
# 1. Variáveis de ambiente
# ----------------------------
export EDITOR=code
export VISUAL=$EDITOR
export LANG=en_US.UTF-8
export PATH=$HOME/bin:$PATH

# ----------------------------
# 2. Prompt personalizado
# Cores Viridian (cyan, magenta, azul, branco)
# ----------------------------
PS1='\[\033[36m\]\u\[\033[35m\]@\h\[\033[34m\]:\w\[\033[0m\]\$ '

# ----------------------------
# 3. Habilitar cores em ls e grep
# ----------------------------
alias ls='ls --color=auto'
alias grep='grep --color=auto'

# ----------------------------
# 4. Aliases úteis
# ----------------------------
alias ll='ls -lah'
alias la='ls -A'
alias l='ls -CF'
alias ..='cd ..'
alias ...='cd ../..'
alias update='sudo zypper refresh && sudo zypper update'

# ----------------------------
# 5. Funções
# ----------------------------
# Abrir uLauncher
ulauncher() {
    ~/.config/ulauncher/ulauncher_start.sh &
}

# ----------------------------
# 6. Neofetch automático
# ----------------------------
if command -v neofetch >/dev/null 2>&1; then
    neofetch
fi

# ----------------------------
# 7. Git prompt (branch atual)
# ----------------------------
if [ -f /usr/share/git-core/contrib/completion/git-prompt.sh ]; then
    source /usr/share/git-core/contrib/completion/git-prompt.sh
    PS1='\[\033[36m\]\u\[\033[35m\]@\h\[\033[34m\]:\w\[\033[33m\]$(__git_ps1 " (%s)")\[\033[0m\]\$ '
fi

# ----------------------------
# 8. Histórico melhorado
# ----------------------------
HISTSIZE=5000
HISTFILESIZE=5000
HISTCONTROL=ignoredups:erasedups
shopt -s histappend

# ----------------------------
# 9. Atalhos e melhorias
# ----------------------------
# Evitar sobrescrever arquivos sem querer
set -o noclobber

# Correções de digitação automática
shopt -s cdspell

# ----------------------------
# 10. Core dump desativado (segurança)
# ----------------------------
ulimit -c 0

# ----------------------------
# 11. Configurações de desenvolvimento
# ----------------------------
# JAVA_HOME (ajuste se necessário)
export JAVA_HOME=/usr/lib/jvm/java-17-openjdk
export PATH=$JAVA_HOME/bin:$PATH

# Python
export PYTHONSTARTUP=$HOME/.pythonrc

# C/C++
export PATH=/usr/bin:$PATH
