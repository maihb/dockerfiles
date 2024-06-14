# es  
官方安装手册:
https://www.elastic.co/guide/en/elasticsearch/reference/current/docker.html

## 01 安装es

```sh
# 修改进程可以具有的最大内存映射区域数 (mmap)
sysctl vm.max_map_count && sudo sysctl -w vm.max_map_count=262144
sudo sysctl -p && sysctl vm.max_map_count

# 创建文件目录
sudo mkdir -p /data && sudo chown "$(whoami):root" /data
mkdir -p /data/elasticsearch/{config,data,logs,plugins}
# 如果之前没有映射目录需要备份之前数据
docker cp es01:/usr/share/elasticsearch/config /data/elasticsearch
docker cp es01:/usr/share/elasticsearch/logs /data/elasticsearch
docker cp es01:/usr/share/elasticsearch/data /data/elasticsearch
docker cp es01:/usr/share/elasticsearch/plugins /data/elasticsearch
sudo chown -R opc:root /data/elasticsearch/*
# 可以不用配置，用默认
cat > /data/elasticsearch/config/elasticsearch.yml <<EOF
cluster.name: "docker-cluster"
network.hosts:0.0.0.0
# 跨域
http.cors.allow-origin: "*"
http.cors.enabled: true
http.cors.allow-headers: Authorization,X-Requested-With,Content-Length,Content-Type
EOF

docker network create elastic
docker run -dit --name es01 \
    --net elastic \
    -p 9200:9200 \
    -e ES_JAVA_OPTS="-Xms512m -Xmx512m" \
    -m 2GB \
    -e "discovery.type=single-node" \
    -v /data/elasticsearch/logs:/usr/share/elasticsearch/logs \
    -v /data/elasticsearch/data:/usr/share/elasticsearch/data \
    -v /data/elasticsearch/plugins:/usr/share/elasticsearch/plugins \
    docker.elastic.co/elasticsearch/elasticsearch:8.14.1

# 暂时用默认配置
    -v /data/elasticsearch/config/elasticsearch.yml:/usr/share/elasticsearch/config/elasticsearch.yml \
```
## 02 安装kibana （管理页面）

```sh
docker run -d --name kib01 \
    --net elastic \
    -e ES_JAVA_OPTS="-Xms512m -Xmx512m" \
    -m 2GB \
    -p 5601:5601 \
    docker.elastic.co/kibana/kibana:8.14.1

# 登录 kibana
docker logs es01|grep -C 1 reset-password  # 输出初始密码 (账号:elastic)
docker logs es01|grep -C 1 Kibana # 输出登录 token
docker logs kib01|grep started  # 输出登录地址，需要用到 es 的 token
#重新生成 token
docker exec -it es01 /usr/share/elasticsearch/bin/elasticsearch-create-enrollment-token -s kibana
```
