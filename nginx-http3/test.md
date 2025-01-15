## build 参考：https://github.com/macbre/docker-nginx-http3

```sh
docker rm -f nx && docker rmi nginx-http3
docker build -t nginx-http3 .
docker run -dit --name nx \
  --restart=unless-stopped \
  -p 80:80 \
  -p 443:443/udp \
  nginx-http3

# 测试  --成功
docker run -t --rm --user root alpine/curl-http3 sh -c 'addr=csgo.com;echo 140.245.61.230 $addr >>/etc/hosts && curl -v -k --http3 https://$addr'
```
