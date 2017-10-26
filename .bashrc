# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi
if [ -f ~/dotfiles/.rc ]; then
	. ~/dotfiles/.rc
fi

# Base styles and color palette
BOLD=$(tput bold)
RESET=$(tput sgr0)
BLACK=$(tput setaf 0)
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
BLUE=$(tput setaf 4)
MAGENTA=$(tput setaf 5)
CYAN=$(tput setaf 6)
WHITE=$(tput setaf 255)
ORANGE=$(tput setaf 172)
 
style_user="\[${RESET}${ORANGE}\]"
style_host="\[${RESET}${YELLOW}\]"
style_path="\[${RESET}${GREEN}\]"
style_chars="\[${RESET}${WHITE}\]"
style_branch="${CYAN}"
 
if [[ "$SSH_TTY" ]]; then
    # connected via ssh
    style_host="\[${BOLD}${RED}\]"
elif [[ "$USER" == "root" ]]; then
    # logged in as root
    style_user="\[${BOLD}${RED}\]"
fi
 
is_git_repo() {
    $(git rev-parse --is-inside-work-tree &> /dev/null)
}
 
is_git_dir() {
    $(git rev-parse --is-inside-git-dir 2> /dev/null)
}
 
get_git_branch() {
    local branch_name
 
    # Get the short symbolic ref
    branch_name=$(git symbolic-ref --quiet --short HEAD 2> /dev/null) ||
    # If HEAD isn't a symbolic ref, get the short SHA
    branch_name=$(git rev-parse --short HEAD 2> /dev/null) ||
    # Otherwise, just give up
    branch_name="(unknown)"
 
    printf $branch_name
}
 
# Git status information
prompt_git() {
    local git_info git_state uc us ut st
 
    if ! is_git_repo || is_git_dir; then
        return 1
    fi
 
    git_info=$(get_git_branch)
 
    # Check for uncommitted changes in the index
    if ! $(git diff --quiet --ignore-submodules --cached); then
        uc="+"
    fi
 
    # Check for unstaged changes
    if ! $(git diff-files --quiet --ignore-submodules --); then
        us="!"
    fi
 
    # Check for untracked files
    if [ -n "$(git ls-files --others --exclude-standard)" ]; then
        ut="?"
    fi
 
    # Check for stashed files
    if $(git rev-parse --verify refs/stash &>/dev/null); then
        st="$"
    fi
 
    git_state=$uc$us$ut$st
 
    # Combine the branch name and state information
    if [[ $git_state ]]; then
        git_info="$git_info$git_state"
    fi
 
    printf " ${style_branch}[${git_info}]"
}
 
# Build the prompt
PS1="${style_user}\u" # Username
PS1+="${style_chars}@" # @
PS1+="${style_host}\h" # Host
PS1+="${style_chars}: " # :
PS1+="${style_path}\w" # Working directory
PS1+="\$(prompt_git)" # Git details
#PS1+="\n" # Newline
PS1+="${style_chars}\$ \[${RESET}\]" # $ (and reset color)

# Set dircolors
eval `dircolors ~/dotfiles/.colorrc`
alias ls='ls --color=auto'

# Setup pyenv
pyenv_root="${HOME}/.pyenv"
if [ -e "$pyenv_root" ]; then
	export PYENV_ROOT=$pyenv_root
	if [ -d "$PYENV_ROOT" ]; then
		export PATH=${PYENV_ROOT}/bin:$PATH
		eval "$(pyenv init -)"
		eval "$(pyenv virtualenv-init -)"
	fi
fi

