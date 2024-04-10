FROM mysql:5.7

EXPOSE 3306
ADD mysqld.cnf /etc/mysql/mysql.conf.d/mysqld.cnf
#时区
RUN ln -fs /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
