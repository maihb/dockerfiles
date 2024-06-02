FROM redis:7.0
WORKDIR /data
COPY redis.conf /etc/redis/conf.d/
VOLUME ["/data/redis/data","/data"]
ENTRYPOINT ["redis-server","/etc/redis/conf.d/redis.conf"]