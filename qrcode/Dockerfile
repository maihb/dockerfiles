# 使用 Alpine 作为基础镜像
FROM python:3.9-alpine

# 安装 qrencode 和 Flask
RUN apk add --no-cache qrencode \
    && pip install flask

# 创建应用目录
WORKDIR /app

# 复制二维码生成服务的 Python 文件
COPY generate_qr.py /app/

# 开放 8500 端口
EXPOSE 8500

# 设置容器启动命令
CMD ["python", "generate_qr.py"]
