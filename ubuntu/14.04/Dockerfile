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

FROM ubuntu:14.04

MAINTAINER Alice1017 genocidedragon@gmail.com

# packager update & install
RUN apt-get update
RUN apt-get install -y zsh git vim make man manpages-dev
RUN apt-get install -y build-essential libssl-dev zlib1g-dev w3m
RUN apt-get install -y libbz2-dev libreadline-dev libsqlite3-dev ctags
RUN apt-get install -y llvm libncurses5-dev libncursesw5-dev xz-utils language-pack-ja

# sshd
RUN apt-get install -y openssh-server
RUN mkdir -p /var/run/sshd
RUN echo 'root:root' |chpasswd
RUN sed -ri 's/^PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config
EXPOSE 22

# about login user
RUN useradd -m alice
RUN gpasswd -a alice staff
RUN echo "alice:hayato2192" | chpasswd
RUN chsh -s /usr/bin/zsh alice
RUN echo 'alice ALL=(ALL:ALL) ALL' >> /etc/sudoers

# download program-installer
RUN wget -q --no-check-certificate -O /home/alice/installer.sh "https://raw.githubusercontent.com/alice1017/DockerFiles/master/program-installer.sh"
RUN chown alice:alice /home/alice/installer.sh
RUN chmod +x /home/alice/installer.sh

CMD    ["/usr/sbin/sshd", "-D"]
