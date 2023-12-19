FROM ubuntu:16.04
#时区
ENV TZ=Asia/Shanghai \
    DEBIAN_FRONTEND=noninteractive

#中文
ENV LANG=zh_CN.utf8 \
    LANGUAGE=zh_CN.utf8 \
    LC_ALL=zh_CN.utf8
RUN echo "export LANG=zh_CN.utf8 " >> /etc/profile &&\
    echo "export LANGUAGE=zh_CN.utf8" >> /etc/profile &&\
    echo "export LC_ALL=zh_CN.utf8" >> /etc/profile 

#golang 
ENV PATH=/usr/bin/go/bin:$PATH \
    GOPATH=$HOME/.go
RUN echo 'export PATH=/usr/bin/go/bin:$PATH' >> /etc/profile &&\
    echo 'export GOPATH=$HOME/.go' >> /etc/profile 

RUN echo "alias ll='ls -CalFrt'" >> /etc/profile &&\
    echo "alias t='tail -10f'" >> /etc/profile &&\
    echo "alias gst='git status'" >> /etc/profile &&\
    echo "alias l='ls -alFh'" >> /etc/profile &&\
    echo "set -o vi" >> /etc/profile 

# Env & Arg variables
ARG USERNAME=dev
ARG USERPASS=123

WORKDIR /

RUN apt update && apt -y install openssh-server whois tzdata language-pack-zh-hans wget \
    vim make git gcc g++ libcurl4-gnutls-dev libjpeg-dev zlib1g-dev mingw-w64 xz-utils

# Add a non-root user & set password
RUN useradd -ms /bin/bash $USERNAME
RUN usermod --password $(echo "$USERPASS" | mkpasswd -s) $USERNAME
#timezone

RUN ln -fs /usr/share/zoneinfo/${TZ} /etc/localtime &&\
    echo ${TZ} > /etc/timezone &&\
    dpkg-reconfigure --frontend noninteractive tzdata 

#安装 golang 1.20 amd64
RUN wget https://golang.google.cn/dl/go1.20.10.linux-amd64.tar.gz &&\
    tar zxf go1.20.10.linux-amd64.tar.gz -C /usr/bin &&\
    rm go1.20.10.linux-amd64.tar.gz

#安装 zig 交叉编译工具
RUN wget https://ziglang.org/download/0.11.0/zig-linux-x86_64-0.11.0.tar.xz &&\
    tar -xvf zig-linux-x86_64-0.11.0.tar.xz &&\
    mv zig-linux-x86_64-0.11.0 /usr/local/zig &&\
    echo 'export PATH=/usr/local/zig:$PATH' >>/etc/profile &&\
    rm zig-linux-x86_64-0.11.0.tar.xz

# Remove no-needed packages
RUN apt purge -y whois && apt -y autoremove && apt -y autoclean && apt -y clean && rm -rf /var/lib/apt/lists/*


COPY init.sh init.sh
RUN chmod 777 init.sh

RUN mkdir /code && chmod 777 /code

# Create the ssh directory and authorized_keys file
USER $USERNAME
RUN mkdir /home/$USERNAME/.ssh && touch /home/$USERNAME/.ssh/authorized_keys
RUN /init.sh  

USER root
RUN  rm /init.sh
# Run entrypoint
ENTRYPOINT ["/bin/sh","-c","service ssh start && tail -f /dev/null"];
EXPOSE 22
