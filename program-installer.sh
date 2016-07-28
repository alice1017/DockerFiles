#!/bin/sh
# coding: utf-8

# program-installer.sh
# Copyright (c) 2016 Hayato Tominaga
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

# Get home directory from arg
if [ $# = 0 ]; then
    echo "usage: program-inistaller.sh [homedir]"
    exit 1
fi

# Variables
HOMEDIR=$1
DOWNLOAD="wget --no-check-certificate"

# move homedir
cd $HOMEDIR

# ===============
#     VIM
# ===============
mkdir .vim
mkdir .vim/bundle
git clone http://github.com/gmarik/vundle.git .vim/bundle/vundle

# vimrc
$DOWNLOAD -O .vim/vimrc "https://gist.githubusercontent.com/alice1017/c66e2e07cb8cee95091b/raw/335f6b4c28ac2c6a3c10405b9b53f923c6c64d94/vimrc"
ln -s .vim/vimrc .vimrc

# colorschemee
mkdir .vim/colors
$DOWNLOAD -O .vim/colors/getafe.vim "https://raw.githubusercontent.com/alice1017/vim-getafe/master/colors/getafe.vim"
$DOWNLOAD -O .vim/colors/solarized.vim "https://raw.githubusercontent.com/altercation/vim-colors-solarized/master/colors/solarized.vim"

sleep 1

# ===============
#    PYTHON
# ===============

git clone http://github.com/yyuu/pyenv.git .pyenv

# write pyenv starter
cat << "EOF" >> .zshrc
# pyenv installer
export PYENV_ROOT=$HOME/.pyenv
export PATH=$PYENV_ROOT/bin:$PATH
eval "$(pyenv init -)"
EOF

# install python
PYENV=.pyenv/bin/pyenv
$PYENV install 2.7.5 && $PYENV global 2.7.5

if [ $? != 0 ]; then
    echo "Python build failed.\n"
    echo "This installer does not install python packages.\n"

else;

    # install python packages
    EASYINSTALL=.pyenv/versions/2.7.5/bin/easy_install
    $EASYINSTALL pip
    $EASYINSTALL virtualenv

fi

sleep 1

# ===============
#     RUBY
# ===============

git clone http://github.com/sstephenson/rbenv.git .rbenv

# write rbenv starter
cat << "EOF" >> .zshrc
# rbenv installer
export RBENV_ROOT=$HOME/.rbenv
export PATH=$RBENV_ROOT/bin:$PATH
eval "$(rbenv init - zsh)"
EOF

# install rbenv-build plugin
git clone http://github.com/sstephenson/ruby-build.git .rbenv/plugins/ruby-build

# install ruby stable
RBENV=.rbenv/bin/rbenv
STABLE=`rbenv install -l | grep -v - | tail -1`
$RBENV install $STABLE && $RBENV global $STABLE

if [ $? != 0 ]; then
    echo "Ruby build failed.\n"
fi

sleep 1

# ===============
#    NODEBREW
# ===============

$DOWNLOAD -O nodebrew_installer http://git.io/nodebrew
perl nodebrew_installer setup

# write nodebrew starter
cat << "EOF" >> .zshrc
# nodebrew installer
export PATH=$HOME/.nodebrew/current/bin:$PATH
EOF

# install node stable
NODEBREW=.nodebrew/bin/nodebrew
$NODEBREW install stable && $NODEBREW use stable

if [ $? != 0 ]; then
    echo "Nodebrew build failed.\n"
fi



