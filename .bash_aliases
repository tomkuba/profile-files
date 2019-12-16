#SSH agent with default key
function ssa() {
      eval $(ssh-agent -s)
      ssh-add ~/.ssh/id_rsa
    }

alias proxy="source ~/.proxy/proxy.sh"
alias noproxy="source ~/.proxy/unset_proxy.sh"

alias change-java="sudo update-alternatives --config java; source ~/.bashrc"
alias nmap='"/mnt/c/Program Files (x86)/Nmap/nmap.exe"'

#git info
__git_color_ps1 () {
  if [ -n "$(__git_ps1)" ]; then
    local IS_CLEAN=`git status | grep -c "working tree clean"`;
    if [ $IS_CLEAN -eq 0 ]; then
      echo -e "\e[1;31m"
      else
      echo -e "\e[1;32m"
    fi
  fi
}

export PS1="\t \[\e]0;\u@\h: \w\a\]${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;36m\]\w\[\033[00m\$(__git_color_ps1)\]\$(__git_ps1)\[\e[0m\] $ "
