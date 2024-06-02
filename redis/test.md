一行命令：    
```sh
docker run --name rds -p 6379:6379 -d redis --requirepass b12345
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