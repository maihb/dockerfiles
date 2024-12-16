docker rmi qr-code-server; docker build -t qr-code-server .
docker rm -f qr;docker run -d --name qr -p 8500:8500 qr-code-server && docker logs -f qr

http://localhost:8500/generate_qr?data=Hello%20Docker
