export GOPATH=$HOME/go
export PATH=/usr/local/bin:$PATH:$GOPATH/bin

GIT_PS1_SHOWDIRTYSTATE=1
GIT_PS1_SHOWUPSTREAM="verbose"
GIT_PS1_SHOWUNTRACKEDFILES=1
GIT_PS1_DESCRIBE_STYLE='contains'
GIT_PS1_SHOWCOLORHINTS=1

bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'

source ~/.git-prompt.sh
source /usr/local/etc/bash_completion.d/git-completion.bash
source /usr/local/opt/chruby/share/chruby/chruby.sh

PROMPT_COMMAND='__git_ps1 "\n\e[1;37m\W:\e[0m" "\n\\\$ "'

alias ll='ls -ltro'

function un() {
	lpass show -F $1 --username --clip
}

function pw() {
	lpass show -F $1 --password --clip
}

export GPG_TTY=$(tty)

# fasd
fasd_cache="$HOME/.fasd-init-bash"

if [ "$(command -v fasd)" -nt "$fasd_cache" -o ! -s "$fasd_cache" ]; then
  fasd --init posix-alias bash-hook bash-ccomp bash-ccomp-install >| "$fasd_cache"
fi

source "$fasd_cache"
