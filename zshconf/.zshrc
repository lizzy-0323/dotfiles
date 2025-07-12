# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ZSH 配置
export ZSH=$HOME/.oh-my-zsh

plugins=(
    git
    autojump
    zsh-syntax-highlighting
    zsh-autosuggestions
    zsh-vi-mode
)

# LLVM 工具链
export LLVM_PATH="/opt/homebrew/opt/llvm@15/bin"
# Ruby 相关
export RUBY_GEM_PATH="/Users/liziyi/.gem/ruby/3.1.3/bin"
export RUBY_RUBIES_PATH="/Users/liziyi/.rubies/ruby-3.1.3/lib/ruby/gems/3.1.0/bin"
export RUBY_BIN_PATH="/Users/liziyi/.rubies/ruby-3.1.3/bin"
# CMake
export CMAKE_PATH="/Applications/CMake.app/Contents/bin"
# rbenv
export RBENV_SHIMS_PATH="/Users/liziyi/.rbenv/shims"
# conda
export MINICONDA_BIN_PATH="/Users/liziyi/miniconda3/bin"
export MINICONDA_CONDABIN_PATH="/Users/liziyi/miniconda3/condabin"
# Homebrew
export HOMEBREW_BIN_PATH="/opt/homebrew/bin"
export HOMEBREW_SBIN_PATH="/opt/homebrew/sbin"
# Cargo
export CARGO_BIN_PATH="/Users/liziyi/.cargo/bin"
# Go
export GOPATH_BIN_PATH="/Users/liziyi/gopath/bin"
export GOBIN="/Users/liziyi/go/bin"
export TINYGO_BIN_PATH="/tmp/tinygo/bin"
# rbenv bin
export RBENV_BIN_PATH="/.rbenv/bin"
# Ruby 工具链
export RUBY_OPT_BIN_PATH="/usr/local/opt/ruby/bin"
# Ruby gems
export RUBY_GEMS_BIN_PATH="/usr/local/lib/ruby/gems/3.0.0/bin"
# Homebrew Ruby
export HOMEBREW_RUBY_BIN_PATH="/opt/homebrew/opt/ruby/bin"
# 用户本地 bin
export LOCAL_BIN_PATH="/Users/liziyi/.local/bin"
# Maven
export MAVEN_BIN_PATH="/Library/apache-maven-3.5.4/bin"
# Mysql
export MYSQL_BIN_PATH="/usr/local/mysql/bin"

# 将所有路径添加到 PATH 环境变量
export PATH="$MYSQL_BIN_PATH:$GOBIN:$TINYGO_BIN_PATH:$LLVM_PATH:$RUBY_GEM_PATH:$RUBY_RUBIES_PATH:$RUBY_BIN_PATH:$CMAKE_PATH:$RBENV_SHIMS_PATH:$MINICONDA_BIN_PATH:$MINICONDA_CONDABIN_PATH:$HOMEBREW_BIN_PATH:$HOMEBREW_SBIN_PATH:$CARGO_BIN_PATH:$GOPATH_BIN_PATH:$RBENV_BIN_PATH:$RUBY_OPT_BIN_PATH:$RUBY_GEMS_BIN_PATH:$HOMEBREW_RUBY_BIN_PATH:$LOCAL_BIN_PATH:$MAVEN_BIN_PATH:$PATH"
source $ZSH/oh-my-zsh.sh

source <(fzf --zsh)

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/liziyi/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/liziyi/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/Users/liziyi/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/Users/liziyi/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup

# init gitignore
init-git(){
    ~/.oh-my-zsh/init_gitignore.sh
}

# backup my note
backup(){
    ~/.oh-my-zsh/backup_note.sh
}

# push my daily leetcode
push-leetcode(){
    ~/.oh-my-zsh/push_leetcode.sh
}

# git repository greeter
last_repository=
check_directory_for_new_repository() {
 current_repository=$(git rev-parse --show-toplevel 2> /dev/null)

 if [ "$current_repository" ] && \
    [ "$current_repository" != "$last_repository" ]; then
  onefetch
 fi
 last_repository=$current_repository
}
cd() {
 builtin cd "$@"
 check_directory_for_new_repository
}

# optional, greet also when opening shell directly in repository directory
# adds time to startup
check_directory_for_new_repository

## New order written by rust
alias top="btm"
alias ps="procs"
# alias cat="bat"
alias start-redis="brew services start redis"
eval "$(starship init zsh)"
eval "$(zoxide init zsh --cmd j)"

# alias for me
alias mkdir="mkdir -p"
alias cp="cp -i"
alias mv="mv -i"
alias clr="clear"
alias vi="vim"

alias zshconfig="vim ~/.zshrc"

# openmp config
export LDFLAGS="-L/opt/homebrew/opt/libomp/lib"
export CPPFLAGS="-I/opt/homebrew/opt/libomp/include"
export OpenMP_ROOT=$(brew --prefix)/opt/libomp

# pnpm
export PNPM_HOME="/Users/liziyi/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# autoload local commands
autoload -U compinit; compinit

# Added by Windsurf
export PATH="/Users/liziyi/.codeium/windsurf/bin:$PATH"
export GEMINI_API_KEY="AIzaSyCX9nIv3SwZc2AyU_RlZJ5dnetCO9c0EIc"

# Claude Code
export ANTHROPIC_AUTH_TOKEN=sk-Jgvnc6jj4L5A9L9Nw8PW1t5HclQhAjqExMkBiqwD8iherx26
export ANTHROPIC_BASE_URL=https://anyrouter.top
