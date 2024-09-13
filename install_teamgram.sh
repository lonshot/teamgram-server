#!/bin/bash

BASE=./teamgram
ETCD_VERSION=3.5.0

command_exists() {
    command -v "$@"
}

# Check if script is running with root privileges
if [ "$EUID" -ne 0 ]; then
    echo "[!] Please run as root"
    exit
fi

BASE=$(realpath $BASE)

echo "[i] Starting Teamgram Server Installation"
echo "[i] Installation path is $BASE"

echo "[i] Installing basic dependencies"
command_exists git || {
    echo "[+] Installing git..."
    apt install git -y
}
command_exists curl || {
    echo "[+] Installing curl..."
    apt install curl -y
}
command_exists make || {
    echo "[+] Installing make..."
    apt install make -y
}

echo "[i] Creating installation directory"
if [ -d $BASE ]; then
    echo "[+] Removing existing installation directory..."
    rm -rf $BASE
fi
mkdir -p $BASE/bin
mkdir -p $BASE/tmp

echo "[i] Downloading and installing dependencies for teamgram-server"

# Installing MySQL 5.7
echo "[+] Installing MySQL server 5.7..."
apt-get remove --purge mysql* -y  # Remove any existing MySQL installations
apt-get autoremove -y
apt-get autoclean

wget https://dev.mysql.com/get/mysql-apt-config_0.8.13-1_all.deb -O $BASE/tmp/mysql-apt-config.deb
DEBIAN_FRONTEND=noninteractive dpkg -i $BASE/tmp/mysql-apt-config.deb
sed -i 's/mysql-8.0/mysql-5.7/' /etc/apt/sources.list.d/mysql.list
apt update
DEBIAN_FRONTEND=noninteractive apt-get install mysql-server=5.7.* -y

echo "[+] Installing Redis server..."
apt install redis-server -y

echo "[+] Installing etcd-io..."
curl -L https://github.com/etcd-io/etcd/releases/download/v$ETCD_VERSION/etcd-v$ETCD_VERSION-linux-amd64.tar.gz -o $BASE/tmp/etcd.tgz
mkdir $BASE/tmp/etcd
tar xzf $BASE/tmp/etcd.tgz -C $BASE/tmp/etcd --strip-components=1
mv $BASE/tmp/etcd/etcd $BASE/tmp/etcd/etcdctl $BASE/tmp/etcd/etcdutl $BASE/bin

echo "[+] Installing Kafka..."
apt install openjdk-17-jre -y
curl -L http://archive.apache.org/dist/kafka/2.2.1/kafka_2.11-2.2.1.tgz -o $BASE/tmp/kafka.tgz
mkdir $BASE/kafka
tar xzf $BASE/tmp/kafka.tgz -C $BASE/kafka --strip-components=1

echo "[+] Installing MinIO..."
curl -L https://dl.min.io/server/minio/release/linux-amd64/minio -o $BASE/bin/minio
curl -L https://dl.min.io/client/mc/release/linux-amd64/mc -o $BASE/bin/mc
chmod +x $BASE/bin/minio
chmod +x $BASE/bin/mc
$BASE/bin/minio server $BASE/data &
sleep 2
$BASE/bin/mc alias set minio http://localhost:9000 minioadmin minioadmin
$BASE/bin/mc admin user add minio minio miniostorage
$BASE/bin/mc admin policy set minio readwrite user=minio
$BASE/bin/mc mb minio/documents
$BASE/bin/mc mb minio/encryptedfiles
$BASE/bin/mc mb minio/photos
$BASE/bin/mc mb minio/videos

echo "[+] Installing PIKA..."
curl -L https://github.com/OpenAtomFoundation/pika/releases/download/v3.3.6/pika-linux-x86_64-v3.3.6.tar.bz2 -o $BASE/tmp/pika.tar.bz2
mkdir $BASE/pika
tar xf $BASE/tmp/pika.tar.bz2 -C $BASE/pika --strip-components=1

echo "[+] Installing FFMpeg"
curl -L https://johnvansickle.com/ffmpeg/releases/ffmpeg-release-amd64-static.tar.xz -o $BASE/tmp/ffmpeg.tar.xz
mkdir $BASE/tmp/ffmpeg
tar xf $BASE/tmp/ffmpeg.tar.xz -C $BASE/tmp/ffmpeg --strip-components=1
mv $BASE/tmp/ffmpeg/ff* /usr/local/bin

echo "[+] Installing go..."
curl -L https://go.dev/dl/go1.19.4.linux-amd64.tar.gz -o $BASE/tmp/go.tar.gz
rm -rf /usr/local/go
mkdir /usr/local/go
tar xf $BASE/tmp/go.tar.gz -C /usr/local/go --strip-components=1
export PATH=$PATH:/usr/local/go/bin

echo "[i] Installing Teamgram Server"
echo "[+] Cloning teamgram-server..."
git clone https://github.com/teamgram/teamgram-server.git $BASE/teamgram-server
echo "[i] Setting up MySQL Database for Teamgram"

# Start MySQL service if not already running
systemctl start mysql

# Drop the 'teamgram' database if it exists and create a new one
mysqladmin -u root -p -f drop teamgram || true
mysqladmin -u root -p -f create teamgram

# Import the base schema
echo "[+] Importing base schema: teamgramd/sql/1_teamgram.sql"
mysql -u root -p teamgram < $BASE/teamgram-server/teamgramd/sql/1_teamgram.sql

# Import all migration files in order
echo "[+] Applying migration files..."
MIGRATE_FILES=$(ls -v $BASE/teamgram-server/teamgramd/sql/migrate-*.sql)  # Sorted by version
for m in $MIGRATE_FILES; do
    echo "[+] Importing migration file: $m"
    mysql -u root -p teamgram < $m
done

# Import the initialization file
echo "[+] Importing initialization file: teamgramd/sql/z_init.sql"
mysql -u root -p teamgram < $BASE/teamgram-server/teamgramd/sql/z_init.sql

echo "[i] MySQL Database setup completed!"

make -C $BASE/teamgram-server

echo "[i] Removing temporary files..."
rm -rf $BASE/tmp
echo "[i] Teamgram Server successfully installed!"
