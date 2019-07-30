1. [Bash Profile](#bash-profile)
2. [Installation Instructions](#installation-instructions)
3. [More about this project](#more-about-this-project)
4. [Config](#config)
5. [Commands](#commands)

# Bash Profile
Bash profile with shortcuts for common git commands

This project is built such that it won't mess with your bash_profile if you don't want to overwrite it, and you will still be able to add code to your bash_profile without messing with the project. You will also be able to pull updates without messing with your code in .bash_profile. This project also prints out every git command it is running so you don't have to worry about having to look at the code to see what is actually being done.

# Installation Instructions
Since .bash_profile should be in your home directory it will not be empty, so this is not like cloning a regular repo.
Do sub steps if you already have a .bash_profile and want to keep it. Otherwise rm .bash_profile and skip sub steps

1. cd ~
2. git init
3. git remote add origin https://github.com/lcruz4/bash_profile.git
4. git fetch
    * if you want to keep your existing .bash_profile
    1. mv .bash_profile .bash_profile_bak
5. git checkout master
    * if you want to keep your existing .bash_profile
    1. touch .bash_merge
    2. git merge-file --union .bash_profile .bash_merge .bash_profile_bak
    3. open .bash_profile and make sure that this code is at the top and that your existing old .bash_profile code is under it
        ```
        #!/bin/bash
        if [ -f "${HOME}/.bash_profile_lcruz" ] ; then
            source "${HOME}/.bash_profile_lcruz"
        fi
        ```
    4. rm .bash_merge .bash_profile_bak
6. . .bash_profile (that is dot space .bash_profile)

# More about this project
Your .bash_profile now sources .bash_profile_lcruz. This is where all of my code lives, and any of it can be overriden in bash_profile by redefining the function/aliases in .bash_profile_lcruz. Also note that this project also has a config to allow some options to be set. this is the .bash_profile_config. All options are included so if you want to change anything just uncomment it and change the value. All of these configs take a value of 1 or 0 for true or false.

If you have a production branch set in the config some commands will take 'prod' as the first argument to indicate that you want to perform that action in the context of your production branch not master.

# Config
* [echoOn](#echoon)
* [deleteLocal](#deletelocal)
* [ignoreSpaceChanges](#ignorespacechanges)
* [commitAll](#commitall)
* [logCompareMaster](#logcomparemaster)
* [branchPrefix](#branchprefix)
* [forcePush](#forcepush)
* [maxSearchDepth](#maxsearchdepth)
* [name](#name)
* [prod](#prod)
* [devDir](#devdir)

This is the default config
```
#1 is true, 0 is false

#defaults, uncomment and before changing
#echoOn=1; #echo commands to stdout prepended with a '> ' i.e. "> git pull"
#deleteLocal=1; #prune local branches if removed from remote
#ignoreSpaceChanges=1; #diff ignores space changes
#commitAll=1; #use -a for commit commands
#logCompareMaster=0; #gl command assumes you want to compare against master
#branchPrefix=0; #remote branches are prefixed with dev_'name' or prod_'name'
#forcePush=0; #use -f for push commands
#maxSearchDepth=10; #how many directories in should go search before giving up

name="luis"; #used in push commands if branchPrefix=1;
prod="production11"; #variable that stores name of production branch
devDir="/c/dev"; #dev directory for used for go command (don't add / to end)
```
### echoOn
I recommend you leave this on until you've become very familiar with all the commands as it shows you what git commands are being run. They will be printed out with a '> ' in front so you can differentiate them from git output.
### deleteLocal
The push alias gps will automatically set upstream branches, so when the upstream branch is gone we will know this and delete any local branches that correspond to them. This will happen on a gpl or gpo. If you don't like this turn it off.
### ignoreSpaceChanges
The diff alias git diff will ignore space changes.
### commitAll
The commit and commit --amend aliases gci and ga will include the -a flag by default. If you prefer to add stuff yourself (gad) turn this off.
### logCompareMaster
This setting is off by default. The log alias gl will compare against master by default if this setting is on. Also note that even if this setting is on you can indicate what you want to compare i.e. notMaster..@, however you will not be able to indicate that you don't want to compare against anything.
### branchPrefix
This setting is off by default. The push alias gps will prepend dev_(name)- before a branch when pushing to your remote. I.E. assuming your name is bob if you name a branch feat-fix and then do a gps then your remote branch will be dev_bob-feat-fix. Your local branch name will remain as it is.
### forcePush
This setting is off by default. The push alias will include the -f flag by default. This is useful if you amend and rebase a lot. This is a bad idea if you're pushing to a branch that you expect will be pulled down by someone other than yourself. If you don't know why google it.
### maxSearchDepth
The go command (sorry go devs) will take you to a directory that lives within your devDir. This command uses a grep and this setting indicates how far it should search before giving up. This setting is still experimental so you may run into issues, specially if you have multiple directories in the same depth level.
### name
The push alias gps will prepend dev_(name)- before a branch if you have branchPrefix turned on. This setting is how you can edit your name.
### prod
If you want to take advantage of some commands that can assume either the master branch or a production branch set this setting to indicate which branch is your production branch. Some settings such as gl will take prod as their first argument. Therefor gl prod will give you a log comparing your head to your production branch.
### devDir
If you want to use the go command set your devDir. I also plan on adding code to immediately change to your dev directory when sourcing your bash_profile (and maybe running a git gc --auto if it's a git directory) in the future.

# Commands
* [gpl](#gpl)
* [gpo](#gpo)
* [gbc](#gbc)
* [gst](#gst)
* [gco](#gco)
* [gd](#gd)
* [gl](#gl)
* [gad](#gad)
* [gci](#gci)
* [ga](#ga)
* [gps](#gps)
* [edit](#edit)
* [config](#config)
* [bp](#bp)
* [start](#start)
* [fin](#fin)
* [gb](#gb)
* [grb](#grb)
* [gra grc](#gra-grc)
* [gm](#gm)
* [gma gmc](#gma-gmc)
* [gcp](#gcp)
* [gca gcc](#gca-gcc)
* [grs](#grs)
* [grh](#grh)
* [gsh](#gsh)
* [gbu](#gbu)
* [gcl](#gcl)
* [master](#master)
* [prod](#prod)
* [go](#go)

Note that many commands will pass along any extra arguments you give to the git command it runs. For example gd is the git diff command, if you want to get filenames only then `gd --name-only` will work.
### gpl
This is the `git pull` command. It also calls gbc.
### gpo
Stands for git pull other. It will update a branch you're not on without going to that branch. I.e. if you're in a feature branch `gpo production` will pull updates from origin/production into production. If no branch is provided master is assumed. So gpo is very useful if you want to update and don't want to go to master.
### gbc
This is not meant to be called directly because gpl and gpo both call it.

This was supposed to stand for `git gc` (garbage collect), but it doesn't do that anymore. I may redo this one. For now it does a `git fetch -p` so it prunes your old remote branches. If deleteLocal is on it will check your local branches and if any are gone (the upstream branch has been deleted), it will delete the local branch as well.
### gst
Runs `git status --short`. You may not be used to the short output, but it's clearly superior.
### gco
This is the `git checkout` command.
### gd
This is the `git diff` command.

It will ignore whitespace depending on the ignoreSpaceChanges (on by default).

This command will pipe output to less so that output doesn't fill up your console unless the n flag is given.

This supports a few options.
* If a number is given the diff will run against that commits back. This is useful if you want to see git diff after you've commited, simply `gd 1`. If you got multiple commits you want to include `gd 2` and so on.
* `c` this option adds the --cached flag in case you've staged your changes already.
* `n` this option adds the --name-only flag, and prevents output to less (since this usually produces a short output).
### gl
This is the `git log` command.

If logCompareMaster is on (off by default) git log will compare against master. If you don't know why this is useful I suggest you turn it on, as this extremely useful for git beginners and this is one of the commands along with gst that you should be running all the time.

The format for this command is real fancy. It's similary to oneline but with more information, and it adjusts to the size of your window so it doesn't wrap (if the graph is huge it may wrap).

This supports a few options.
* `prod` compare agains your production branch instead of master.
* `master` even if you have logCompareMaster off you can give this option to do it anyway.
* If a number is given as an argument it will do the same thing gd does. It will compare with that many commits back. So `gl 4` will show you the last 4 commits.
* If your argument has a '..' in it then it will override comparing against master and just pass your comparison argument as it is. If you don't know this syntax I recommend that you learn it. It is very powerful.
### gad
This is the `git add` command.

If no arguments are given it will run `git add .` (adds everything).
### gci
This is the `git commit` command.

The -a flag is added if commitAll is on (default).

Note this command requires a message. So make sure to call like this `gci "commit message"`.
### ga
Stands for git commit --amend. If commitAll is on (default) the -a flag will be used. If a message is provided (`ga "message"`) then the message of the commit will be overwritten. Otherwise if no message is given (`ga`) the existing message will be reused.
### gps
This is the `git push` command.

The -u flag is used to set-upstream (this is needed for the deleteLocal setting to work).

If forcePush is on (off by default) the -f flag is added. This is useful if you ever amend or rebase, because if git doesn't agree that your changes are a simple update it will not update your branch unless you add the -f flag. Think when programs asks 'are you sure you want to overwrite?', this setting tells it yes always.

If branchPrefix (off by default) is on then your branch name will be prepended with dev_yourname- so that your remote branch will be something like dev_bob-some-feat. If you give the prod argument it will prepend prod_yourname- (see update) instead.
If you ever give an argument that contains a ':' it will use that instead. So this is a way to overide branchPrefix, and also it allows you to delete branches if it's on.

Update: instead of accepting prod as a parameter this command now takes any alphanumeric argument (without a : in it) and uses that as the prefix. I.e. if you want to do gps feat it will prepend feat_yourname-. This still only applies if branchPrefix is on and the default is still dev.
### edit
With no args this will open your bash_profile file in your editor. If it opens it in vim (and you don't want it to). Add `export EDITOR='yourEditor'` to the end of your bash_profile and run bp.
If you want to see the code for all the commands mentioned here run `edit lcruz`
### config
Same as edit but for the bash_profile_config
### bp
Stands for bash profile. This command sources your bash profile so you don't have to close and restart your bash when making changes.
### start
This command will create a new branch off of master (you don't need to be on master) and go to the new branch.

If you give the prod argument it will create one off of your production branch.
### fin
Stands for finished. This command will checkout master then delete the last branch you were on. Then it will run gpl to update master. You can call `fin prod` if you want it to go to and update your production branch instead of master.
### gb
This is the `git branch` command.
### grb
This is the `git rebase` command.
* If prod is given as an argument it will rebase against your production branch.
* If anything other than prod is given it will rebase against that.
* If no argument is given it will rebase against master.
### gra grc
The grb command can cause a merge conflict.

Use gra to abort and go back to the state before the conflict.

Use grc to continue with the rebase.
### gm
This is the `git merge` command.

It uses the --no-edit flag.
### gma gmc
The gm command can cause a merge conflict.

Use gma to abort and go back to the state before the conflict.

Use gmc to continue after adding (gad) your resolution to the conflicts.
### gcp
This is the `git cherry-pick` command.
### gca gcc
The gcp command can cause a merge conflict.

Use gca to abort and go back to the state before the conflict.

Use gcc to continue after adding (gad) your resolution to the conflicts.
### grs
This is the `git reset` command.

If you give a number as an argument it does the same thing gd and gl do. It will reset to that many commits back. For example if I have 4 commits in my feature branch and I want to do a de facto squash, I can just run grs 4 followed by a gci "new commit message".

If a number is not given it will just reset to whatever you give it
### grh
This is like grs but it will add the --hard flag. Be careful! If you run git reset --hard when you have unstaged changes you will not be able to get them back.
### gsh
This is the `git stash` command.
### gbu
This command unsets your upstream branch.

Note deleteLocal doesn't work if your branches don't have an upstream.
### gcl
Runs `git clean -fd`. Useful if you want to undo untracked changes.
### master
This is a shortcut for `gco master`.
### prod
This is a shortcut for `gco` with your production branch.
### go
Experimental.

Will try to cd to a directory you provide.

It starts searching in your devDir and does a breadth first search using multiple greps. It will give up after maxSearchDepth levels. If two dirs with the same name exist in the same level it will crap out, sorry.
