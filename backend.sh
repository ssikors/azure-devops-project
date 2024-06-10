# parameters for customizaiton
backend_port="$1"
database_ip="$2"
database_port="$3"
db_user="$4"
db_pswd="$5"

# go to home directory
cd ~

# update, upgrade, install
sudo apt update
sudo apt upgrade -y
sudo apt install -y openjdk-17-jdk

# Get application code (backend)
git clone https://github.com/spring-petclinic/spring-petclinic-rest.git

cd spring-petclinic-rest
# Changing application files to reflect parameters
sed -i "s/9966/$backend_port/g" src/main/resources/application.properties src/test/resources/application.properties

sed -i "s/=hsqldb/=mysql/g" ./src/main/resources/application.properties

sed -i "s/localhost/$database_ip/g" ./src/main/resources/application-mysql.properties
sed -i "s/3306/$database_port/g" ./src/main/resources/application-mysql.properties
sed -i "s/pc/$db_user/g" ./src/main/resources/application-mysql.properties
sed -i "s/=petclinic/=$db_pswd/g" ./src/main/resources/application-mysql.properties

# Run backend
sudo ./mvnw spring-boot:run &