# MARK: - PATH Construction

set -x BREW_SBIN "/usr/local/sbin"
set -x CARGO_BIN "$HOME/.cargo/bin"
set -x DENO_BIN "$HOME/.deno/bin"
set -x DPRINT_BIN "$HOME/.dprint/bin"
set -x GO_BIN "$HOME/.golang/bin"

set -x PATH $BREW_SBIN $CARGO_BIN $DENO_BIN $DPRINT_BIN $GO_BIN $PATH

# MARK: - Environment

set -gx EDITOR "$CARGO_BIN/hx"

# MARK: - Aliases

alias l='eza --long --header --all --group-directories-first'
alias lt='eza --tree --level=2 --git-ignore'
alias ls='eza --classify'

abbr -a "-" "cd -"
abbr -a ".." "cd .."
abbr -a "..." "cd ../.."
abbr -a "...." "cd ../../.."

alias rd='rmdir'

alias cat='bat --theme=gruvbox-dark'
alias zel='zellij --layout default'

# Group: git
abbr -a "g" "git"
abbr -a "gi" "git init"
abbr -a "gst" "git status"
abbr -a "gsh" "git show"
abbr -a "gshs" "git show --stat"

alias ga='git add'
alias gap='git add --patch'
alias gaa='git add --all'

alias grm='git rm'
alias gmv='git mv'

alias gr='git reset'
alias grs='git reset --soft'
alias grh='git reset --hard'
alias grp='git reset --patch'

alias gc='git commit --verbose'
alias gcm='git commit -m'
alias gco='git checkout'

alias gm='git merge'
alias gma='git merge --abort'

alias grb='git rebase'
alias grbi='git rebase --interactive'
alias grbc='git rebase --continue'
alias grbs='git rebase --skip'
alias grba='git rebase --abort'

alias gb='git branch'
alias gbl='git blame'
alias gd='git diff --minimal'

alias gre='git remote'
alias grel='git remote list'
alias gres='git remote show'

abbr -a "gsw" "git switch"
abbr -a "gsc" "git switch -c"

alias gf='git fetch'
alias gfa='git fetch --all'

alias gu='git pull'
alias gur='git pull --rebase --autostash'
alias gum='git pull --no-rebase'

alias gp='git push'
alias gpa='git push --all'
alias gpf='git push --force-with-lease'
alias gpff='git push --force'

# MARK: - Functions

function md
    mkdir -p $argv
end

function mcd
    mkdir -p $argv
    cd $argv[-1]
end

function tcd
    cd (mktemp -d)
end

function lk
    set loc (walk --icons $argv); and cd $loc;
end

function update_history --on-event fish_exit
    history --save
    history --merge
end

zoxide init fish | source
