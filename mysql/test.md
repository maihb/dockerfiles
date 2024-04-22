docker-compose   
```sh
#安装 docker-compose
sudo apt install -y docker-compose
#删除重来: dk rm -f  sql;dk rmi mysql:local
docker-compose build
docker-compose up -d
docker logs -f sql

# 测试连接（la 为目标机器，修改hosts）： mysql -utest -h la -p123456
```

或者直接一行命令运行, 不好初始化，暂时放弃
```sh
# /var/log/mysql       目录，用于存储 MySQL 的日志文件。
# /var/lib/mysql       目录，用于存储 MySQL 的数据文件。
# /etc/mysql           目录，用于存储 MySQL 的配置文件。
# /var/lib/mysql-files 目录，用于存储 MySQL 的文件数据。
# 将sql文件放到容器中的 /docker-entrypoint-initdb.d/ 目录，就会在mysql第一次启动时执行。之后重启容器不会重复执行！
# 设置 MySQL 的 root 用户密码为 root。这个参数使用了环境变量来传递密码信息。
# 设置 MySQL 的字符集为 utf8mb4，并使用 utf8mb4_unicode_ci 排序规则。这个参数可以确保 MySQL 能够正确地处理 Unicode 字符。
docker run -p 3306:3306 --name mysql1 \
    -v /home/mysql/log:/var/log/mysql \
    -v /home/mysql/data:/var/lib/mysql \
    -v /home/mysql/conf:/etc/mysql \
    -v /home/mysql/mysql-files:/var/lib/mysql-files \
    -e MYSOL_ROOT_PASSWORD=root \
    -d mysql:5.7 \
    --character-set-server=utf8mb4 --collation-server=utf8mb4_unicode_ci
```
