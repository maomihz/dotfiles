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
    dotenv
    pass
    supervisor
)

if [[ "$OSTYPE" == "darwin"* ]]; then
    is_mac="true"
    plugins+=(osx)
fi

# ===== User configuration =====
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export EDITOR='vim'

export VAGRANT_DEFAULT_PROVIDER=virtualbox
export VAGRANT_BOX_UPDATE_CHECK_DISABLE=yes
export ANSIBLE_INVENTORY=./hosts.yaml

# ===== Loading Homebrew =====
BREW_PATHS=(
    "/home/linuxbrew/.linuxbrew/bin"
    "$HOME/.linuxbrew/bin"
    "$HOME/.brew/bin"
)

# Load non-standard homebrew path
for BREW in $BREW_PATHS; do
    if [ -x "$BREW/brew" ]; then
        eval "$($BREW/brew shellenv)"
        break
    fi
done

if command -v "brew" 1>/dev/null 2>&1; then
    HOMEBREW_PREFIX=${HOMEBREW_PREFIX:-"/usr/local"}
    HOMEBREW_CELLAR=${HOMEBREW_CELLAR:-"/usr/local/Cellar"}
    HOMEBREW_REPOSITORY=${HOMEBREW_REPOSITORY:-"/usr/local/Homebrew"}
    CASKROOM="$HOMEBREW_PREFIX/Caskroom"
    plugins+=(brew)
fi

type tmux > /dev/null && plugins+=(tmux)

# ===== Configure additional PATH variable =====
BREW_OPT_PATHS=(
    "gnu-sed/libexec/gnubin"
    "gnu-tar/libexec/gnubin"
    "coreutils/libexec/gnubin"
    "findutils/libexec/gnubin"
    "gnu-getopt/bin"
    "gettext/bin"
    "openssl@1.1/bin"
    "node@10/bin"
)

OPT_PATHS=(
    "/Applications/Sublime Text.app/Contents/SharedSupport/bin"
    "$HOME/Applications/Sublime Text.app/Contents/SharedSupport/bin"
    "/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
    "$HOME/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
    "$HOME/.local/bin"
    "$HOME/.composer/vendor/bin"
    "$HOME/.yarn/bin"
    "$HOME/.local/opt/jdk8u242-b08/bin"
    "$HOME/.local/opt/jdk-11.0.7/bin"
    "$HOME/.local/opt/jdk-14/bin"
)

GOOGLE_CLOUD_SDK_PATHS=(
    "$CASKROOM/google-cloud-sdk/latest/google-cloud-sdk"
    "$HOME/.local/opt/google-cloud-sdk"
)

# Used for update_gitignore function.
# https://github.com/github/gitignore
GITIGNORE_INCLUDE=(
    Python
    Java
    Global/JetBrains
    Global/macOS
    Global/VisualStudioCode
)

# Additional zsh scripts before loading oh-my-zsh
FPATH_PATHS=(
    "$HOMEBREW_PREFIX/share/zsh/site-functions"
)

for P in $FPATH_PATHS; do
    if [ -d "$P" ]; then
        FPATH="$P:$FPATH"
    fi
done

# Load oh-my-zsh after brew path
if [ -n "$ZSH" ]; then
  source $ZSH/oh-my-zsh.sh
  ZSH_CACHE_DIR="$HOME/.cache/oh-my-zsh"
  [[ -d "$ZSH_CACHE_DIR" ]] || mkdir -p "$ZSH_CACHE_DIR"
fi

# Language envs
for E in rb py nod j go pl; do
    ENV_CMD="${E}env"
    ENV_ROOT="$HOME/.${ENV_CMD}"
    [ -d "$ENV_ROOT/bin" ] && export PATH="$ENV_ROOT/bin:$PATH"
    if command -v "$ENV_CMD" 1>/dev/null 2>&1; then
        eval "$($ENV_CMD init - --no-rehash)"
    fi
done


# Additional brew opt PATH
for P in $BREW_OPT_PATHS; do
    if [ -d "$HOMEBREW_PREFIX/opt/$P" ]; then
        export PATH="$HOMEBREW_PREFIX/opt/$P:$PATH"
    fi
done


# Optional
for P in $OPT_PATHS; do
    if [ -d "$P" ]; then
        export PATH="$P:$PATH"
    fi
done


# THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]] && source "$SDKMAN_DIR/bin/sdkman-init.sh"

# added by travis gem
TRAVIS_DIR="$HOME/.travis"
[ -f "$TRAVIS_DIR/travis.sh" ] && source "$TRAVIS_DIR/travis.sh"

# Google cloud auto completion
for GOOGLE_CLOUD_SDK in $GOOGLE_CLOUD_SDK_PATHS; do
    if [ -d "$GOOGLE_CLOUD_SDK" ]; then
        source "$GOOGLE_CLOUD_SDK/path.zsh.inc"
        source "$GOOGLE_CLOUD_SDK/completion.zsh.inc"
    fi
done

# if command -v "aws" 1>/dev/null 2>&1
# then
#     source "$(pyenv which aws_zsh_completer.sh)"
# fi

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



# ===== Alias and custom functions =====
alias ls='ls --color=auto'
alias wgetr='wget -r -np -R "index.html*"'
alias ydla='youtube-dl -o "%(title)s.%(ext)s" -f mp4 --extract-audio --write-thumbnail --write-description'
alias ydl4='youtube-dl -o "%(title)s.%(ext)s" -f mp4'
alias ydl='youtube-dl -o "%(title)s.%(ext)s"'
alias ydlbest='youtube-dl -o "%(title)s.%(ext)s" -f "bestvideo+bestaudio[ext=m4a]/bestvideo+bestaudio/best" --merge-output-format mp4'
alias ydlbest4='youtube-dl -o "%(title)s.%(ext)s" -f "bestvideo[ext=mp4]+bestaudio[ext=m4a]/bestvideo+bestaudio/best" --merge-output-format mp4'
alias m='mpv'
alias ctl='supervisorctl'
alias userctl='systemctl --user'
alias sctl='systemctl --user'
alias uctl='systemctl --user'
alias reload='sudo killall -SIGUSR1'
alias dns='sudo killall -SIGHUP mDNSResponder'
alias y='yay'

PACMAN_PRIVILEGED_OPERATIONS=(
    Sc Scc Sccc Su Sw S Sy Syu
    R Rn Rns Rs
)

PACMAN_OPERATIONS=(
    Sg Si Sii Sl Ss
    Q Qc Qe Qi Qk Ql Qm Qo Qp Qs Qu
)

for PACMAN in pacman pacapt; do
    if type "$PACMAN" > /dev/null; then
        PACMAN_CMD="$PACMAN"

        # Check if pacman is owned by the user
        if [[ ! -O $(which $PACMAN_CMD) ]]; then
            PACMAN_PRIVILEGED_CMD="sudo $PACMAN"
        else
            PACMAN_PRIVILEGED_CMD="$PACMAN"
        fi
    fi
done

if [ -n "$PACMAN_CMD" ]; then
    for P in $PACMAN_PRIVILEGED_OPERATIONS; do
        alias "$P"="$PACMAN_PRIVILEGED_CMD -$P"
    done
    for P in $PACMAN_OPERATIONS; do
        alias "$P"="$PACMAN_CMD -$P"
    done
fi


# Functions
function randstr() {
    CHAR="${1:-0-9a-z}"
    LEN="${2:-16}"
    COUNT="${3:-1}"
    for i in {1..$COUNT}; do
        cat /dev/urandom | tr -dc "$CHAR" | head -c "$LEN" | xargs
    done
}

function rs() randstr "0-9a-z" $@
function rn() randstr "0-9" $@
function rc() randstr "0-9a-zA-Z" $@
function rC() randstr "a-zA-Z" $@
function rl() randstr "a-z" $@
function rL() randstr "A-Z" $@
function rh() randstr "0-9a-f" $@
function rH() randstr "0-9A-F" $@
function rp() randstr '0-9A-Za-z!@#$%^&*()-+=' $@


function synctime() {
    date -s "$(curl -s --head http://google.com | grep ^Date: | sed 's/Date: //g')"
}

function path() {
    echo $PATH | tr ':' '\n'
}

function colors() {
    for i in {0..255}
    do
        printf "\x1b[38;5;${i}mcolor%-5i\x1b[0m" $i
        if ! (( ($i + 1 ) % 8 )); then
            echo
        fi
    done
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
    pushd "${REPO_DEST}" > /dev/null
    git init
    git remote add origin "${REPO_URL}" || git remote set-url origin "${REPO_URL}"
    git pull origin master
    popd > /dev/null
}

function update_pyenv() {
    update_repo pyenv/pyenv ~/.pyenv
}
function update_rbenv() {
    update_repo rbenv/rbenv ~/.rbenv
    update_repo rbenv/ruby-build ~/.rbenv/plugins/ruby-build
}
function update_nodenv() {
    update_repo nodenv/nodenv ~/.nodenv
    update_repo nodenv/node-build ~/.nodenv/plugins/node-build
}
function update_vim_plug() {
    update_repo junegunn/vim-plug ~/.vim/vim-plug
}
function update_oh_my_zsh() {
    update_repo ohmyzsh/oh-my-zsh ~/.oh-my-zsh
}
function update_dotfiles() {
    update_repo maomihz/dotfiles ~/.cfg
}
function update_pacman() {
    [ -x "/usr/bin/pacman" ] && return 0

    echo Install globally:
    echo " " sudo curl -Lo /usr/local/bin/pacapt https://github.com/icy/pacapt/raw/ng/pacapt
    echo Install locally
    echo " " curl -Lo ~/.local/bin/pacapt https://github.com/icy/pacapt/raw/ng/pacapt
}

function update_gitignore() {
    update_repo github/gitignore.git ~/.cfg/gitignore
    echo git config --global core.excludesFile '~/.gitignore'
    git config --global core.excludesFile '~/.gitignore'

    for GITIGNORE_FILE in $GITIGNORE_INCLUDE; do
        if [[ ! -f "$GITIGNORE_FILE" ]]; then
            GITIGNORE_FILE="$HOME/.cfg/gitignore/$GITIGNORE_FILE.gitignore"
        fi
        echo "# Source: $GITIGNORE_FILE"
        cat "$GITIGNORE_FILE"
    done > ~/.gitignore
}

# heroku autocomplete setup
# HEROKU_AC_ZSH_SETUP_PATH=/Users/cat/Library/Caches/heroku/autocomplete/zsh_setup
# [ -f "$HEROKU_AC_ZSH_SETUP_PATH" ] && source "$HEROKU_AC_ZSH_SETUP_PATH"

if type "keychain" > /dev/null; then
    eval "$(keychain --eval -q)"
fi
