# 使用 Alpine 作为基础镜像
FROM python:3.9-alpine

# 安装依赖工具：编译器、基础库和 qrencode 所需的依赖
RUN apk add --no-cache \
    gcc \
    g++ \
    make \
    libtool \
    automake \
    autoconf \
    pkgconfig \
    cairo-dev \
    pango-dev \
    icu-dev \
    git

# 克隆并编译 qrencode
RUN git clone https://github.com/fukuchi/libqrencode.git /tmp/libqrencode \
    && cd /tmp/libqrencode \
    && autoreconf -vfi \
    && ./configure --prefix=/usr/local \
    && make \
    && make install \
    && rm -rf /tmp/libqrencode

# 安装 Flask
RUN pip install flask

# 创建应用目录
WORKDIR /app

# 复制二维码生成服务的 Python 文件
COPY generate_qr.py /app/

# 开放 8500 端口
EXPOSE 8500

# 设置容器启动命令
CMD ["python", "generate_qr.py"]
