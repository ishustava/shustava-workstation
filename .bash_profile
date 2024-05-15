export GOPATH=$HOME/go
export PATH=$GOPATH/bin:/usr/local/bin:$PATH:/usr/local/kubebuilder/bin

bindkey '^[[A' history-search-backward
bindkey '^[[B' history-search-forward

source /opt/homebrew/share/zsh/site-functions

alias ll='ls -ltrao'
alias k='kubectl'
alias kaf='k apply -f'
alias kdel='k delete'
alias kdelf='kdel -f'
alias kdesc='k describe'
alias kg='k get'
alias kga='kg all'
alias kgp='kg po'
alias kgs='kg svc'
alias kgpy='kgp -oyaml'
alias kgy='kg -oyaml'
alias kl='k logs'
alias klf='kl -f'
alias kv='k version'
alias kx='k exec -it'

function krun() {
  k run --generator=run-pod/v1 -it foo-"$(date +%s | shasum -a256 | head -c 16)" --image="${1}" -- "${2}"
}

function kgpw() {
  watch kubectl get pods
}

function kgpwa() {
  watch kubectl get pods -A
}

function klean() {
  kgp | grep foo | cut -d' ' -f1 | xargs -I{} kubectl delete po/{}
}


function helmdel() {
  local release
  release=$1

  local namespace
  namespace=$2

  helm del ${release} -n $namespace
  kdel pvc -l "release=${release}" -n $namespace
  kg secret -n $namespace | grep $1- | cut -d' ' -f1 | xargs -I{} kubectl delete secret {} -n $namespace
}

function delcluster() {
  local cluster
  cluster=$1
  kubectl config delete-cluster ${cluster}
  kubectl config delete-context ${cluster}
}

function un() {
	lpass show -F $1 --username --clip
}

function pw() {
	lpass show -F $1 --password --clip
}

export GPG_TTY=$(tty)

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/irynashustava/Downloads/google-cloud-sdk/path.bash.inc' ]; then . '/Users/irynashustava/Downloads/google-cloud-sdk/path.bash.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/irynashustava/Downloads/google-cloud-sdk/completion.bash.inc' ]; then . '/Users/irynashustava/Downloads/google-cloud-sdk/completion.bash.inc'; fi

export PATH="/usr/local/opt/python@3.8/bin:$PATH"
alias python=/usr/local/opt/python@3.8/bin/python3
export PATH="/usr/local/sbin:$PATH"

eval "$(/opt/homebrew/bin/brew shellenv)"
eval "$(fasd --init posix-alias zsh-hook)"

if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh-completions:$FPATH

  autoload -Uz compinit
  compinit
fi

