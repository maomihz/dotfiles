HOME=${HOME:-"/home/cat"}
# Path to your oh-my-zsh installation.
for ZSH in \
    "/usr/share/oh-my-zsh" \
    "$HOME/.oh-my-zsh"
do
    if [ -d "$ZSH" ]; then
        export ZSH
        break
    fi
done

# ================== OH MY ZSH =======================================
# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="ys"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in ~/.oh-my-zsh/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
    git
    colored-man-pages
    ruby
    cp
    z
    extract
    vi-mode
    sudo
)

if [[ "$OSTYPE" == "darwin"* ]]; then
    plugins+=(
        tmux
        zsh-autosuggestions
        osx
        brew
        supervisor
        pass
    )
fi

# User configuration
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export EDITOR='vim'

export VAGRANT_DEFAULT_PROVIDER=virtualbox
export VAGRANT_BOX_UPDATE_CHECK_DISABLE=yes
export ANSIBLE_INVENTORY=./hosts

# Load homebrew path
for BREW in \
    "/home/linuxbrew/.linuxbrew/bin" \
    "$HOME/.linuxbrew/bin"           \
    "$HOME/.brew/bin"
do
    if [ -x "$BREW/brew" ]; then
        eval "$($BREW/brew shellenv)"
        break
    fi
done


if command -v "brew" 1>/dev/null 2>&1; then
    HOMEBREW_PREFIX=${HOMEBREW_PREFIX:-"/usr/local"}
    HOMEBREW_CELLAR=${HOMEBREW_CELLAR:-"/usr/local/Cellar"}
    HOMEBREW_REPOSITORY=${HOMEBREW_REPOSITORY:-"/usr/local/Homebrew"}
fi

# Load oh-my-zsh after brew path
if [ -n "$ZSH" ]; then
  source $ZSH/oh-my-zsh.sh
  ZSH_CACHE_DIR="$HOME/.cache/oh-my-zsh"
  [[ -d "$ZSH_CACHE_DIR" ]] || mkdir -p "$ZSH_CACHE_DIR"
fi


# Language envs
for E in rb py nod j go pl
do
    ENV_CMD="${E}env"
    ENV_ROOT="$HOME/.${ENV_CMD}"
    [ -d "$ENV_ROOT/bin" ] && export PATH="$ENV_ROOT/bin:$PATH"
    if command -v "$ENV_CMD" 1>/dev/null 2>&1; then
        eval "$($ENV_CMD init - --no-rehash)"
    fi
done


# Additional brew PATH
for P in \
    "gnu-sed/libexec/gnubin"    \
    "gnu-tar/libexec/gnubin"    \
    "coreutils/libexec/gnubin"  \
    "findutils/libexec/gnubin"  \
    "gnu-getopt/bin"            \
    "gettext/bin"               \
    "openssl@1.1/bin"           \
    "node@10/bin"
do
    if [ -d "$HOMEBREW_PREFIX/opt/$P" ]; then
        export PATH="$HOMEBREW_PREFIX/opt/$P:$PATH"
    fi
done


# Optional
for P in \
    "/Applications/Sublime Text.app/Contents/SharedSupport/bin"    \
    "/opt/namecoin/bin"    \
    "$HOME/.local/bin"     \
    "$HOME/.composer/vendor/bin" \
    "$HOME/.yarn/bin"      \
    "$HOME/.local/opt/jdk8u242-b08/bin" \
    "$HOME/.gem/ruby/"*/bin(N)
do
    if [ -d "$P" ]; then
        export PATH="$P:$PATH"
    fi
done


#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]] && source "$SDKMAN_DIR/bin/sdkman-init.sh"

# added by travis gem
TRAVIS_DIR="$HOME/.travis"
[ -f "$TRAVIS_DIR/travis.sh" ] && source "$TRAVIS_DIR/travis.sh"

# Google cloud auto completion
for GOOGLE_CLOUD_SDK in \
    "$HOMEBREW_PREFIX/Caskroom/google-cloud-sdk/latest/google-cloud-sdk" \
    "$HOME/.local/opt/google-cloud-sdk"
do
    if [ -d "$GOOGLE_CLOUD_SDK" ]; then
        source "$GOOGLE_CLOUD_SDK/path.zsh.inc"
        source "$GOOGLE_CLOUD_SDK/completion.zsh.inc"
    fi
done


if command -v "aws" 1>/dev/null 2>&1
then
    source "$(pyenv which aws_zsh_completer.sh)"
fi

if command -v "az" 1>/dev/null 2>&1
then
    source "$(pyenv which az.completion.sh)" >/dev/null 2>&1
fi

if command -v "kubectl" 1>/dev/null 2>&1
then
    eval "$(kubectl completion zsh)"
fi

if command -v "helm" 1>/dev/null 2>&1
then
    eval "$(helm completion zsh)"
fi

PERL5_DIR="$HOME/perl5"
if [ -d "$PERL5_DIR" ]
then
    eval "$(perl -I"$PERL5_DIR"/lib/perl5 -Mlocal::lib)"
    # PATH="$PERL5_DIR/bin${PATH:+:${PATH}}"; export PATH;
    # PERL5LIB="$PERL5_DIR/lib/perl5${PERL5LIB:+:${PERL5LIB}}"; export PERL5LIB;
    # PERL_LOCAL_LIB_ROOT="$PERL5_DIR${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"; export PERL_LOCAL_LIB_ROOT;
    # PERL_MB_OPT="--install_base \"$PERL5_DIR\""; export PERL_MB_OPT;
    # PERL_MM_OPT="INSTALL_BASE=$PERL5_DIR"; export PERL_MM_OPT;
fi














# Alias
alias ls='ls --color=auto'
alias wgetr='wget -r -np -R "index.html*"'
alias ydla='youtube-dl -o "%(title)s.%(ext)s" -f mp4 --extract-audio --write-thumbnail --write-description'
alias ydl4='youtube-dl -o "%(title)s.%(ext)s" -f mp4'
alias ydl='youtube-dl -o "%(title)s.%(ext)s"'
alias m='mpv'
alias ctl='supervisorctl'
alias userctl='systemctl --user'
alias reload='sudo killall -SIGUSR1'
alias dns='sudo killall -SIGHUP mDNSResponder'


# Functions
function rand() {
    CHAR="${1:-0-9a-z}"
    LEN="${2:-15}"
    cat /dev/urandom | base64 | tr -dc "$CHAR" | head -c "$LEN" | xargs
}

function rands() {
    CHAR="${1:-0-9a-z}"
    LEN="${2:-15}"
    cat /dev/urandom | tr -dc "$CHAR" | head -c "$LEN" | xargs
}

function rn() {
    rand "0-9" $*
}

function rc() {
    rand "0-9a-zA-Z" $*
}

function rl() {
    rand "a-z" $*
}

function rp() {
    rands '0-9A-Za-z!@#$%^&*()-+=' $*
}


function synctime() {
    date -s "$(curl -s --head http://google.com | grep ^Date: | sed 's/Date: //g')"
}

function path() {
    echo $PATH | tr ':' '\n'
}

function colors() {
    for i in {0..255}; do printf "\x1b[38;5;${i}mcolor%-5i\x1b[0m" $i ; if ! (( ($i + 1 ) % 8 )); then echo ; fi ; done
}

# update_repo <url> <path>
function update_repo() {
    if [ -z "${1}" ]
    then
        echo "Usage: update_repo <url> <path>"
        return
    fi
    REPO_URL="${1}"
    REPO_DEST="${2}"

    if [[ ! "$REPO_URL" == https://* ]]
    then
      REPO_URL="https://github.com/$REPO_URL"
    fi

    echo "${REPO_URL} --> ${REPO_DEST}"

    if [ -z "${REPO_DEST}" ]
    then
        git clone ${REPO_URL}
    fi

    mkdir -p "${REPO_DEST}" || return
    pushd "${REPO_DEST}"
    git init
    git remote add origin "${REPO_URL}" || git remote set-url origin "${REPO_URL}"
    git pull origin master
    popd
}

function update_pyenv() {
    update_repo pyenv/pyenv ~/.pyenv
}
function update_rbenv() {
    update_repo https://github.com/rbenv/rbenv ~/.rbenv
    update_repo https://github.com/rbenv/ruby-build ~/.rbenv/plugins/ruby-build
}
function update_nodenv() {
    update_repo https://github.com/nodenv/nodenv ~/.nodenv
    update_repo https://github.com/nodenv/node-build ~/.nodenv/plugins/node-build
}
function update_vim_plug() {
    update_repo https://github.com/junegunn/vim-plug ~/.vim/vim-plug
}

function update_oh_my_zsh() {
    update_repo https://github.com/ohmyzsh/oh-my-zsh ~/.oh-my-zsh
}
function update_dotfiles() {
    update_repo maomihz/dotfiles ~/.cfg
}


# heroku autocomplete setup
# HEROKU_AC_ZSH_SETUP_PATH=/Users/cat/Library/Caches/heroku/autocomplete/zsh_setup
# [ -f "$HEROKU_AC_ZSH_SETUP_PATH" ] && source "$HEROKU_AC_ZSH_SETUP_PATH"


# added by travis gem
[ -f /Users/cat/.travis/travis.sh ] && source /Users/cat/.travis/travis.sh

if command -v "keychain" 1>/dev/null 2>&1
then
    eval "$(keychain --eval -q)"
fi

