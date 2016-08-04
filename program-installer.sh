#!/bin/bash
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

# Global Variables:
HOMEDIR=$HOME
DOWNLOAD="wget --no-check-certificate --quiet"
GIT_CLONE="git clone -q"

LOGGER="[ INSTALLER ]"
LOGGER_WARNING="[  WARNING  ]"
LOGGER_CONFIRM="[  CONFIRM  ]"
LOGGER_DOWNLOADING="Downloading"
LOGGER_CLONING="Cloning"
LOGGER_INSTALLING="Installing"


# Functions:
# Define: display_usage
display_usage() {
    echo "usage: program-installer.sh [option, option, ...]"
    echo "options:"
    echo "  zshrc  - Download zshrc only"
    echo "  vim    - Install vim and Download plugins only"
    echo "  python - Download pyenv and Install python only"
    echo "  ruby   - Download rbenv and Install ruby only"
    echo "  node   - Download nodebrew and Install node only"
    echo "  all    - Install all"
    echo "note: You can write multiple options"
}

# Define: download_zshrc
download_zshrc() {
    cd $HOMEDIR

    # check already exist
    if [ -e .zshrc ]; then
        echo "$LOGGER_WARNING The zshrc is already exist."
        echo -n "$LOGGER_CONFIRM Do you want to download again? (y/n): "
        read CONFIRM

        if [ $CONFIRM = "y" ]; then
            echo "$LOGGER OK. Downloader continue."

        elif [ $CONFIRM = "n" ]; then
            echo "$LOGGER OK, Downloader interrupt."
            return 1

        else
            echo "$LOGGER Only input 'y' or 'n'!"
            echo "$LOGGER Downloader interrupt."
            return 1
        fi
    fi

    echo -n "$LOGGER $LOGGER_DOWNLOADING zshrc...  "
    $DOWNLOAD -O .zshrc "https://raw.githubusercontent.com/alice1017/DockerFiles/master/zshrc"
    echo done

    return 0
}

# Define: install_vim
install_vim() {
    cd $HOMEDIR

    # check already exist
    if [ -d .vim ]; then
        echo "$LOGGER_WARNING The .vim directory is already exist."
        echo -n "$LOGGER_CONFIRM Do you want to install again? (y/n): "
        read CONFIRM

        if [ $CONFIRM = "y" ]; then
            echo "$LOGGER OK. Installer continue."
            rm -rf .vim
            rm .vimrc

        elif [ $CONFIRM = "n" ]; then
            echo "$LOGGER OK, Installer interrupt."
            return 1

        else
            echo "$LOGGER Only input 'y' or 'n'!"
            echo "$LOGGER Installer interrupt."
            return 1
        fi
    fi

    mkdir .vim

    echo -n "$LOGGER $LOGGER_CLONING vundle...  "
    mkdir .vim/bundle
    $GIT_CLONE http://github.com/gmarik/vundle.git .vim/bundle/vundle
    echo done

    # vimrc
    echo -n "$LOGGER $LOGGER_DOWNLOADING vimrc...  "
    $DOWNLOAD -O .vim/vimrc "https://gist.githubusercontent.com/alice1017/c66e2e07cb8cee95091b/raw/335f6b4c28ac2c6a3c10405b9b53f923c6c64d94/vimrc"
    ln -s .vim/vimrc .vimrc
    echo done

    # colorschemee
    echo -n "$LOGGER $LOGGER_DOWNLOADING colorschemes...  "
    mkdir .vim/colors
    $DOWNLOAD -O .vim/colors/getafe.vim "https://raw.githubusercontent.com/alice1017/vim-getafe/master/colors/getafe.vim"
    $DOWNLOAD -O .vim/colors/solarized.vim "https://raw.githubusercontent.com/altercation/vim-colors-solarized/master/colors/solarized.vim"
    echo done

    return 0
}

# Define: install_python
install_python() {
    cd $HOMEDIR

    # check already exist
    if [ -d .pyenv ]; then
        echo "$LOGGER_WARNING The pyenv is already exist."
        echo -n "$LOGGER_CONFIRM Do you want to install again? (y/n): "
        read CONFIRM

        if [ $CONFIRM = "y" ]; then
            echo "$LOGGER OK. Installer continue."
            rm -rf .pyenv

        elif [ $CONFIRM = "n" ]; then
            echo "$LOGGER OK, Installer interrupt."
            return 1

        else
            echo "$LOGGER Only input 'y' or 'n'!"
            echo "$LOGGER Installer interrupt."
            return 1
        fi
    fi

    echo -n "$LOGGER $LOGGER_INSTALLING pyenv...  "
    $GIT_CLONE http://github.com/yyuu/pyenv.git .pyenv
    echo done

# write pyenv starter
    cat << "EOF" >> .zshrc
# pyenv installer
export PYENV_ROOT=$HOME/.pyenv
export PATH=$PYENV_ROOT/bin:$PATH
eval "$(pyenv init -)"

EOF

    # install python
    echo -n "$LOGGER $LOGGER_INSTALLING Python...  "
    PYENV=.pyenv/bin/pyenv
    LOGPATH=/tmp/python-installer.log
    $PYENV install -v 2.7.5 > $LOGPATH 2>&1

    if [ $? = 0 ]; then

        # change global version
        $PYENV global 2.7.5
        echo done

        # install python packages
        echo -n "$LOGGER $LOGGER_INSTALLING Python packages: pip, virtualenv"
        EASYINSTALL=.pyenv/versions/2.7.5/bin/easy_install
        $EASYINSTALL pip > /dev/null 2>&1
        $EASYINSTALL virtualenv > /dev/null 2>&1
        echo done

        return 0
    else

        echo failed
        echo "$LOGGER Installer log: $LOGPATH"
        echo "$LOGGER Last 10 log lines:"
        tail -n 10 $LOGPATH
        return 1
    fi
}

# Define: install_ruby
install_ruby() {
    cd $HOMEDIR

    # check already exist
    if [ -d .rbenv ]; then
        echo "$LOGGER_WARNING The rbenv is already exist."
        echo -n "$LOGGER_CONFIRM Do you want to install again? (y/n): "
        read CONFIRM

        if [ $CONFIRM = "y" ]; then
            echo "$LOGGER OK. Installer continue."
            rm -rf .rbenv

        elif [ $CONFIRM = "n" ]; then
            echo "$LOGGER OK, Installer interrupt."
            return 1

        else
            echo "$LOGGER Only input 'y' or 'n'!"
            echo "$LOGGER Installer interrupt."
            return 1
        fi
    fi

    echo -n "$LOGGER $LOGGER_CLONING rbenv...  "
    $GIT_CLONE http://github.com/sstephenson/rbenv.git .rbenv
    echo done

    # write rbenv starter
    cat << "EOF" >> .zshrc
# rbenv installer
export RBENV_ROOT=$HOME/.rbenv
export PATH=$RBENV_ROOT/bin:$PATH
eval "$(rbenv init - zsh)"

EOF

    # install rbenv-build plugin
    echo -n "$LOGGER $LOGGER_CLONING rbenv-build...  "
    $GIT_CLONE http://github.com/sstephenson/ruby-build.git .rbenv/plugins/ruby-build
    echo done

    # install ruby stable
    echo -n "$LOGGER $LOGGER_INSTALLING Ruby...  "
    RBENV=.rbenv/bin/rbenv
    STABLE=`$RBENV install -l | grep -v - | tail -1`
    LOGPATH=/tmp/ruby-installer.log
    $RBENV install -v $STABLE > $LOGPATH 2>&1

    if [ $? = 0 ]; then

        # change global version
        $RBENV global $STABLE
        echo done
        retun 0
    else

        echo failed
        echo "$LOGGER Installer log: $LOGPATH"
        echo "$LOGGER Last 10 log lines:"
        tail -n 10 $LOGPATH
        return 1
    fi
}

# Define: install_node
install_node() {
    cd $HOMEDIR

    # check already exist
    if [ -d .nodebrew ]; then
        echo "$LOGGER_WARNING The nodebrew is already exist."
        echo -n "$LOGGER_CONFIRM Do you want to install again? (y/n): "
        read CONFIRM

        if [ $CONFIRM = "y" ]; then
            echo "$LOGGER OK. Installer continue."
            rm -rf .rbenv

        elif [ $CONFIRM = "n" ]; then
            echo "$LOGGER OK, Installer interrupt."
            return 1

        else
            echo "$LOGGER Only input 'y' or 'n'!"
            echo "$LOGGER Installer interrupt."
            return 1
        fi
    fi


    echo -n "$LOGGER $LOGGER_INSTALLING nodebrew"
    $DOWNLOAD -O nodebrew_installer http://git.io/nodebrew
    perl nodebrew_installer setup > /dev/null 2>&1
    echo done

    # clean
    rm nodebrew_installer

    # write nodebrew starter
    cat << "EOF" >> .zshrc
# nodebrew installer
export PATH=$HOME/.nodebrew/current/bin:$PATH

EOF

    # install node stable
    echo -n "$LOGGER $LOGGER_INSTALLING Node...  "
    NODEBREW=.nodebrew/current/bin/nodebrew
    LOGPATH=/tmp/node-installer.log
    $NODEBREW install stable > $LOGPATH 2>&1

    if [ $? = 0 ]; then

        # change global version
        $NODEBREW use stable
        echo done
        return 0
    else

        echo faild
        echo "$LOGGER Installer log: $LOGPATH"
        echo "$LOGGER Last 10 log lines:"
        tail -n 10 $LOGPATH
        return 1
    fi
}

# Define: install_all
install_all() {
    # Flags
    FLAG=0
    failed_installer=()

    download_zshrc
    if [ $? != 0 ]; then
        $FLAG=1
        failed_installer+=("zshrc")
    fi
    sleep 1

    install_vim
    if [ $? != 0 ]; then
        $FLAG=1
        failed_installer+=("vim")
    fi
    sleep 1

    install_python
    if [ $? != 0 ]; then
        $FLAG=1
        failed_installer+=("python")
    fi
    sleep 1

    install_ruby
    if [ $? != 0 ]; then
        $FLAG=1
        failed_installer+=("ruby")
    fi
    sleep 1

    install_node
    if [ $? != 0 ]; then
        $FLAG=1
        failed_installer+=("node")
    fi

    echo "$LOGGER result:"

    if [ $FLAG = 0 ]; then
        echo "$LOGGER Installation was completed successfully."
        return 0

    elif [ $FLAG = 1 ]; then
        for installer in failed_installer
        do
            echo "$LOGGER $installer installation failed."
        done
        return 1
    fi
}

# Define: select_installer
select_installer() {
    INSTALLER=$1
    case "$INSTALLER" in
        "zshrc")
            download_zshrc;;

        "vim")
            install_vim;;

        "python")
            install_python;;

        "ruby")
            install_ruby;;

        "node")
            install_node;;

        "all")
            install_all;;
    esac
}

# ===============
#      MAIN
# ===============

# Check arguments
if [ $# = 0 ]; then
    display_usage
    exit 1
fi

# Call the select_installer function to the all options
for var in $@
do
    select_installer $var
done

# exit with function result code
exit $?
