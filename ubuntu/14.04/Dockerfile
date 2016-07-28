# my original dockerfile

FROM ubuntu:14.04

MAINTAINER Alice1017 genocidedragon@gmail.com

# packager update & install
RUN apt-get update
RUN apt-get install -y zsh git vim make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev llvm libncurses5-dev libncursesw5-dev xz-utils

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
RUN chsh -s /usr/bin/zsh alice
RUN echo 'alice ALL=(ALL:ALL) ALL' >> /etc/sudoers

# download program-installer
#RUN wget --no-check-certificat -O installer.sh "https://gist.githubusercontent.com/alice1017/f222eda6dcbbedb470a006d61c2bf60c/raw/b7a6ac12769f33e366cd593c3e08d528c45094af/program-installer.sh"

CMD    ["/usr/sbin/sshd", "-D"]
