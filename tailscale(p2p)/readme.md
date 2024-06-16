# p2p 汇总资料


## p2p内网穿透（headscale,tailscale)

from ：
https://www.hi-linux.com/posts/33684.html
https://arthurchiao.art/blog/how-nat-traversal-works-zh/
https://cloud.tencent.com/developer/article/1977129

githup: https://github.com/juanfont/headscale

```sh
sudo -i
wget https://github.com/juanfont/headscale/releases/download/v0.17.0/headscale_0.17.0_linux_amd64 -O /usr/local/bin/headscale

chmod 755 /usr/local/bin/headscale

#创建配置目录：
mkdir -p /etc/headscale
#创建目录用来存储数据与证书：
mkdir -p /var/lib/headscale
#创建空的 SQLite 数据库文件：
touch /var/lib/headscale/db.sqlite
#创建 Headscale 配置文件：
wget https://github.com/juanfont/headscale/raw/main/config-example.yaml -O /etc/headscale/config.yaml

```

* 修改配置等：
vim /etc/headscale/config.yaml 

```yaml
server_url: http://116.62.139.34:8081
unix_socket: /var/run/headscale.sock
private_key_path: /var/lib/headscale/private.key
noise:
  private_key_path: /var/lib/headscale/noise_private.key
```

* 配置后台服务：
vim /etc/systemd/system/headscale.service

```sh
[Unit]
Description=headscale controller
After=syslog.target
After=network.target

[Service]
Type=simple
User=headscale
Group=headscale
ExecStart=/usr/local/bin/headscale serve
Restart=always
RestartSec=5

# Optional security enhancements
NoNewPrivileges=yes
PrivateTmp=yes
ProtectSystem=strict
ProtectHome=yes
ReadWritePaths=/var/lib/headscale /var/run/headscale
AmbientCapabilities=CAP_NET_BIND_SERVICE
RuntimeDirectory=headscale

[Install]
WantedBy=multi-user.target
```

* 创建用户并启动服务

```sh
#创建用户
useradd headscale -d /home/headscale -m
#修改 /var/lib/headscale 目录的 owner：
chown headscale:headscale /var/lib/headscale
#Reload SystemD 以加载新的配置文件：
systemctl daemon-reload
#启动 Headscale 服务并设置开机自启：
systemctl enable --now headscale
#查看运行状态：
systemctl status headscale
#查看占用端口：
ss -tulnp|grep headscale
```


## p2p 服务器 （docker版本）

参考文档：https://fly97.cn/p/build-opensource-tailscale-with-Headscale/

mkdir config data
cd config
wget https://github.com/juanfont/headscale/raw/main/config-example.yaml -O config.yaml
修改配置：
```yaml
server_url: http://mydomain.com:8849
listen_addr: 0.0.0.0:8080
```

vim docker-compose.yaml

```yaml
    # alpine原始镜像不支持时区，要修改镜像，这里设置无效
    # environment:
    #   - TZ=Asia/Shanghai
version: '3.5'
services:
  headscale:
    image: headscale/headscale:latest-alpine
    container_name: hs
    volumes:
      - ./config:/etc/headscale
      - ./data:/var/lib/headscale
    ports:
      - 8849:8080
    command: headscale serve
    restart: unless-stopped
```
docker-compose up  -d  

* 创建命名空间
docker exec hs headscale namespaces create dev
docker exec hs headscale namespaces ls

* 查看客户端列表
docker exec hs headscale nodes list

* 生成授权码
docker exec hs headscale preauthkeys create --reusable -e 24h -n dev

得到，后续会用到:b46049e7aa976d16e4e87fe3cceaa55677351e97772a1858


以上服务器部署完毕

## mac版本：p2p客户端（tailscale）

打开：http://mydomain.com:8849/apple
下载：macOS AppStore profile 

mac版本：到系统设置->隐私与安全->描述文件，安装headscale证书

重启并登录tailscale， 网页会弹出下面代码。 复制到服务器运行即可。
 --记得修改具体的namespace

headscale -n dev nodes register --key nodekey:9cf78f2f9ab14aa24fe869fabaa16dae7a0fa3c0658d422e4e0374e0bbdbc458

## Linux版本客户端：

```sh
yum -y install yum-utils
yum-config-manager --add-repo https://pkgs.tailscale.com/stable/centos/7/tailscale.repo
yum -y install tailscale
systemctl enable --now tailscaled

tailscale up --login-server=http://mydomain.com:8849 --accept-routes=true --accept-dns=false

docker exec hs headscale -n dev nodes register --key nodekey:ea0684b11682aa80225539488af9761e7b62baec655b03a7595bee9ceaa6782c
 ```

 ### docker 版Linux客户端

```yaml
#网上找的例子，有几个参数不明所以，比如cap_add，以及最后的启动命令的软连接
version: '3.3'
services:
  tailscaled:
    container_name: ts
    image: tailscale/tailscale
    network_mode: host
    privileged: true
    restart: always
    cap_add: 
      - net_admin
      - sys_module
    volumes:
      - ./lib:/var/lib
      - /dev/net/tun:/dev/net/tun
    command: sh -c "mkdir -p /var/run/tailscale && ln -s /tmp/tailscaled.sock /var/run/tailscale/tailscaled.sock && tailscaled"
#docker run -d  --name ts  --net=host  --privileged  --cap-add=net_admin  --cap-add=sys_module  --restart=always  -v /var/lib:/var/lib  -v /dev/net/tun:/dev/net/tun  tailscale/tailscale sh -c "mkdir -p /var/run/tailscale && ln -s /tmp/tailscaled.sock /var/run/tailscale/tailscaled.sock && tailscaled"
```

官方文档: https://hub.docker.com/r/tailscale/tailscale

```sh
docker run -d --name=ts -v /var/lib:/var/lib -v /dev/net/tun:/dev/net/tun --network=host --privileged tailscale/tailscale tailscaled
```

* 路由重定向 --advertise-routes=$route

docker exec  ts tailscale up --login-server=http://mydomain.com:8849 --force-reauth --accept-routes=true --accept-dns=false --authkey b46049e7aa976d16e4e87fe3cceaa55677351e97772a1858 


## Android版客户端：
 比较麻烦直接贴网上教程：https://blog.csdn.net/easylife206/article/details/123861092

 官方开源代码:https://github.com/tailscale/tailscale-android

 ## windows 客户端

打开:http://mydomain.com:8849/windows
 按照其中的步骤操作即可。