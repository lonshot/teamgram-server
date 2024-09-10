BASE=./teamgram
BIN=$BASE/bin

# Check if script running in root privilege
if [ "$EUID" -ne 0 ]
then
        echo "[!] Please run as root"
        exit
fi

echo "[+] Running MySQL server"
systemctl start mysql
echo "[+] Runnign Redis server"
systemctl start redis
echo "[+] Running etcd"
$BIN/etcd &
echo "[+] Running Kafka"
$BASE/kafka/bin/zookeeper-server-start-sh -daemon $BASE/kafka/config/zookeeper.properties
sleep 2
export KAFKA_HEAP_OPTS="-Xmx1G -Xms1G"
$BASE/kafka/bin/kafka-server-start.sh -daemon $BASE/kafka/config/server.properties
echo "[+] Running minio"
$BIN/minio server $BASE/data &
echo "[+] Running pika"
$BASE/pika/bin/pika -c $BASE/pika/config/pika.conf &
echo "[+] Running Teamgram Server"
$BASE/teamgram-server/teamgramd/bin/runall2.sh

echo "[i] Successfully started Teamgram Server"

~                                                          