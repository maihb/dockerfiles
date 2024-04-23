FROM alpine:latest

RUN apk add --no-cache openssh-server shadow miniserve
RUN cd /etc/ssh && ssh-keygen -A

# set password
RUN echo "root:123" | chpasswd
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/g' /etc/ssh/sshd_config

# WORKDIR --这个没用. 需要修改 passwd 
RUN sed -i '1s|/root|/dl|'  /etc/passwd

EXPOSE 22
EXPOSE 8080
ENTRYPOINT ["/bin/sh","-c","/usr/sbin/sshd && miniserve /dl -v -D -u"];
