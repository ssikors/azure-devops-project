#! /bin/bash

DATABASE_PORT=$1
DATABASE_USER=$2
DATABASE_PASSWORD=$3
MASTER_ADDRESS=$4
MASTER_PORT=$5

MY_SQL_CONFIG="/etc/mysql/mysql.conf.d/mysqld.cnf"
INIT_DATABASE="https://raw.githubusercontent.com/spring-petclinic/spring-petclinic-rest/master/src/main/resources/db/mysql/initDB.sql"
POPULATE_DATABASE="https://raw.githubusercontent.com/spring-petclinic/spring-petclinic-rest/master/src/main/resources/db/mysql/populateDB.sql"

cd ~/

# Instalation
sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get autoremove -y

sudo apt-get install mysql-server -y
sudo apt-get install wget -y

# Download config files


echo "CREATE USER '$DATABASE_USER'@'%' IDENTIFIED BY '$DATABASE_PASSWORD';" >>user.sql
echo "GRANT ALL PRIVILEGES ON *.* TO '$DATABASE_USER'@'%' WITH GRANT OPTION;" >>user.sql


wget $INIT_DATABASE
wget $POPULATE_DATABASE



# Update configuration
# sudo cp /etc/mysql/mysql.conf.d/mysqld.cnf $MY_SQL_CONFIG

# sudo chmod 646 $MY_SQL_CONFIG 

# sudo echo "port = $DATABASE_PORT" >> $MY_SQL_CONFIG
# sudo echo "server-id = 2" >> $MY_SQL_CONFIG
# sudo echo "read_only = 1" >> $MY_SQL_CONFIG
# sudo echo "log_bin = /var/log/mysql/mysql-bi.log" >> $MY_SQL_CONFIG

sudo sed -i "s/127.0.0.1/0.0.0.0/g" $MY_SQL_CONFIG
sudo sed -i "s/.*server-id.*/server-id = 2/" $MY_SQL_CONFIG
sudo sed -i "s/3306/$DATABASE_PORT/" $MY_SQL_CONFIG
sudo sed -i "1s/^/USE petclinic;\n/" ./populateDB.sql

cat $MY_SQL_CONFIG

# sudo chmod 600 $MY_SQL_CONFIG


# Run sql
cat ./user.sql | sudo mysql -f
cat ./initDB.sql | sudo mysql -f
cat ./populateDB.sql | sudo mysql -f

# mysql --defaults-file=~/.my.cnf

# Restart service
sudo service mysql restart

STATEMENT="CHANGE MASTER TO MASTER_HOST='${MASTER_ADDRESS}', MASTER_PORT=${MASTER_PORT}, MASTER_USER='replicate', MASTER_PASSWORD='slave_pass';"


sudo mysql -v -e "${STATEMENT}"
sudo mysql -v -e "FLUSH PRIVILEGES;"
sudo mysql -v -e "START SLAVE;"
sudo mysql -v -e "SHOW SLAVE STATUS\G;"


