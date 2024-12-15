docker build -t qr-code-server .
docker run -d -p 8500:8500 qr-code-server

http://localhost:8500/generate_qr?data=Hello%20Docker
