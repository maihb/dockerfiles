# from https://github.com/segmentio/kafka-go.git
# 启动
docker-compose up -d
docker-compose ps

# 创建新主题
docker exec kafka kafka-topics.sh --create --topic task --bootstrap-server localhost:9092 --partitions 1 --replication-factor 1
# 列出主题
docker exec kafka kafka-topics.sh --list --bootstrap-server localhost:9092
# 生产消息
docker exec kafka kafka-console-producer.sh --topic task --broker-list localhost:9092
# 消费消息
docker exec kafka kafka-console-consumer.sh --topic task --bootstrap-server localhost:9092 --from-beginning
