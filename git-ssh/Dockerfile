FROM ubuntu

RUN apt update && apt -y install git openssh-server
RUN cd /etc/ssh && ssh-keygen -A

# Add a non-root user & set password
ARG USERNAME=git
RUN useradd -ms /usr/bin/git-shell -G 0 $USERNAME

# 证书登录，不需要改密码了。 改密码需要 apt install shadow
#ARG USERPASS=123
#RUN usermod --password $(echo "$USERPASS" | mkpasswd -s) $USERNAME

# Create the ssh directory and authorized_keys file
USER $USERNAME
RUN mkdir -p /home/$USERNAME/.ssh 
COPY authorized_keys /home/$USERNAME/.ssh/authorized_keys

USER root
RUN apt purge -y whois && apt -y autoremove && apt -y autoclean && apt -y clean && rm -rf /var/lib/apt/lists/*

ENTRYPOINT ["/bin/sh","-c","service ssh start && tail -f /dev/null"];
EXPOSE 22
