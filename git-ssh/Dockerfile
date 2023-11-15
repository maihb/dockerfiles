FROM alpine:latest

ARG USERNAME=git
ARG USERPASS=123

RUN apk add --no-cache git openssh-server shadow

RUN cd /etc/ssh && ssh-keygen -A

# Add a non-root user & set password
RUN useradd -ms /usr/bin/git-shell $USERNAME
RUN usermod --password $(echo "$USERPASS" | mkpasswd -s) $USERNAME

# Create the ssh directory and authorized_keys file
USER $USERNAME
RUN mkdir /home/$USERNAME/.ssh && touch /home/$USERNAME/.ssh/authorized_keys

USER root
ENTRYPOINT ["/bin/sh","-c","/usr/sbin/sshd && tail -f /dev/null"];
EXPOSE 22
