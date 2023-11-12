# dockerfiles
各种镜像打包

## 启动命令

```sh
#python 2.7
docker build -t maihb/py2-ssh python2.7-ssh
docker run -d --name py2 -p 6022:22 maihb/py2-ssh
```
