docker rm -f dev
docker rmi mydev
docker build -t mydev .
docker run -d --name dev -p 8422:22 -v "$(pwd):/code" mydev
