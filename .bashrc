# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# User specific aliases and functions
HISTTIMEFORMAT="%d/%m/%y %T "

# Override commands
alias ps='ps -auxf'
alias free='free -hmt'
alias dfTotal='df -Tha --total'
alias duUsed='du -ach | sort -h'
alias topcpu="top -b -o +%CPU | head -17"
alias topcpu="top -b -o +%MEM | head -17"
alias cpu="grep 'cpu ' /proc/stat | awk '{usage=(\$2+\$4)!00/(\$2+\$4+\$5)} END {print usage}' | awk '{printf(\"%.1f\n\", \$1)}'"
alias countfiles-"for t in files links directories; do echo \`find . -type \${t:0:1} | wc -l\` \$t; done 2> /dev/null"
alias ipview="netstat -anpl | grep :80 | awk {'print \$5'} | cut -d\":\" -f1 | sort | uniq -c | sort | uniq -c | sort -n | sed -e 's/^ *//' -e 's/ *\$//'"
alias openports='netstat -nape --inet'
alias compress='tar -cvf'
alias fbs='du -hs * 2>dev/null | sort'

# Directory Lists commands
alias l='ls -ltr'
alias la='ls -ltra'
alias ls='ls -aFh --color=always' # add colors and file type extension
alias lx='ls -lXBh' # sort by extension
alias lk='ls -lSrh' # sort by size
alias lc='ls -lcrh' # sort by change time
alias lu='ls -lurh' # sort by access time
alias lr='ls -lRh' # sort by recursive ls
alias lt='ls -ltrh' # sort by date
alias lm='ls -alh | more' # pipe to more
alias lw='ls -xAh' # sort by wide listing format
alias ll='ls -Fls' # sort by 
alias labc='ls -lap' # sort by alphabet
alias lf="ls -l | egrep -v '^d'" # files only
alias ldir="ls -l | egrep '^d'" # directories only 

# Copy & Move commands
alias cp='cp -rv'
alias wget='wget -c'

# Chmod commands
alias mx='chmod a+x'
alias 000='chmods -R 000'
alias 644='chmods -R 644'
alias 666='chmods -R 666'
alias 755='chmods -R 755'
alias 744='chmods -R 744'
alias 777='chmods -R 777'

alias back='cd "$OLDPWD"'
alias home='cd /home/${USER}'
alias disk='du -a | sort -n -r | more'
alias diskSpace="du -S | sort -n -r | more"
alias folders='du -h --max-depth=1'
alias folderssort='find . -maxdepth 1 -type d =print0 | xargs -0 du -sk | sort -rn'
alias tree='tree -CAhF --dirfirst'
alias treed='tree -CADd'
alias mountedinfo='df -hT'
alias hardware='clear; hostname; echo ""; echo "CPUs Info"; lscpu | grep "CPUs Info"; lscpu | grep "CPU(s):" | head -n1; cat /proc/cpuinfo | grep "cpu cores" | tail -n1 ; lscpu | grep Arch; cat /proc/cpuinfo | grep "model name" | tail -n1 ; echo ""; echo "MEM Info" ; cat /proce/meminfo | grep MemTotal; echo ""; echo "Disk Info"; df -h; echo ""; echo "INodes"; df -ih: echo ""; echo "O/S Info"; cat /etc/redhat-release; echo "Uptime"; uptime; echo "";'

# Other commands
alias fixsep="sed -r $'\/\x01/|/g' "

# Functions

function up () {
  local d =""
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
}

function cd () {
  builtin cd "$1"
  l
  builtin pwd
}

function bigfiles () {
  find . -type f -size +${1}k -exec ls -lh {} \; | awk '{ print $9 ": " $5 }'
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

function next () {}



