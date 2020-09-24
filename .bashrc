# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# User specific aliases and functions
HISTTIMEFORMAT="%d/%m/%y %T "

alias fixsep="sed -r $'s/\x01/|/g' "

# Overides
alias ps='ps -auxf'
alias free='free -hmt'
alias dfTotal='df -Tha --total'
alias duUsed='du -ach | sort -h'
alias topcpu="top -b -o +%CPU |head -17"
alias topmem="top -b -o +%MEM | head -17"
alias cpu="grep 'cpu ' /proc/stat | awk '{usage=(\$2+\$4)*100/(\$2+\$4+\$5)} END {print usage}' | awk '{printf(\"%.1f\n\", \$1)}'"
alias countfiles="for t in files links directories; do echo \`find . -type \${t:0:1} | wc -l\` \$t; done 2> /dev/null"
alias ipview="netstat -anpl | grep :80 | awk {'print \$5'} | cut -d\":\" -f1 | sort | uniq -c | sort -n | sed -e 's/^ *//' -e 's/ *\$//'"
alias openports='netstat -nape --inet'
alias compress='tar -cvf'

# Directory Lists
alias l='ls -ltr'
alias la='ls -ltra'
alias ls='ls -aFh --color=always' # add colors and file type extensions
alias lx='ls -lXBh' # sort by extension
alias lk='ls -lSrh' # sort by size
alias lc='ls -lcrh' # sort by change time
alias lu='ls -lurh' # sort by access time
alias lr='ls -lRh' # recursive ls
alias lt='ls -ltrh' # sort by date
alias lm='ls -alh |more' # pipe through 'more'
alias lw='ls -xAh' # wide listing format
alias ll='ls -Fls' # long listing format
alias labc='ls -lap' #alphabetical sort
alias lf="ls -l | egrep -v '^d'" # files only
alias ldir="ls -l | egrep '^d'" # directories only

# Copy & move commands
alias cp='cp -rv'
alias wget='wget -c'

# Alias some common chmod amounts
alias mx='chmod a+x'
alias 000='chmod -R 000'
alias 644='chmod -R 644'
alias 666='chmod -R 666'
alias 755='chmod -R 755'
alias 777='chmod -R 777'

alias back='cd "$OLDPWD"'
alias home='cd /home/${USER}'
alias disk='du -a | sort -n -r | more'
alias diskspace="du -S | sort -n -r | more"
alias folders='du -h --max-depth=1'
alias folderssort='find . -maxdepth 1 -type d -print0 | xargs -0 du -sk | sort -rn'
alias tree='tree -CAhF --dirsfirst'
alias treed='tree -CAFd'
alias mountedinfo='df -hT'
alias appStarted='grep -i logFileAppStart *.log'
alias appsStarted='grep -i logFileAppStart *.log.*'
alias hardware=' clear; hostname; echo ""; echo "CPUs Info"; lscpu | grep "CPU(s):" | head -n1; cat /proc/cpuinfo | grep "cpu cores" | tail -n1 ; lscpu | grep Arch; cat /proc/cpuinfo | grep "model name" | tail -n1 ; echo ""; echo "MEM Info" ; cat /proc/meminfo | grep MemTotal; echo ""; echo "Disk Info"; df -h; echo ""; echo "INodes"; df -ih; echo "" ; echo "O/S Info"; cat /etc/redhat-release; echo "Uptime"; uptime; echo "";'

# App Path Settings
appPath=""
case ${host} in
  (host1) appPath=/home/${USER}/tools ;;
  (*) appPath=/home/${USER} ;;
esac
alias app='cd ${appPath}'

function up () {
  local d=""
  limit=$1
  for ((i=1 ; i <= limit ; i++))
    do
      d=$d/..
    done
  d=$(echo $d | sed 's/^\///')
  if [ -z "$d" ]; then
    d=..
  fi
  cd $d
  pwd
  l
}

function bigfiles () {
  find . -type f -size +${1}k -exec ls -lh {} \; | awk '{ print $9 ": " $5 }'
}

function cd () {
  builtin cd "$1"
  l
  builtin pwd
}

function process () {
  if [ $# -lt 1 ]; then
    echo "Usage: process processName e.g. process java"
  else
    ps -ef | grep -i $1
  fi
}

function switchUser () {
  sudo -i -u $1
}

function backup () {
  if [ $# -lt 2 ]; then
    cp $1 $1.$(date '+%Y%m%d%H%M%S')
  else
    cp $1 $2/$1.$(date '+%Y%m%d%H%M%S')
  fi
}

function tailLogFor () {
  if [ $# -lt 2 ]; then
    echo "Usage: tailLogFor logFile appStart e.g. tailLogFor application.log appStart (grep is case insensitive)"
  else
    tail -f $1 | grep -i $2
  fi
}

function tailLog () {
  if [ $# -lt 1 ]; then
    echo "Usage: tailLog logFile e.g. tailLog application.log"
  else
    tail -f -n 200 $1
  fi
}

function findOldFiles () {
  if [ $# -lt 2 ]; then
   echo "Usage: findOldFiles filePath Age e.g. findOldfiles . 100"
  else
    find $1 -mindepth 1 -mtime +$2 -print
  fi
}

function createLink () {
  if [ $# -lt 2 ]; then
   echo "Usage: createLink fullPathToSource fullPathToLink"
  else
    ln -s $1 $2
  fi
}

function removeLink () {
  if [ $# -lt 1 ]; then
   echo "Usage: removeLink fullPathToLink"
  else
    unlink $1
  fi
}

function showAliases () {
  if [ $# -lt 1 ]; then
    grep "alias" /home/${USER}/.bashrc
  else
    grep "alias $1" /home/${USER}/.bashrc
  fi
}

function showFunctions () {
  if [ $# -lt 1 ]; then
    grep "function" /home/${USER}/.bashrc
  else
    grep "function $1" /home/${USER}/.bashrc
  fi
}

function extract () {
   if [ -f $1 ] ; then
     case $1 in
       *.tar.bz2)   tar xvjf $1    ;;
       *.tar.gz)    tar xvzf $1    ;;
       *.bz2)       bunzip2 $1     ;;
       *.rar)       unrar x $1     ;;
       *.gz)        gunzip $1      ;;
       *.tar)       tar xvf $1     ;;
       *.tbz2)      tar xvjf $1    ;;
       *.tgz)       tar xvzf $1    ;;
       *.zip)       unzip $1       ;;
       *.Z)         uncompress $1  ;;
       *.7z)        7z x $1        ;;
       *)           echo "don't know how to extract '$1'..." ;;
     esac
   else
       echo "'$1' is not a valid file!"
   fi
}

function findtext () {
  grep -iIHrnl --color=always "$1" . | less -r
}
