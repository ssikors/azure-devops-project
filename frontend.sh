backendIp="$1"
backendPort="$2"
selfPort="$3"

sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get install npm -y

cd $HOME

# Installing nvm 
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

nvm install 16.14.1


git clone https://github.com/spring-petclinic/spring-petclinic-angular.git
cd spring-petclinic-angular

# Setting backend IP and port
sed -i "s/localhost/$backendIp/g" src/environments/environment.ts src/environments/environment.prod.ts
sed -i "s/9966/$backendPort/g" src/environments/environment.ts src/environments/environment.prod.ts

npm install -g @angular/cli@latest
npm install
ng analytics off

npm install angular-http-server

npm run build --prod
npx angular-http-server --path ./dist -p $selfPort &
