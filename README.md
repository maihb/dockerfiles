# dockerfiles
各种镜像打包

## 启动命令

```sh
git clone https://github.com/maihb/dockerfiles.git
cd dockerfiles

#python-latest
docker build -t maihb/py-ssh python-ssh
docker run -d --name py -p 6022:22 maihb/py-ssh

#golang-dev-ssh
docker build -t maihb/golang-dev-ssh golang-dev-ssh
docker run -d --name dev -v "$(pwd):/code" -p 7022:22 maihb/golang-dev-ssh

#纯净版 git
docker build -t maihb/git-ssh git-ssh
docker run -d --name git -p 7022:22 -v "$(pwd):/repo:ro" maihb/git-ssh
#test
git clone ssh://git@localhost:7022/repo/xx #xx 为 git 目录
```
