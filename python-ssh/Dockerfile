FROM python:latest

# Env & Arg variables
ARG USERNAME=py
ARG USERPASS=123

# Apt update & apt install required packages
# whois: required for mkpasswd
RUN apt update && apt -y install openssh-server whois locales vim make net-tools

#timezone
ENV TZ=Asia/Shanghai \
    DEBIAN_FRONTEND=noninteractive
RUN ln -fs /usr/share/zoneinfo/${TZ} /etc/localtime \
    && echo ${TZ} > /etc/timezone \
    && dpkg-reconfigure --frontend noninteractive tzdata 
# utf8
RUN sed -ie 's/# zh_CN.UTF-8 UTF-8/zh_CN.UTF-8 UTF-8/g' /etc/locale.gen && \
    dpkg-reconfigure --frontend=noninteractive locales

# Add a non-root user & set password
RUN useradd -ms /bin/bash $USERNAME
# Save username on a file ¿?¿?¿?¿?¿?
#RUN echo "$USERNAME" > /.non-root-username

# Set password for non-root user
RUN usermod --password $(echo "$USERPASS" | mkpasswd -s) $USERNAME

# Remove no-needed packages
RUN apt purge -y whois && apt -y autoremove && apt -y autoclean && apt -y clean && rm -rf /var/lib/apt/lists/*

# Change to non-root user
#USER $USERNAME
#WORKDIR /home/$USERNAME


COPY init.sh init.sh
RUN chmod 777 /init.sh

# Create the ssh directory and authorized_keys file
USER $USERNAME
RUN mkdir /home/$USERNAME/.ssh && touch /home/$USERNAME/.ssh/authorized_keys
RUN /init.sh  

USER root
RUN  rm /init.sh
# Set volumes
#VOLUME /home/$USERNAME/.ssh
#VOLUME /etc/ssh

ENTRYPOINT ["/bin/sh","-c","service ssh start && tail -f /dev/null"];
EXPOSE 22

