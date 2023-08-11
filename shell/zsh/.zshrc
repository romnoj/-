## Plugin Manager Setup

if [[ ! -f ~/.local/share/zinit/zinit.git/zinit.zsh ]] \
       && (( $+commands[git] )); then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} "\
          "Initiative Plugin Manager "\
          "(%F{33}zdharma-continuum/zinit%F{220})…%f"
    mkdir -p "$HOME/.local/share/zinit" && \
        command chmod g-rwX ~/.local/share/zinit
    git clone https://github.com/zdharma-continuum/zinit \
        ~/.local/share/zinit/zinit.git && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
            print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

zinit light-mode for \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-readurl \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-rust

## Zinit Configuration

ennui_zinit=

if [[ -f ~/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    ennui_zinit="$HOME/.local/share/zinit/zinit.git/zinit.zsh"
fi

if [[ -n $ennui_zinit ]]; then
    path=(${path:#*/.local/share/zinit/plugins/*})

    . $ennui_zinit

    zinit light zsh-users/zsh-autosuggestions
    zinit light zsh-users/zsh-history-substring-search

    zinit ice blockf
    zinit light zsh-users/zsh-completions

    zinit light marlonrichert/zsh-autocomplete
    zinit light zdharma/fast-syntax-highlighting

    autoload -Uz compinit
    compinit
fi

## Core settings

# Load colors.
autoload -U colors && colors

# Allow comments in the interactive shell (start with #).
setopt interactive_comments

# CTRL-s and CTRL-q don't freeze/unfreeze command output.
unsetopt flow_control

# Makes globs case-insensitive.
unsetopt case_glob

# Makes globbing regexes case-insensitive.
unsetopt case_match

# Allow globs to match dotfiles.
setopt glob_dots

# Sort filenames numerically.
setopt numeric_glob_sort

# Disable history expansion.
setopt no_bang_hist

# (Almost) never discard history within a session.
HISTSIZE=1000000

# Save history to disk.
HISTFILE=~/.zsh_history

# Never discard history.
SAVEHIST=1000000

# Don't save commands that start with a leading space.
setopt hist_ignore_space

# All zsh sessions share the same history file.
setopt share_history

# Might improve performance and prevent corruption.
setopt hist_fcntl_lock

# Remove whitespace when saving commands to history.
setopt hist_reduce_blanks

# Avoid immediate execution on history expansion.
setopt hist_verify

# Deduplicate history entries.
setopt hist_ignore_all_dups

#  Makes it so old directory is saved in the directory stack.
setopt autopushd

# Makes it so that "cd -n" gives you the directory you were in.
setopt pushdminus

# Working directory path is automatically followed.
setopt chaselinks

# Automatically enter a directory.
setopt autocd

# Type "." to reload the shell.
function _accept-line {
    emulate -LR zsh
    if [[ $BUFFER == "." ]]; then
        BUFFER="exec zsh"
    fi
    zle .accept-line
}
zle -N accept-line _accept-line

# Use TAB and Shift-TAB for cycling autocompletions.
bindkey '\t' menu-select "$terminfo[kcbt]" menu-select
bindkey -M menuselect '\t' menu-complete \
        "$terminfo[kcbt]" reverse-menu-complete

# If only one suggestion, complete it by default.
zstyle ':autocomplete:*complete*:*' insert-unambiguous yes

# Bind up and down arrow keys for history sorting.
() {
   local -a prefix=( '\e'{\[,O} )
   local -a up=( ${^prefix}A ) down=( ${^prefix}B )
   local key=
   for key in $up[@]; do
      bindkey "$key" up-line-or-history
   done
   for key in $down[@]; do
      bindkey "$key" down-line-or-history
   done
}

### Aliases and Utilities

# Make directory, including parents if a path is specified.
alias md='mkdir -p'

# Make directory and "cd" into it.
function mcd {
    emulate -LR zsh
    mkdir -p $@
    cd ${@[$#]}
}

# Remove directory.
alias rd='rmdir'

# List the last few directories visited.
alias ds='dirs -v | head -10'

# Use "cd -n" to jump into a directory.
alias -- -='cd -'
alias -- -1='cd -1'
alias -- -2='cd -2'
alias -- -3='cd -3'
alias -- -4='cd -4'
alias -- -5='cd -5'
alias -- -6='cd -6'
alias -- -7='cd -7'
alias -- -8='cd -8'
alias -- -9='cd -9'

# exa (ls replacement).
if (( $+commands[exa] )); then
    function l {
        emulate -LR zsh
        exa --all --header --long --color-scale $@
    }

    function lg {
        emulate -LR zsh
        l --grid $@
    }

    function lt {
        emulate -LR zsh
        l --tree --ignore-glob ".git|.svn|node_modules" $@
    }

    function lti {
        emulate -LR zsh
        l --tree --ignore-glob ".git|.svn|node_modules|$1" ${@:2}
    }

    function ltl {
        emulate -LR zsh
        lt --level $@
    }

    function ltli {
        l --tree --level $1 --ignore-glob ".git|.svn|node_modules|$2" ${@:3}
    }
else
    if (( $+commands[gls] )); then
        alias l='command gls -AlhF --color=auto'
    else
        alias l='ls -AlhF'
    fi
    if (( $+commands[tree] )); then
        alias lt='tree -a'
        alias ltl='tree -aL'
    fi
fi

# More precise help command.
unalias run-help 2>/dev/null || true
autoload -Uz run-help
autoload -Uz run-help-git
autoload -Uz run-help-ip
autoload -Uz run-help-openssl
autoload -Uz run-help-p4
autoload -Uz run-help-sudo
autoload -Uz run-help-svk
autoload -Uz run-help-svn

alias help=run-help

## Git

if (( $+commands[git] )); then
    alias g=git
    alias gi='git init'
    alias gst='git status'
    alias gsh='git show'
    alias gshs='git show --stat'

    alias ge='git help'
    alias ghi='git help init'
    alias ghst='git help status'
    alias ghsh='git help show'
    alias ghl='git help log'
    alias gha='git help add'
    alias ghrm='git help rm'
    alias ghmv='git help mv'
    alias ghr='git help reset'
    alias ghcm='git help commit'
    alias ghcp='git help cherry-pick'
    alias ghrv='git help revert'
    alias ght='git help tag'
    alias ghn='git help notes'
    alias ghsta='git help stash'
    alias ghd='git help diff'
    alias ghbl='git help blame'
    alias ghb='git help branch'
    alias ghco='git help checkout'
    alias ghlsf='git help ls-files'
    alias ghx='git help clean'
    alias ghbs='git help bisect'
    alias ghm='git help merge'
    alias ghrb='git help rebase'
    alias ghsm='git help submodule'
    alias ghcl='git help clone'
    alias ghre='git help remote'
    alias ghf='git help fetch'
    alias ghu='git help pull'
    alias ghp='git help push'

    for nograph in "" n; do
        local graph_flags=
        if [[ -z $nograph ]]; then
            graph_flags=" --graph"
        fi
        for all in "" a; do
            local all_flags=
            if [[ -n $all ]]; then
                all_flags=" --all"
            fi
            for oneline in "" o; do
                local oneline_flags=
                if [[ -n $oneline ]]; then
                    oneline_flags=" --oneline"
                fi
                for diff in "" s p ps sp; do
                    local diff_flags=
                    case $diff in
                        s) diff_flags=" --stat";;
                        p) diff_flags=" --patch";;
                        ps|sp) diff_flags=" --patch --stat";;
                    esac
                    for search in "" g G S; do
                        local search_flags=
                        case $search in
                            g) search_flags=" --grep";;
                            G) search_flags=" -G";;
                            S) search_flags=" -S";;
                        esac
                        alias="gl${nograph}${all}${oneline}${diff}${search}="
                        alias+="git log --decorate"
                        alias+="${graph_flags}${all_flags}"
                        alias+="${oneline_flags}${diff_flags}${search_flags}"
                        alias $alias
                    done
                done
            done
        done
    done

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
    alias gca='git commit --verbose --amend'
    alias gcaa='git commit --verbose --amend --all'
    alias gcf='git commit -C HEAD --amend'
    alias gcfa='git commit -C HEAD --amend --all'
    alias gce='git commit --verbose --allow-empty'
    alias gcm='git commit -m'
    alias gcma='git commit --all -m'
    alias gcam='git commit --amend -m'
    alias gcama='git commit --amend --all -m'
    alias gcem='git commit --allow-empty -m'

    alias gcn='git commit --no-verify --verbose'
    alias gcna='git commit --no-verify --verbose --amend'
    alias gcnaa='git commit --no-verify --verbose --amend --all'
    alias gcnf='git commit --no-verify -C HEAD --amend'
    alias gcnfa='git commit --no-verify -C HEAD --amend --all'
    alias gcne='git commit --no-verify --verbose --allow-empty'
    alias gcnm='git commit --no-verify -m'
    alias gcnma='git commit --no-verify --all -m'
    alias gcnam='git commit --no-verify --amend -m'
    alias gcnama='git commit --no-verify --amend --all -m'
    alias gcnem='git commit --no-verify --allow-empty -m'

    alias gcp='git cherry-pick'
    alias gcpc='git cherry-pick --continue'
    alias gcpa='git cherry-pick --abort'

    alias grv='git revert'
    alias grva='git revert --abort'
    alias grvm='git revert -m'

    alias gt='git tag'
    alias gtd='git tag --delete'

    alias gn='git notes'
    alias gna='git notes add'
    alias gne='git notes edit'
    alias gnr='git notes remove'

    alias gsta='git stash save'
    alias gstau='git stash save --include-untracked'
    alias gstap='git stash save --patch'
    alias gstl='git stash list'
    alias gsts='git stash show --text'
    alias gstss='git stash show --stat'
    alias gstaa='git stash apply'
    alias gstp='git stash pop'
    alias gstd='git stash drop'

    alias gd='git diff --minimal'
    alias gds='git diff --minimal --stat'
    alias gdc='git diff --minimal --cached'
    alias gdcs='git diff --minimal --cached --stat'
    alias gdn='git diff --minimal --no-index'

    alias gbl='git blame'

    alias gb='git branch'
    alias gbsu='git branch --set-upstream-to'
    alias gbusu='git branch --unset-upstream'
    alias gbd='git branch --delete'
    alias gbdd='git branch --delete --force'

    alias gco='git checkout'
    alias gcot='git checkout --track'
    alias gcop='git checkout --patch'
    alias gcob='git checkout -B'

    alias glsf='git ls-files'

    alias gx='git clean'
    alias gxu='git clean -ffd'
    alias gxi='git clean -ffdX'
    alias gxa='git clean -ffdx'

    alias gbs='git bisect'
    alias gbss='git bisect start'
    alias gbsg='git bisect good'
    alias gbsb='git bisect bad'
    alias gbsr='git bisect reset'

    alias gm='git merge'
    alias gma='git merge --abort'

    alias grb='git rebase'
    alias grbi='git rebase --interactive'
    alias grbc='git rebase --continue'
    alias grbs='git rebase --skip'
    alias grba='git rebase --abort'

    alias gsm='git submodule'
    alias gsma='git submodule add'
    alias gsms='git submodule status'
    alias gsmi='git submodule init'
    alias gsmd='git submodule deinit'
    alias gsmu='git submodule update --recursive'
    alias gsmui='git submodule update --init --recursive'
    alias gsmf='git submodule foreach'
    alias gsmy='git submodule sync'

    alias gcl='git clone --recursive'
    alias gcls='git clone --depth=1 --single-branch --no-tags'

    alias gre='git remote'
    alias grel='git remote list'
    alias gres='git remote show'

    alias gf='git fetch'
    alias gfa='git fetch --all'
    alias gfu='git fetch --unshallow'

    alias gu='git pull'
    alias gur='git pull --rebase --autostash'
    alias gum='git pull --no-rebase'

    alias gp='git push'
    alias gpa='git push --all'
    alias gpf='git push --force-with-lease'
    alias gpff='git push --force'
    alias gpu='git push --set-upstream'
    alias gpd='git push --delete'
    alias gpt='git push --tags'
fi