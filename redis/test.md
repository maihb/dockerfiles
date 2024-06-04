一行命令：    
```sh
docker run --name rds -p 6379:6379 -d redis:7.0 --requirepass b12345
#支持布隆过滤器版本 （bf.add bf.madd bf.exists bf.mexists）
docker run --name rds \
    -p 6379:6379 \
    -d redislabs/rebloom:latest \
    --requirepass b12345 \
    --loadmodule '/usr/lib/redis/modules/redisbloom.so' INITIAL_SIZE 10000000 ERROR_RATE 0.0001 \
    --appendonly yes
```

build:   
```sh
docker rm -f rds && docker rmi myrds
docker build -t myrds .
docker run -d --name rds --restart=unless-stopped \
    -p 6379:6379 \
    -v /data/redis/data:/data \
    myrds
```