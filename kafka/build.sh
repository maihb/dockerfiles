# clone
git clone https://github.com/wurstmeister/kafka-docker.git && cd kafka-docker
# 启动
docker-compose up -d
docker-compose ps

# 创建新主题
#docker  exec kafka-docker_kafka_1 kafka-topics.sh --create --topic test-topic --bootstrap-server localhost:9092 --partitions 1 --replication-factor 1
docker exec kafka-docker_kafka_1 kafka-topics.sh --create --topic test-topic -zookeeper kafka-docker_zookeeper_1:2181 --partitions 1 --replication-factor 1
# 列出主题
docker exec kafka-docker_kafka_1 kafka-topics.sh --list --zookeeper kafka-docker_zookeeper_1:2181
# 生产消息
docker exec kafka-docker_kafka_1 kafka-console-producer.sh --topic test-topic --bootstrap-server localhost:9092
# 消费消息
docker exec kafka-docker_kafka_1 kafka-console-consumer.sh --topic test-topic --bootstrap-server localhost:9092 --from-beginning
