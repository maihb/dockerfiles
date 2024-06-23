docker rm -f git
img=my-git-ssh
docker rmi $img
docker build -t $img .
docker run -d --name git --restart=unless-stopped -p 7022:22 -v "/code:/code" $img

# 如果报错： git config --global --add safe.directory
# 需要进入容器 docker  exec -it git bash
# chown -R git:root /code/xxxx
