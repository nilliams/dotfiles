# LOAD PRIVATE STUFF
# ------------------
if [ -f ~/.bashrc_private ]; then
    . ~/.bashrc_private
fi

# ALIASES/HELPERS
# ---------------

# Set EDITOR to Vim
export EDITOR='vim'

# History-complete with up/down
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'

# Edit handy files
alias scratch='vim ~/Dropbox/Notes/_Links-New.md'
alias trackb='vim "~/Dropbox/Notes/Track B - Ruby, Clojure, etc.md"'
alias trackc='vim "~/Dropbox/Notes/Track C - Startups, Life-Work Balance etc.md"'

# Colors to work properly in VIM etc.
export TERM="xterm-256color"

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\n\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi

# TODO: Needed?
unset color_prompt force_color_prompt

# Let Ctrl-S be passed through to vim et al.
# http://askubuntu.com/questions/339523/how-to-map-ctrls-in-vim-on-gnome-terminal
stty stop undef

# Maybe help tmux?
stty -ixon

# Quick server alias
alias server='python -m SimpleHTTPServer'

# Install
alias canhaz='sudo apt-get install'

# glog
alias glog="hg log --graph -l 50 --template '[\033[1m{branch}\033[0m{if(tags,\":\")}\033[33m{tags}\033[0m{if(bookmarks,\":\")}\033[1;36m{bookmarks}\033[0m] {node|short} \033[31m{author|user}:\033[37m {desc|firstline} \033[32m({phase})\033[37m\n'"

# log deleted files, can then bring them back with revert -r <rev>
alias dlog_base='hg log --template "{rev}: {file_dels}\n"'
alias dlog="dlog_base | grep -v ':\s*$'"

# slog - a short log
alias slog='hg log --limit 10 --template "{rev}:{node|short} {desc|firstline} ({author})\n"'

# Enable pip caching
# http://stackoverflow.com/questions/4806448/how-do-i-install-from-a-local-cache-with-pip
export PIP_DOWNLOAD_CACHE=$HOME/.pip_download_cache

# I CAN NEVER REMEMBER THE NAME OF THE PICTUREVIEWER BINARY
alias picture='eog'

pycl() {
    find . -name '*.pyc' -delete
}

origcl() {
    find . -name '*.orig' -delete
}

swpcl() {
    find . -name '*.swp' -delete
    find . -name '*.swn' -delete
    find . -name '*.swo' -delete
}

# Does my head in when dirs/files are mixed together. Unfortunately no option for files-first?
alias tree='tree --dirsfirst'

# Non-commented LOC
locnocomments() {
    egrep -v '^$|^ *\/\/' $1 | wc -l
}

# Grepped files into Vim
grepvim() {
    vim $(grep -rIl $1 *) -p
}

# Show current directory as title to gnome-terminal
# http://stackoverflow.com/questions/10517128/change-gnome-terminal-title-to-reflect-the-current-directory
PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD}\007"'

# SVN aliases
alias svnaddall='svn add --force * --auto-props --parents --depth infinity -q'

# Tmuxifier
export PATH="$HOME/.tmuxifier/bin:$PATH"

# TODO: Some sane alias/function for this:
# diff logs against a tag, i.e. for writing changelogs
# hg log -r tip:v1.1.1

# What is my public ip
alias ipecho='curl ipecho.net/plain; echo'

# What is my local ip
alias ip?='hostname -I'

# Coloured `cat`
alias ccat='pygmentize -g'

# Git
# ---
# show current tag
alias gittag='git name-rev --tags --name-only $(git rev-parse HEAD)'

# Prompt/PS1
# ----------
# The 'blog post' version of hg prompt, minus hg_dirty() which doesn't seem to work
# see: http://stevelosh.com/blog/2009/03/mercurial-bash-prompts/
DEFAULT="[37;40m"
PINK="[35;40m"
GREEN="[32;40m"
ORANGE="[33;40m"

hg_branch() {
    hg branch 2> /dev/null | \
        awk '{ printf "\033[37;0m on \033[35;40m" $1 }'
    hg bookmarks 2> /dev/null | \
        awk '/\*/ { printf "\033[37;0m at \033[33;40m" $2 }'
}

# Prefer liquid prompt if 'available', fall back to hg-prompt
# Only load Liquid Prompt in interactive shells, not from a script or from scp
if [ -e ~/liquidprompt/liquidprompt ]; then
    [[ $- = *i* ]] && source ~/liquidprompt/liquidprompt
else
    export PS1='\n\e${PINK}\u \e${DEFAULT}at \e${ORANGE}\h \e${DEFAULT}in \e${GREEN}\w$(hg_branch)\e \e${DEFAULT}\n$ '
fi

# Vim Python ctags
# sudo apt-get install exuberant-ctags
# https://www.fusionbox.com/blog/detail/navigating-your-django-project-with-vim-and-ctags/590/
function retag() {
    ctags -R --fields=+l --languages=python --python-kinds=-iv -f ./tags $(python -c "import os, sys; print(' '.join('{}'.format(d) for d in sys.path if os.path.isdir(d)))")
}

# Tox - run on change -- uses envs from opposite ends of spectrum.
alias toxw='find . -name "*.py" ! -path "./.tox/*" | entr tox -e py27-dj16-sqlite,py34-dj19-mysql'

# Elapsed time of a process (how long it's been running for).
# Pass the pid as an argument, e.g. `elapsed 1415`.
function elapsed() {
    ps -p "$1" -o etime=
}
