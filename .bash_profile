if [ -f "${HOME}/.bashrc" ] ; then
  source "${HOME}/.bashrc"
fi

#git gc;

function clean_branches_fn(){
  git fetch -p;
  gb | grep gone | cut -d \  -f 3 | xargs -n 1 git branch -D 2> /dev/null;
}

function pull_fn(){
  if [ "$1" = "m" ]; then
    $(stopsublime);
    git checkout master;
    git pull;
    git checkout -;
    git rebase master;
    $(startsublime) &

  else if [ "$1" = "om" ]; then
    git pull origin master;
  else
    git pull;
  fi fi
  $(clean_branches_fn)
}

function pull_other_fn(){
  if (($#)); then
    git fetch origin $1:$1;
  else
    git fetch origin master:master;
  fi
  $(clean_branches_fn)
}

function checkout_fn(){
  re='^[0-9]+$'
  if [[ $1 =~ $re ]]; then
    git checkout @{-$1};
  else if [ "$1" = "u" ]; then
    git stash;
    git checkout $2;
    git stash pop;
  else
    git checkout $*;
  fi fi
}

function diff_fn(){
  re='^[0-9]+$'
  if [[ $1 =~ $re ]]; then
    git diff --color --ignore-space-change HEAD~$* | less -r;
  else if [ "$1" = "c" ]; then
    git diff --cached --color --ignore-space-change $2 | less -r;
  else
    git diff --color --ignore-space-change $* | less -r;
  fi fi
}

function commit_fn(){
  git commit -am "$1";
}

function done_fn(){
  base="master";
  if [ "$1" = "prod" ]; then
    base="production11";
  fi
  git checkout $base;
  git branch -D @{-1};
  $(gpl);
}

function push_fn(){
  branch=$(mybranch)
  prefix=":dev_luis-"
  del=$1

  if [ "$1" = "n" ]; then
    prefix=":"
    del=$2
  else if [ "$1" = "prod" ]; then
    prefix=":prod_luis-"
    del=$2
  fi fi

  git push -fu origin $branch$prefix$branch;

  if [ "$del" = "d" ]; then
    $(done);
  fi
}

function stash_fn(){
  git stash $*;
}

function branch_fn(){
  git branch --sort=-committerdate -v $*;
}

function _log(){
  re='\.\.'
  base="master";
  branch="..@";
  fancy="--graph --oneline";
  fancyIndicator=$1;
  shift 1;

  if [ "$1" = "prod" ]; then
    base="production11";
    shift 1;
  else if [[ $1 =~ $re ]]; then
    base="";
    branch=$1;
    shift ;
  fi fi

  if [ "$fancyIndicator" -eq "1" ]; then
    git log $* $fancy $base$branch;
  else
    git log $* $base$branch;
  fi
}

function log_fn(){
  _log 0 $*;
}

function log_fancy_fn() {
  _log 1 $*;
}

function revert_fn(){
  git reset HEAD~$1;
}

function fpull_fn(){
  git reset --hard $*;
}

function amend_fn(){
  if (($#)); then
    git commit --amend -am "$1";
  else
    git commit --amend -aC @;
  fi
}

function patch_fn(){
  git add -p;
  if [ "$1" = "a" ]; then
    git commit --amend -m "$2";
  else
    git commit -m "$1"
  fi
}

function cherry_fn(){
  git cherry-pick $1;
}

function rebase_fn(){
  if [ "$1" = "prod" ]; then
    git rebase production11;
  else if (($#)); then
    git rebase $1;
  else
    git rebase master;
  fi fi
}


function start_fn(){
  sha='^[0-9a-f]+$';
  stash=0;
  cherry="";
  commitMessage="";
  push="";
  base="master";
  if [ "$1" = "prod" ]; then
    base="production11";
    if [ "$2" = "u" ]; then
      stash=1;
      git stash;
      if [[ $3 =~ $sha ]]; then
        cherry=$3;
        branchName=$4;
        commitMessage=$5;
        push=$6;
      else
        branchName=$3;
        commitMessage=$4;
        push=$5;
      fi
    else if [[ $2 =~ $sha ]]; then
      cherry=$2;
      branchName=$3;
      commitMessage=$4;
      push=$5;
    else
      branchName=$2;
      commitMessage=$3;
      push=$4;
    fi fi
  else if [ "$1" = "u" ]; then
    stash=1;
    git stash;
    if [[ $2 =~ $sha ]]; then
      cherry=$2;
      branchName=$3;
      commitMessage=$4;
      push=$5;
    else
      branchName=$2;
      commitMessage=$3;
      push=$4;
    fi
  else if [[ $1 =~ $sha ]]; then
    cherry=$1;
    branchName=$2;
    commitMessage=$3;
    push=$4;
  else
    branchName=$1;
    commitMessage=$2;
    push=$3;
  fi fi fi

  git branch $branchName $base;
  git checkout $branchName;

  if [ "$cherry" != "" ]; then
    git cherry-pick $cherry;
  fi

  if (($stash)); then
    git stash pop;
  fi

  if [ "$commitMessage" != "" ]; then
    git commit -am "$commitMessage";
  fi

  if [ "$push" = "p" ]; then
    gps;
  fi
}

function merge_fn(){
  git merge $* --no-edit;
}

function add_fn(){
  if (($#)); then
    git add $*;
  else
    git add .;
  fi
}

function switch_fn(){
  echo "$1" | sed 's/\\/\//g';
}

function test_fn(){
  npm run test -- --tag $*;
}

func() {
  local cur=${COMP_WORDS[COMP_CWORD]}
  COMPREPLY=( $(compgen -W "$(git branch | grep -v \*)" -- $cur) )
}

alias done=done_fn
alias ga=amend_fn
alias gad=add_fn
alias gb=branch_fn
alias gbc=clean_branches_fn
alias gbu='git branch --unset-upstream'
alias gci=commit_fn
alias gcl='git clean -fd;'
alias gco=checkout_fn
alias gcp=cherry_fn
alias gd=diff_fn
alias gl=log_fancy_fn
alias gls='git ls-files'
alias gpa=patch_fn
alias gpl=pull_fn
alias gpo=pull_other_fn
alias gps=push_fn
alias grb=rebase_fn
alias gra='git rebase --abort'
alias grc='git rebase --continue'
alias grh=fpull_fn
alias grp='git reset --patch'
alias grs=revert_fn
alias gsh=stash_fn
alias gst='git status --short'
alias gm=merge_fn
alias gma='git merge --abort'
alias gmc='git merge --continue'
alias gmt='git mergetool'
alias master='gco master'
alias mybranch='git rev-parse --abbrev-ref HEAD;'
alias prod='gco prod'

alias web='cd /c/Development/Storm/code/client/DeltekNavigator/Web/'
alias storm='cd /c/Development/Storm/'
alias stealformat='cd /c/Users/luiscruz/.vscode/extensions/steal-format/'
alias src='cd /c/Development/Storm/code/client/DeltekNavigator/Web/src/'
alias startsublime='C:/Program\ Files/Sublime\ Text\ 3/sublime_text.exe'
alias start=start_fn
alias stopsublime='TASKKILL -IM sublime_text.exe > /dev/null'
alias sw=switch_fn
alias qe='cd /c/Development/QEAutomation/Products/DeltekPS'
alias edit='vim ~/.bash_profile'
alias bp='. ~/.bash_profile'
alias test=test_fn

alias H='HEAD'

complete -F func gco
complete -F func gb -D
complete -F func gpm
complete -F func gl
