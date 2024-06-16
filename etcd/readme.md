# etcd 分布式服务发现

## 安装

官方安装文档:  http://play.etcd.io/install


```sh
#macos 
brew install etcd

#linux     --这个个人练习可以，但生产需要特定版本
yum install etcd -y
#特定版本Linux etcd

ETCD_VER=v3.4.10
DOWNLOAD_URL=https://storage.googleapis.com/etcd
rm -f /tmp/etcd-${ETCD_VER}-linux-amd64.tar.gz
rm -rf /tmp/etcd-download-test;  mkdir -p /tmp/etcd-download-test
curl -L ${DOWNLOAD_URL}/${ETCD_VER}/etcd-${ETCD_VER}-linux-amd64.tar.gz -o /tmp/etcd-${ETCD_VER}-linux-amd64.tar.gz
tar xzvf /tmp/etcd-${ETCD_VER}-linux-amd64.tar.gz -C /tmp/etcd-download-test --strip-components=1
rm -f /tmp/etcd-${ETCD_VER}-linux-amd64.tar.gz
chmod +x /tmp/etcd-download-test/etcd
chmod +x /tmp/etcd-download-test/etcdctl 
#Verify the downloads
/tmp/etcd-download-test/etcd --version
/tmp/etcd-download-test/etcdctl version
 
#Move them to the bin folder
sudo mv /tmp/etcd-download-test/etcd /usr/bin
sudo mv /tmp/etcd-download-test/etcdctl /usr/bin
rm -r /tmp/etcd-download-test
```

## 生成证书（参考systemAdmin.md， 略）

## 复制证书到etcd目录

```sh
sudo mkdir -p /etc/etcd
sudo mv *.crt /etc/etcd
sudo mv *.key /etc/etcd
sudo chmod 600 /etc/etcd/server.key
```

## 配置     (linux)

```sh
#创建数据存储目录
sudo mkdir -p /var/lib/etcd
sudo chmod 700 /var/lib/etcd/ -R

# cat /etc/etcd/etcd.conf
ETCD_NAME=etcd-1
ETCD_LISTEN_PEER_URLS="https://10.0.0.4:2380"
ETCD_LISTEN_CLIENT_URLS="https://10.0.0.4:2379"
ETCD_INITIAL_CLUSTER_TOKEN="etcd-cluster"
ETCD_INITIAL_CLUSTER="etcd-1=https://10.0.0.4:2380,etcd-2=https://10.0.0.5:2380"
ETCD_INITIAL_ADVERTISE_PEER_URLS="https://10.0.0.4:2380"
ETCD_ADVERTISE_CLIENT_URLS="https://10.0.0.4:2379"
ETCD_TRUSTED_CA_FILE="/etc/etcd/etcd-ca.crt"
ETCD_CERT_FILE="/etc/etcd/server.crt"
ETCD_KEY_FILE="/etc/etcd/server.key"
ETCD_PEER_CLIENT_CERT_AUTH=true
ETCD_PEER_TRUSTED_CA_FILE="/etc/etcd/etcd-ca.crt"
ETCD_PEER_KEY_FILE="/etc/etcd/server.key"
ETCD_PEER_CERT_FILE="/etc/etcd/server.crt"
ETCD_DATA_DIR="/var/lib/etcd"

```

## 配置成服务，开机启动自动重启
在/lib/systemd/system/处创建文件etcd.service，内容如下：
```ini
[Unit]
Description=etcd key-value store
Documentation=https://github.com/etcd-io/etcd
After=network.target
 
[Service]
Type=notify
EnvironmentFile=/etc/etcd/etcd.conf
ExecStart=/usr/bin/etcd
Restart=always
RestartSec=10s
LimitNOFILE=40000
 
[Install]
WantedBy=multi-user.target
```
然后开启服务
sudo systemctl daemon-reload
sudo systemctl enable etcd
sudo systemctl start etcd

## 测试：
```sh
# etcdctl --endpoints https://10.0.0.4:2379 --cert /etc/etcd/server.crt --cacert /etc/etcd/etcd-ca.crt --key /etc/etcd/server.key put foo bar
OK

maihuabao@etcd1<10:44:33>:    cd ~/
# etcdctl --endpoints https://10.0.0.5:2379 --cert /etc/etcd/server.crt --cacert /etc/etcd/etcd-ca.crt --key /etc/etcd/server.key get foo
foo
bar
```

## 测试健康状态

```sh
# curl --cacert /etc/etcd/etcd-ca.crt --cert /etc/etcd/server.crt --key /etc/etcd/server.key https://10.0.0.4:2379/health
{"health":"true"}
```

## 新增mac终端成员

随便找个目录都可以运行

```sh
#第一步去到找到集群的leader，新增一个成员
# 操作之前先备份
etcdctl --endpoints=http://10.0.0.4:2380 snapshot save snapshot.db

# etcdctl member add mac1 http://10.0.0.1:2380

Added member named mac1 with ID 31ebbfc6903838a1 to cluster

ETCD_NAME="mac1"
ETCD_INITIAL_CLUSTER="mac1=http://10.0.0.1:2380,etcd01=http://10.0.0.4:2380,etcd02=http://10.0.0.5:2380"
ETCD_INITIAL_CLUSTER_STATE="existing"
# etcdctl member list
31ebbfc6903838a1[unstarted]: peerURLs=http://10.0.0.1:2380
aeb6950c050a83f3: name=etcd01 peerURLs=http://10.0.0.4:2380 clientURLs=http://10.0.0.4:2379 isLeader=true
c496e9114bd232df: name=etcd02 peerURLs=http://10.0.0.5:2380 clientURLs=http://10.0.0.5:2379 isLeader=false

#回到mac主机
#先确保数据目录都删了，
rm -rf default.etcd mac1.etcd

# 然后加入集群， 注意最后的 existing 新增的节点用这个。        如果是初始化，就用new
etcd --name mac1 -advertise-client-urls http://10.0.0.1:2379 -listen-client-urls http://0.0.0.0:2379 -initial-advertise-peer-urls http://10.0.0.1:2380 -listen-peer-urls http://0.0.0.0:2380 -initial-cluster-token etcd-cluster -initial-cluster "mac1=http://10.0.0.1:2380,etcd01=http://10.0.0.4:2380,etcd02=http://10.0.0.5:2380" -initial-cluster-state existing

# 检查各节点信息
# etcdctl member list
31ebbfc6903838a1: name=mac1 peerURLs=http://10.0.0.1:2380 clientURLs=http://10.0.0.1:2379 isLeader=false
aeb6950c050a83f3: name=etcd01 peerURLs=http://10.0.0.4:2380 clientURLs=http://10.0.0.4:2379 isLeader=true
c496e9114bd232df: name=etcd02 peerURLs=http://10.0.0.5:2380 clientURLs=http://10.0.0.5:2379 isLeader=false
```

## 测试

```sh
export ETCDCTL_API=3

# 任意一台set，另外2台都能get到
etcdctl get foo
etcdctl put foo etcd2222222222
etcdctl put foo1 etcd111

➜ etcdctl get --prefix foo
foo
etcd2222222222
foo1
etcd111

➜ etcdctl get foo
foo
etcd2222222222
```