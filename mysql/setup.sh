#!/bin/bash
set -e
tail -f /dev/null
#查看mysql服务的状态，方便调试，这条语句可以删除
echo $(systemctl status mysql)

echo '1.启动mysql...'
#启动mysql
systemctl start mysql
sleep 3

echo $(systemctl status mysql)
echo '2.执行 init.sql...'
mysql </mysql/init.sql
sleep 3
echo '2.init.sql done...'

echo '3.修改mysql权限...'
mysql </mysql/privileges.sql
sleep 3
echo '3.权限修改完毕...'

#sleep 3
echo $(systemctl status mysql)
echo 'mysql容器启动完毕,且数据导入成功'

tail -f /dev/null
