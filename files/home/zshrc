# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

if [[ -t 1 ]]; then
    stty -ixon
fi

plugins=(git zsh-autosuggestions zsh-syntax-highlighting fzf zsh-history-substring-search)
source ~/.oh-my-zsh/oh-my-zsh.sh
#bindkey -v

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
ZSH_THEME="powerlevel10k/powerlevel10k"
source ~/.oh-my-zsh/custom/themes/powerlevel10k/powerlevel10k.zsh-theme
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Enable history with large limits
HISTFILE=~/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000
setopt APPEND_HISTORY           # Append history instead of overwriting
setopt SHARE_HISTORY            # Share history across sessions
setopt HIST_IGNORE_DUPS         # Ignore duplicate commands
setopt HIST_IGNORE_ALL_DUPS     # Remove older duplicate commands from history
setopt HIST_SAVE_NO_DUPS        # Don't save duplicate lines in history

# Enable extended globbing (equivalent to `shopt -s globstar`)
setopt EXTENDED_GLOB

# Enable case-insensitive auto-completion
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# Make `less` more friendly for non-text input files
export LESSOPEN="| /usr/bin/lesspipe %s"
export LESS='-R'

# Some useful ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias tn='tmux new -s'
alias ta='tmux attach -t'
alias tls='tmux ls'

# Notify when a long-running command finishes
alias alert='notify-send --urgency=low -i "$(if [ $? = 0 ]; then echo terminal; else echo error; fi)" "$(history -n 1)"'

# Source additional aliases if they exist
#[[ -f ~/dotfiles/bash/aliases ]] && source ~/dotfiles/bash/aliases

# Set a fancy Powerlevel10k theme (already handled by p10k)
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Git Author Information
export GIT_AUTHOR_NAME="Carlos Gracia"
export GIT_AUTHOR_EMAIL="carlos.gracia.sola@energy-robotics.com"
export GIT_COMMITTER_NAME="$GIT_AUTHOR_NAME"
export GIT_COMMITTER_EMAIL="$GIT_AUTHOR_EMAIL"

# Set editor
export EDITOR=nvim

# Set workspace-related environment variables
export WSS_PREFIX="er_old"
export USER_ID=1000
export GROUP_ID=1000
export ER_DOCKERDEV_PROJECT_PATH=/home/carlos/er_dockerdev

# Source workspace scripts if they exist
#[[ -f ~/workspace_scripts_light/setup.bash ]] && source ~/workspace_scripts_light/setup.bash
#[[ -f ~/er_ws/setup.bash ]] && source ~/er_ws/setup.bash
#[[ -f /home/carlos/er_ws/setup.bash ]] && source /home/carlos/er_ws/setup.bash

# Extend WSS scripts
#[[ -d ${ER_DOCKERDEV_PROJECT_PATH}/wss_scripts/ ]] && extend_wss ${ER_DOCKERDEV_PROJECT_PATH}/wss_scripts/

# Allow Docker GUI access
xhost +local:docker &> /dev/null

# Initialize Zoxide (a smarter `cd` command replacement)
eval "$(zoxide init zsh)"

er() {
    local script_path="$HOME/workspace_scripts_light/scripts/$1"
    if [[ -x "$script_path" ]]; then
        shift
        "$script_path" "$@"
    elif [[ -x "$script_path.sh" ]]; then
        shift
        "$script_path.sh" "$@"
    else
        echo "Error: Command '$1' not found in workspace scripts."
        return 1
    fi
}

# Keychain for SSH agent
eval $(keychain --eval --agents ssh ~/.ssh/id_ed25519)
