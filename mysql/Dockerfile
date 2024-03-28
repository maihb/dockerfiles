FROM mysql:5.7

#时区
ENV TZ=Asia/Shanghai
RUN ln -fs /usr/share/zoneinfo/${TZ} /etc/localtime

EXPOSE 3306
LABEL version="0.1" description="Mysql服务器" by="mhb"

#设置免密登录
#ENV MYSQL_ALLOW_EMPTY_PASSWORD yes

#将所需文件放到容器中
COPY sql /mysql
COPY setup.sh /mysql/

#设置容器启动时执行的命令
CMD ["sh", "/mysql/setup.sh"]
