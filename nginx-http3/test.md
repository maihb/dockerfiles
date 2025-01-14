## build 参考：https://github.com/macbre/docker-nginx-http3

```sh
# 自建证书
mkdir -p "./ssl" && cd ./ssl && openssl genrsa -out server.key 2048
openssl req -new -key server.key -out server.csr -subj "/C=CN/ST=Beijing/L=Beijing/O=MyCompany/OU=IT/CN=abc.tech/emailAddress=admin@abc.tech"
openssl x509 -req -days 3650 -in server.csr -signkey server.key -out server.crt
cd -

docker rm -f ng && docker rmi nginx-http3
docker build -t nginx-http3 .
docker run -dit --name ng --restart=unless-stopped \
    -p 80:80 \
    nginx-http3
```
