imName='m_mysql:5.7'
insName="sql"
docker rm -f $insName -v
docker rmi $imName
docker build -t $imName . && docker run -d --name $insName -p 8306:3306 \
    -v /data/mysql/data:/var/lib/mysql \
    -v /data/mysql/conf.d:/etc/mysql/conf.d \
    -v /data/mysql/logs:/var/log/mysql \
    $imName
