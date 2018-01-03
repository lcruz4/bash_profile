if [ -f "${HOME}/.bashrc" ] ; then
  source "${HOME}/.bashrc"
fi

echoOn=1;
name="";
prod="production11";
deleteLocal=1;
ignoreSpaceChanges=1;
commitAll=1;
branchPrefix=0;
logCompareMaster=0;
forcePush=0;

if [ -f "${HOME}/.bash_profile_config" ]; then
  source "${HOME}/.bash_profile_config";
fi

if [ -d .git ]; then
  git gc --auto;
fi

#helper to check if echoOn is set
function print(){
  if (($echoOn)); then
    echo "> $1";
  fi
}

#helper for one liner aliases
function oneLine(){
  print "$*";
  $*;
}

#prune remote and local branches
function clean_branches_fn(){
  print "git fetch -p";
  git fetch -p;
  if (($deleteLocal)); then
    print "delete old local branches";
    git branch -v | grep gone | cut -d \  -f 3 | xargs -n 1 git branch -D 2> /dev/null;
  fi
}

#pull
function pull_fn(){
  print "git pull $*";
  git pull $*;
  clean_branches_fn;
}

#pull a branch while not on that branch
function pull_other_fn(){
  if (($#)); then
    print "git fetch origin $1:$1";
    git fetch origin $1:$1;
  else
    print "git fetch origin master:master";
    git fetch origin master:master;
  fi
  clean_branches_fn;
}

#checkout
function checkout_fn(){
  print "git checkout $*";
  git checkout $*;
}

#diff, options available c for cached n for name only, n number for @~n
function diff_fn(){
  re='^[0-9]+$'
  ignoreSpace="--ignore-space-change ";
  base="";
  cached="";
  nameOnly="";
  redirect=1;
  if ((!$ignoreSpaceChanges)); then
    ignoreSpace="";
  fi
  if [[ $1 =~ $re ]]; then
    base="@~$1 ";
    shift 1;
  fi
  if [ "$1" = "c" ]; then
    shift 1;
    cached="--cached ";
  fi
  if [ "$1" = "n" ]; then
    shift 1;
    nameOnly="--name-only ";
    redirect=0;
  fi

  if (($redirect)); then
    print "git diff --color $cached$nameOnly$ignoreSpace$base$* | less -r";
    git diff --color $cached$nameOnly$ignoreSpace$base$* | less -r;
  else
    print "git diff --color $cached$nameOnly$ignoreSpace$base$*";
    git diff --color $cached$nameOnly$ignoreSpace$base$*;
  fi
}

#commit give message as a string
function commit_fn(){
  all="-a ";
  if ((!$commitAll)); then
    all="";
  fi
  print "git commit $all-m \"$1\"";
  git commit $all-m "$1";
}

#return to master (or production) and delete branch you were on. Also does a pull after
function done_fn(){
  base="master";
  if [ "$1" = "prod" ]; then
    base="$prod";
  fi
  print "git checkout $base";
  git checkout $base;
  print "git branch -D @{-1}";
  git branch -D @{-1};
  pull_fn;
}

#push
function push_fn(){
  branch=$(mybranch);
  prefix=":dev_$name-";
  forcePushFlag="";
  base=$branch;
  re=":";

  if (($branchPrefix)); then
    if [ "$1" = "prod" ]; then
      prefix=":prod_$name-";
      shift 1;
    fi
    base=$branch$prefix$branch
  fi
  if (($forcePush)); then
    forcePushFlag="-f ";
  fi
  if [[ $1 =~ $re ]]; then
    base=$1;
    shift 1;
  fi
  print "git push $forcePushFlag-u $* origin $base";
  git push $forcePushFlag-u $* origin $base;
}

#stash
function stash_fn(){
  print "git stash $*";
  git stash $*;
}

#branch
function branch_fn(){
  print "git branch --sort=-committerdate -v $*";
  git branch --sort=-committerdate -v $*;
}

#log
function log_fancy_fn() {
  re='\.\.';
  base="master..@";
  i=$((COLUMNS-53));
  fancyArgs=(--graph --date=relative --pretty=format:"%<|(20)%C(yellow)%h %C(bold)%Cgreen%<(15,trunc)%an %Creset%C(magenta)%<(15,trunc)%ad %Creset%<($i,trunc)%s");
  if ((!$logCompareMaster)); then
    base="";
  fi

  if [ "$1" = "prod" ]; then
    base="$prod..@";
    shift 1;
  else if [ "$1" = "master" ]; then
    base="master..@";
    shift 1;
  else if [[ $1 =~ $re ]]; then
    base="";
  fi fi fi

  print "git log --graph --date=relative --pretty=format:{tedious format string} $* $base";
  git log "${fancyArgs[@]}" $* $base;
}

#reset
function revert_fn(){
  re='^[0-9]+$';
  hard="";
  if [ "$1" = "h" ]; then
    hard="--hard ";
    shift 1;
  fi

  if [[ $1 =~ $re ]]; then
    num=$1;
    shift 1;
    print "git reset $hard$* @~$num";
    git reset $hard$* @~$num;
  else
    print "git reset $hard$*";
    git reset $hard$*;
  fi
}

#reset hard
function fpull_fn(){
  revert_fn h $*;
}

#commit with amend flag if no message is given previous commit on head is used
function amend_fn(){
  all="-a ";
  if ((!$commitAll)); then
    all="";
  fi
  if (($#)); then
    print "git commit --amend $all-m \"$1\""
    git commit --amend $all-m "$1";
  else
    print "git commit --amend $all-C @";
    git commit --amend $all-C @;
  fi
}

#cherry-pick
function cherry_fn(){
  print "git cherry-pick $*";
  git cherry-pick $*;
}

#rebase
function rebase_fn(){
  if [ "$1" = "prod" ]; then
    print "git rebase $prod";
    git rebase $prod;
  else if (($#)); then
    print "git rebase $*";
    git rebase $*;
  else
    print "git rebase master";
    git rebase master;
  fi fi
}

# create a branch off master (or production) regardless of the branch you're on
function start_fn(){
  base="master";
  if [ "$1" = "prod" ]; then
    base="$prod";
    shift 1;
  fi

  print "git branch $1 $base";
  git branch $1 $base;
  print "git checkout $1";
  git checkout $1;
}

#merge
function merge_fn(){
  print "git merge $* --no-edit";
  git merge $* --no-edit;
}

#add git add . by default
function add_fn(){
  if (($#)); then
    print "git add $*";
    git add $*;
  else
    print "git add .";
    git add .;
  fi
}

#completion func for branches. Only uses local branches, excludes current branch
func() {
  local cur=${COMP_WORDS[COMP_CWORD]}
  COMPREPLY=( $(compgen -W "$(git branch | grep -v \*)" -- $cur) )
}

function edit_fn(){
  if command -v code > /dev/null; then
    code $1;
  else
    "${EDITOR:-vim}" $1;
  fi
}

alias done=done_fn
alias ga=amend_fn
alias gad=add_fn
alias gb=branch_fn
alias gbc=clean_branches_fn
alias gbu='oneLine git branch --unset-upstream'
alias gci=commit_fn
alias gcl='oneLine git clean -fd;'
alias gco=checkout_fn
alias gcp=cherry_fn
alias gca='oneLine git cherry-pick --abort'
alias gcc='oneLine git cherry-pick --continue'
alias gd=diff_fn
alias gl=log_fancy_fn
alias gpl=pull_fn
alias gpo=pull_other_fn
alias gps=push_fn
alias grb=rebase_fn
alias gra='oneLine git rebase --abort'
alias grc='oneLine git rebase --continue'
alias grh=fpull_fn
alias grs=revert_fn
alias gsh=stash_fn
alias gst='oneLine git status --short'
alias gm=merge_fn
alias gma='oneLine git merge --abort'
alias gmc='oneLine git merge --continue'
alias master='oneLine git checkout master'
alias mybranch='git rev-parse --abbrev-ref HEAD;'
alias prod='oneLine git checkout $prod'

alias web='cd /c/Development/Storm/code/client/DeltekNavigator/Web/'
alias storm='cd /c/Development/Storm/'
alias src='cd /c/Development/Storm/code/client/DeltekNavigator/Web/src/'
alias start=start_fn
alias edit='edit_fn ~/.bash_profile'
alias config='edit_fn ~/.bash_profile_config'
alias bp='. ~/.bash_profile'

complete -F func gco
complete -F func gb -D
complete -F func gpo
complete -F func gl
