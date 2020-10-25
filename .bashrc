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
alias countfiles="for t in files links directories; do echo \`find . -type \${t:0:1} | wc -l\` \$t; done 2> /dev/null"
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

function tailLogFor () {
  if [ $# -lt 2 ]; then
    echo "Usage: tailLogFor logFile kudos e.g. tailLogFor application.log kudos (grep is case insensitive)"
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
    echo "Usage: fileOldFiles filePath Age e.g. findOldFile . 100"
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

function findText () {
  grep -iIHrnl --color=always "$1" . | less -r
}

function extract {
 if [ -z "$1" ]; then
    # display usage if no parameters given
    echo "Usage: extract <path/file_name>.<zip|rar|bz2|gz|tar|tbz2|tgz|Z|7z|xz|ex|tar.bz2|tar.gz|tar.xz>"
    echo "       extract <path/file_name_1.ext> [path/file_name_2.ext] [path/file_name_3.ext]"
 else
    for n in "$@"
    do
      if [ -f "$n" ] ; then
          case "${n%,}" in
            *.cbt|*.tar.bz2|*.tar.gz|*.tar.xz|*.tbz2|*.tgz|*.txz|*.tar)                                      tar xvf "$n"       ;;
            *.lzma)                                                                                          unlzma ./"$n"      ;;
            *.bz2)                                                                                           bunzip2 ./"$n"     ;;
            *.cbr|*.rar)                                                                                     unrar x -ad ./"$n" ;;
            *.gz)                                                                                            gunzip ./"$n"      ;;
            *.cbz|*.epub|*.zip)                                                                              unzip ./"$n"       ;;
            *.z)                                                                                             uncompress ./"$n"  ;;
            *.7z|*.apk|*.arj|*.cab|*.cb7|*.chm|*.deb|*.dmg|*.iso|*.lzh|*.msi|*.pkg|*.rpm|*.udf|*.wim|*.xar)  7z x ./"$n"        ;;
            *.xz)                                                                                            unxz ./"$n"        ;;
            *.exe)                                                                                           cabextract ./"$n"  ;;
            *.cpio)                                                                                          cpio -id < ./"$n"  ;;
            *.cba|*.ace)                                                                                     unace x ./"$n"      ;;
            *.zpaq)                                                                                          zpaq x ./"$n"      ;;
            *.arc)                                                                                           arc e ./"$n"       ;;
            *.cso)                                                                                           ciso 0 ./"$n" ./"$n.iso" && \ extract $n.iso && \rm -f $n ;;
            *)
            echo "extract: '$n' - unknown archive method"
            return 1
            ;;
          esac
      else
          echo "'$n' - file does not exist"
          return 1
      fi
    done
fi
}
