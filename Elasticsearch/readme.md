# es  
官方安装手册:
https://www.elastic.co/guide/en/elasticsearch/reference/current/docker.html

## 01 安装es

```sh
# 修改进程可以具有的最大内存映射区域数 (mmap)
sysctl vm.max_map_count && sudo sysctl -w vm.max_map_count=262144
sudo sysctl -p && sysctl vm.max_map_count

docker run -dit --name es01 --net elastic -p 9200:9200 -m 1GB docker.elastic.co/elasticsearch/elasticsearch:8.14.1
```
## 02 安装kibana （管理页面）

```sh
docker network create elastic
docker run -d --name kib01 --net elastic -p 5601:5601 docker.elastic.co/kibana/kibana:8.14.1

# 登录 kibana
docker logs es01|grep -C 1 reset-password  # 输出初始密码 (账号:elastic)
docker logs es01|grep -C 1 Kibana # 输出登录 token
docker logs kib01|grep started  # 输出登录地址，需要用到 es 的 token
```
