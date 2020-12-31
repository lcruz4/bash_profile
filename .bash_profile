#!/bin/bash
if [ -f "${HOME}/.bash_profile_lcruz" ] ; then
  source "${HOME}/.bash_profile_lcruz"
fi

export PS1='\[\033[32m\]\u:\[\033[33m\]\w\[\033[36m\]`__git_ps1` \[\033[00m\]\$ '

alias ws='ssh -p 6116 pi@luiscruzgmu.com';
alias die='TASKKILL //F //IM node.exe;';
alias gdt='git difftool';
alias gmt='git mergetool';
alias grl='git reflog';

alias vp='cd /c/Development/Vantagepoint'
alias vp20='cd /c/Development/Vantagepoint20'
alias vp30='cd /c/Development/Vantagepoint30'
alias vp35='cd /c/Development/Vantagepoint35'

function hb(){
  local branch="master";

  if [[ $PWD == *"Storm"* ]]; then
    branch="production11";
  else if [[ $PWD == *"Vantagepoint20"* ]]; then
    branch="releases/production20";
  fi fi;

  echo $branch;
}

function home(){
  gco $(hb);
}

function web(){
  local mainDir="Vantagepoint";

  if [[ $PWD == *"Vantagepoint20"* ]]; then
    mainDir="Vantagepoint20"
  fi;

  cd /c/Development/$mainDir/code/client/DeltekNavigator/Web
}

function bld(){
  local mainDir="Vantagepoint";

  if [[ $PWD == *"Vantagepoint20"* ]]; then
    mainDir="Vantagepoint20"
  elif [[ $PWD == *"Vantagepoint30"* ]]; then
    mainDir="Vantagepoint30"
  elif [[ $PWD == *"Vantagepoint35"* ]]; then
    mainDir="Vantagepoint35"
  fi;

  START //D "C:\\Development\\$mainDir\\code\\client\\DeltekNavigator\\Web\\" "cmd.exe" //C npm run watch-no-lint;
}

function tst(){
  local mainDir="Vantagepoint";

  if [[ $PWD == *"Vantagepoint20"* ]]; then
    mainDir="Vantagepoint20"
  elif [[ $PWD == *"Vantagepoint30"* ]]; then
    mainDir="Vantagepoint30"
  elif [[ $PWD == *"Vantagepoint35"* ]]; then
    mainDir="Vantagepoint35"
  fi;

  if [[ "$1" = "all" ]]; then
    START //D "C:\\Development\\$mainDir\\code\\client\\DeltekNavigator\\Web\\" "cmd.exe" //C npm run test:chrome
  else
    START //D "C:\\Development\\$mainDir\\code\\client\\DeltekNavigator\\Web\\" "cmd.exe" //C npm run test:chrome -- --file=tests/$1
  fi
}

function vbld(){
  local mainDir="Vantagepoint";
  local restore=0;
  local basePath;
  local path;
  local colorOpt;

  if [ "$1" = "restore" ]; then
    restore=1;
    shift 1;
  fi

  if [[ $PWD == *"Storm"* ]]; then
    basePath="/c/Development/Vision/production/DPS11/";
    path=$basePath"VB/$1/Server";

    if [ "$1" = "VisionServices" ]; then
      path=$basePath"VisionServices/Server";
      shift 1;
    else if [ "$1" = "DeltekNavigator" ]; then
      basePath="/c/Development/Storm/code/";
    else if [ "$1" = "Reporting" ]; then
      basePath="/c/Development/Storm/code/";
    fi fi fi;
  else
    if [[ $PWD == *"Vantagepoint20"* ]]; then
      mainDir="Vantagepoint20";
    fi;
      basePath="/c/Development/$mainDir/code/";
      path=$basePath"server/VB/$1/Server";
  fi;

  if [ "$1" = "VisionServices" ]; then
    path=$basePath"server/VisionServices/Server";
  else if [ "$1" = "DeltekNavigator" ]; then
    path=$basePath"client/DeltekNavigator"
  else if [ "$1" = "Reporting" ]; then
    path=$basePath"client/Reporting"
  fi fi fi;
  if [ "$TERM" != "cygwin" ]; then
    colorOpt=//clp:ForceConsoleColor;
  fi;

  if (($restore)); then
    echo "restoring nuget packages for" "$path";
    "/c/Development/MyStuff/nuget.exe" restore "$path";
  fi

  print "Building" "$path";
  "/c/Program Files (x86)/Microsoft Visual Studio/2019/Professional/MSBuild/Current/Bin/MSBuild.exe" $colorOpt "$path";
}

function rds(){
  local mainDir="Vantagepoint";
  local script="DVP-DeveloperUpdate.cmd";

  if [[ $PWD == *"Vantagepoint20"* ]]; then
    mainDir="Vantagepoint20"
  elif [[ $PWD == *"Vantagepoint30"* ]]; then
    mainDir="Vantagepoint30"
  elif [[ $PWD == *"Vantagepoint35"* ]]; then
    mainDir="Vantagepoint35"
  fi;

  if [[ -f "/c/Development/Vantagepoint/tools/scripts/$1" ]]; then
    script="$1";
  elif [[ -f "/c/Development/Vantagepoint/tools/scripts/$1.cmd" ]]; then
    script="$1.cmd";
  elif [[ -f "/c/Development/Vantagepoint/tools/scripts/DVP-$1.cmd" ]]; then
    script="DVP-$1.cmd";
  elif [[ "$1" == "LocalUpdate" ]]; then
    script="DVP-DeveloperUpdate-LocalSS.cmd";
  fi

  print "Running $script";
  START //D "C:\\Development\\$mainDir\\tools\\scripts\\" $script
}

function completeVbld(){
  local cur=${COMP_WORDS[COMP_CWORD]};
  local path="/c/Development/Vantagepoint/code/server/VB/";

  if [[ $PWD == *"Storm"* ]]; then
    path="/c/Development/Vision/production/DPS11/VB/";
  else if [[ $PWD == *"Vantagepoint20"* ]]; then
    path="/c/Development/Vantagepoint20/code/server/VB/";
  fi fi;

  COMPREPLY=( $(compgen -W "$(/bin/ls $path) DeltekNavigator Reporting VisionServices" -- $cur) )
}

function completeRds(){
  local cur=${COMP_WORDS[COMP_CWORD]};
  local scripts=$(/bin/ls /c/Development/Vantagepoint/tools/scripts/ | grep cmd | cut -d - -f 2- | cut -d . -f 1);

  COMPREPLY=( $(compgen -W "$scripts LocalUpdate" -- $cur) )
}

complete -F completeVbld vbld;
complete -F completeRds rds;

if [ $PWD = "/" ]; then
  cd "/c/Development/Vantagepoint"
fi;
git prune;