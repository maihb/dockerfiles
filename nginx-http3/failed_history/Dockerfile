# 使用官方的 Nginx 镜像作为基础镜像
FROM nginx:stable-alpine as build

# 安装依赖
RUN apk update && apk add --no-cache \
    build-base \
    git \
    bash \
    wget \
    curl \
    zlib-dev \
    pcre-dev \
    openssl \
    openssl-dev \
    libxslt-dev \
    gd-dev \
    libc-dev \
    cmake

RUN mkdir -p "/ssl" && cd /ssl && \
    openssl genrsa -out server.key 2048 && \
    openssl req -new -key server.key -out server.csr -subj "/C=CN/ST=Beijing/L=Beijing/O=MyCompany/OU=IT/CN=abc.tech/emailAddress=admin@abc.tech" && \
    openssl x509 -req -days 3650 -in server.csr -signkey server.key -out server.crt

# 获取并编译 BoringSSL
WORKDIR /tmp
RUN git clone https://github.com/google/boringssl.git && \
    cd boringssl && \
    cmake . && \
    make -j$(nproc) && \
    make install

# 获取 Nginx 源代码
WORKDIR /tmp
RUN wget https://nginx.org/download/nginx-1.27.3.tar.gz && \
    tar -zxvf nginx-1.27.3.tar.gz 

# 编译 Nginx 并启用 QUIC 和 HTTP/3 模块
WORKDIR /tmp/nginx-1.27.3
RUN ./configure \
    --with-debug \
    --conf-path=/etc/nginx/nginx.conf \
    --with-http_v3_module \
    --with-http_v2_module \
    --with-cc-opt="-I/tmp/boringssl/include" \
    --with-ld-opt="-L/tmp/boringssl/build/ssl -L/tmp/boringssl/build/crypto" && \
    make -j$(nproc) && \
    make install

# 使用 nginx:stable-alpine 作为运行时镜像
FROM nginx:stable-alpine

# 安装 BoringSSL 运行时依赖
RUN apk add --no-cache \
    libssl1.1 \
    libcrypto1.1

# 将编译后的 Nginx 安装内容复制到新的镜像中
COPY --from=build /usr/local/nginx /usr/local/nginx
COPY --from=build /usr/local/bin/nginx /usr/local/bin/nginx
COPY --from=build /usr/local/sbin/nginx /usr/local/sbin/nginx
COPY --from=build /etc/nginx /etc/nginx
COPY --from=builder /ssl /ssl

# 将 BoringSSL 动态库复制到目标容器中
COPY --from=build /usr/local/lib /usr/local/lib

# 复制 Nginx 配置文件（假设你已经配置好了）
COPY nginx.conf /etc/nginx/nginx.conf

# 暴露端口
EXPOSE 80
EXPOSE 443
EXPOSE 443/udp

# 设置工作目录并启动 Nginx
WORKDIR /
CMD ["nginx", "-g", "daemon off;"]
