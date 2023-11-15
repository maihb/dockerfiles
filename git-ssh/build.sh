docker rm -f gg
docker rmi mygit
docker build -t mygit .
docker run -d --name gg -p 22:22 -v "$(pwd):/repo" mygit
