# 第一阶段：编译阶段
FROM debian:bullseye-slim AS builder

# 安装必要的构建工具和依赖
RUN apt-get update && \
    apt-get install -y \
    build-essential \
    libssl-dev \
    wget \
    libpcre3-dev \
    zlib1g-dev \
    clang \
    llvm \
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

# 克隆并编译 QUIC 支持的 quiche
RUN git clone --recursive https://github.com/cloudflare/quiche /usr/src/quiche && \
    cd /usr/src/quiche && \
    PATH="$HOME/.cargo/bin:$PATH" cargo build --release

# 配置编译选项并构建 Nginx
RUN ./configure \
    --prefix=/usr/local/nginx \
    --with-http_ssl_module \
    --with-http_v3_module \
    --with-debug \
    --with-cc-opt="-I/usr/src/quiche/include" \
    --with-ld-opt="-L/usr/src/quiche/target/release" && \
    make && make install

# 第二阶段：运行阶段
FROM debian:bullseye-slim

# 复制运行所需文件
COPY --from=builder /usr/local/nginx /usr/local/nginx

# 创建 Nginx 用户
RUN useradd -r -M nginx

# 复制 Nginx 配置文件
COPY nginx.conf /usr/local/nginx/conf/nginx.conf

# 暴露端口
EXPOSE 80
EXPOSE 443
EXPOSE 443/udp

# 设置工作目录并启动 Nginx
WORKDIR /usr/local/nginx/
CMD ["sbin/nginx", "-g", "daemon off;"]
