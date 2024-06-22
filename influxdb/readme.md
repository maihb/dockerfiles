docker run -dit\
 --name influxdb2 \
 --publish 8086:8086 \
 --mount type=volume,source=influxdb2-data,target=/var/lib/influxdb2 \
 --mount type=volume,source=influxdb2-config,target=/etc/influxdb2 \
 --env DOCKER_INFLUXDB_INIT_MODE=setup \
 --env DOCKER_INFLUXDB_INIT_USERNAME=mhb \
 --env DOCKER_INFLUXDB_INIT_PASSWORD=123123123 \
 --env DOCKER_INFLUXDB_INIT_ORG=mhb \
 --env DOCKER_INFLUXDB_INIT_BUCKET=test \
 influxdb:2


sudo apt-get update && sudo apt-get install telegraf
ubuntu@a1:~$ export INFLUX_TOKEN=o4bl0PplHarY8ifXQVQzE1z71TDKzdGKygpgnMKDUwQGbXRChb-NtRcgCJRhYDzF9SMvOIO0CMjK3mBHUPRi7g==
telegraf --config http://tk-db.mhb7.com:8086/api/v2/telegrafs/0d3a2947b4d99000