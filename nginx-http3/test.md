## build

```sh
docker rm -f nginx && docker rmi nginx-http3
docker build -t nginx-http3 .
docker run -dit --name nginx --restart=unless-stopped \
    -p 80:80 \
    nginx-http3
```
