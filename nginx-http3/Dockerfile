# 使用一个轻量级的基础镜像，比如 Debian
FROM debian:bullseye-slim

# 安装必要的构建工具和依赖
RUN apt-get update && \
    apt-get install -y \
    build-essential \
    libssl-dev \
    wget \
    libpcre3-dev \
    zlib1g-dev \
    libgd-dev \
    libgeoip-dev \
    libmaxminddb-dev \
    clang \
    llvm \
    libicu-dev \
    make \
    git \
    curl \
    cmake && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# 安装 Rust 工具链
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y && \
    export PATH="$HOME/.cargo/bin:$PATH" && \
    rustup default stable

# 下载并解压 Nginx 源码
WORKDIR /usr/src/nginx
RUN wget http://nginx.org/download/nginx-1.25.2.tar.gz && \
    tar -zxvf nginx-1.25.2.tar.gz

# 进入 Nginx 源码目录
WORKDIR /usr/src/nginx/nginx-1.25.2

# 克隆并安装 QUIC 支持的 quiche 库
RUN git clone --recursive https://github.com/cloudflare/quiche /usr/src/quiche && \
    cd /usr/src/quiche && \
    PATH="$HOME/.cargo/bin:$PATH" cargo build --release && \
    cd /usr/src/nginx/nginx-1.25.2

# 配置编译选项，开启 HTTP/3 支持
RUN ./configure \
    --prefix=/usr/local/nginx \
    --with-http_ssl_module \
    --with-http_v3_module \
    --with-debug \
    --with-http_gzip_static_module \
    --with-http_realip_module \
    --with-http_addition_module \
    --with-http_sub_module \
    --with-http_dav_module \
    --with-http_flv_module \
    --with-http_mp4_module \
    --with-http_gunzip_module \
    --with-http_geoip_module \
    --with-http_image_filter_module \
    --with-http_random_index_module \
    --with-http_secure_link_module \
    --with-http_stub_status_module \
    --with-cc-opt="-I/usr/src/quiche/include" \
    --with-ld-opt="-L/usr/src/quiche/target/release" && \
    make && make install

# 创建 Nginx 用户
RUN useradd -r -M nginx

# 复制 Nginx 配置文件
COPY nginx.conf /usr/local/nginx/conf/nginx.conf

# 暴露端口
EXPOSE 80
EXPOSE 443
EXPOSE 443/udp

WORKDIR /usr/local/nginx/

# 启动 Nginx
CMD ["sbin/nginx", "-g", "daemon off;"]
