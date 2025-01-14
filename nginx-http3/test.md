## build 参考：https://github.com/macbre/docker-nginx-http3

```sh
# 自建证书
mkdir -p "./ssl" && cd ./ssl && openssl genrsa -out server.key 2048
openssl req -new -key server.key -out server.csr -subj "/C=CN/ST=Beijing/L=Beijing/O=MyCompany/OU=IT/CN=abc.tech/emailAddress=admin@abc.tech"
openssl x509 -req -days 3650 -in server.csr -signkey server.key -out server.crt
chmod 644 server.key
cd -

docker rm -f ng && docker rmi nginx-http3
docker build -t nginx-http3 .
docker run -dit --name ng \
  --restart=unless-stopped \
  -v ./ssl:/ssl \
  -p 80:80 \
  nginx-http3

# 测试  --成功
docker run -t --rm --user root alpine/curl-http3 sh -c 'addr=csgo.com;echo 140.245.61.230 $addr >>/etc/hosts && curl -v -k --http3 https://$addr'
```
