## build

```sh
docker rm -f ng && docker rmi nginx-http3
docker build -t nginx-http3 .
docker run -dit --name ng --restart=unless-stopped \
    -p 80:80 \
    nginx-http3
```
