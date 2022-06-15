export GOPATH=$HOME/go
export PATH=$GOPATH/bin:/usr/local/bin:$PATH:/usr/local/kubebuilder/bin

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

PROMPT_COMMAND='__git_ps1 "\n\e[1;33m\w:\e[0m" "\n\\\$ "'

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

function consul_k8s_dev_docker() {
  pushd $HOME/workspace/consul-k8s
    make control-plane-dev-docker
    tag="$(date "+%m-%d-%Y")-$(git rev-parse --short HEAD)"
    docker tag consul-k8s-control-plane-dev:latest ishustava/consul-k8s-dev:"${tag}"
    echo "Pushing image ishustava/consul-k8s-dev:${tag}"
    docker push ishustava/consul-k8s-dev:"${tag}"
  popd
}

function delcluster() {
  local cluster
  cluster=$1
  kubectl config delete-cluster ${cluster}
  kubectl config delete-context ${cluster}
}

function gbt() {
  local release
  release=$1
  kg secret $1-consul-bootstrap-acl-token -o jsonpath='{.data.token}' | base64 -D
}

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

source "$HOME/.cargo/env"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/irynashustava/Downloads/google-cloud-sdk/path.bash.inc' ]; then . '/Users/irynashustava/Downloads/google-cloud-sdk/path.bash.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/irynashustava/Downloads/google-cloud-sdk/completion.bash.inc' ]; then . '/Users/irynashustava/Downloads/google-cloud-sdk/completion.bash.inc'; fi

export PATH="/usr/local/opt/python@3.8/bin:$PATH"
alias python=/usr/local/opt/python@3.8/bin/python3
export PATH="/usr/local/sbin:$PATH"

