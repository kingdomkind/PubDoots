local pl = require("pl.path")

return function(lib)
    local body = [[
# Aliases
alias rm='rm -I'
alias grep='grep --color=auto'
alias build-config="(cd ]] .. pl.abspath(lib.modulesd) .. [[ && ./reload.sh)"
alias vi="nvim"
alias sudo="sudo "
alias space="du -sh ./ ; du -sh ./*"

alias ls="eza --icons=always --colour=always"
alias edit='cd ]] .. pl.abspath(lib.dootsd) .. [['
alias editm='cd ]] .. pl.abspath(lib.modulesd) .. [['
alias editu='cd ]] .. pl.abspath(lib.uniqued) .. [['

# Start Hyprland if on TTY1
if [ "$(tty)" = "/dev/tty1" ]; then exec start-hyprland; fi

autoload -U colors && colors

# Set History
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000

# Auto-complete
autoload -Uz compinit
compinit
comp_options+=(globdots) # include hidden files

typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[default]=none
ZSH_HIGHLIGHT_STYLES[unknown-token]=fg=009
ZSH_HIGHLIGHT_STYLES[reserved-word]=fg=009,underline
ZSH_HIGHLIGHT_STYLES[alias]=fg=28,bold
ZSH_HIGHLIGHT_STYLES[builtin]=fg=blue,bold
ZSH_HIGHLIGHT_STYLES[function]=fg=blue,bold
ZSH_HIGHLIGHT_STYLES[command]=fg=cyan
ZSH_HIGHLIGHT_STYLES[precommand]=fg=white,underline
ZSH_HIGHLIGHT_STYLES[commandseparator]=none
ZSH_HIGHLIGHT_STYLES[path]=fg=214,underline
ZSH_HIGHLIGHT_STYLES[globbing]=fg=063
ZSH_HIGHLIGHT_STYLES[history-expansion]=fg=white,underline
ZSH_HIGHLIGHT_STYLES[single-hyphen-option]=063
ZSH_HIGHLIGHT_STYLES[double-hyphen-option]=063
ZSH_HIGHLIGHT_STYLES[single-quoted-argument]=fg=214
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]=fg=214
ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]=fg=009
ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]=fg=009
ZSH_HIGHLIGHT_STYLES[assign]=none

source /usr/share/zsh/plugins/zsh-vi-mode/zsh-vi-mode.plugin.zsh
export _ZO_ECHO=1
eval "$(zoxide init zsh --cmd j)"
export EDITOR=nvim
]]

    return {
        desym = {
            files = {
                [lib.homed .. ".zshrc"] = {
                    source = body,
                    uid = lib.uid,
                    gid = lib.gid,
                    mode = lib.mode,
                }
            }
        }
    }
end
