# bash_profile
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
UNDER CONSTRUCTION
