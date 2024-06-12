# from https://github.com/segmentio/kafka-go.git
# 启动
docker-compose up -d
docker-compose ps

# 创建新主题
docker exec kafka kafka-topics.sh --create --topic task -zookeeper zookeeper:2181 --partitions 1 --replication-factor 1
# 列出主题
docker exec kafka kafka-topics.sh --list --zookeeper zookeeper:2181
# 生产消息
docker exec kafka kafka-console-producer.sh --topic test-topic --broker-list localhost:9092
# 消费消息
docker exec kafka kafka-console-consumer.sh --topic test-topic --bootstrap-server localhost:9092 --from-beginning
