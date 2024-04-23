docker rm -f ms && docker rmi myfs
docker build -t myfs .
docker run -d --name ms --restart=unless-stopped \
    -v ~/upload/:/dl \
    -p 8091:8080 \
    -p 522:22 \
    --hostname root \
    myfs
