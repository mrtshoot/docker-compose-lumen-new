# Docker Compose for Lumen Infrastructure
this repository provide lumen infrastructure with docker compose orchestrator

### Step1
go to /opt and clone this repository
```
cd /opt;git clone http://git.mobtaker.local/mobtaker-team/docker-compose-lumen.git
```

### Step2
change your directory to cloned directory and cp your env files for php and db and phpmyadmin images and change it to your own information.
```
cp .env/.db.env.example .env/db.env
cp .env/.php.env.example .env/php.env
cp .env/.phpmyadmin.env.example .env/phpmyadmin.env
```

### Step3
cp your local.ini file for php configuration files and add any setting you have like.
```
cp php/.local.ini.example php/local.ini
```

### Step4
cp your app.conf and pma.conf nginx configuration file for server proxy and PMA web pannel and add your setting.notice that check your whitelist ip on pma.conf
```
cp nginx/conf.d/.app.conf.example nginx/conf.d/app.conf
cp nginx/conf.d/.pma.conf.example nginx/conf.d/pma.conf
```
### Step5
cp your mysql configuration file
```
cp mysql/.my.cnf.example mysql/my.cnf
```

### Step6
set your project name to configure files and folder
```
sed -i 's/yourprojectname/ENTER_YOUR_NAME_HERE/g' docker-compose.yml Dockerfile
```

### Step7
create your lumen directory project and clone developer lumen project.if you dont have any project you should create it with this link https://lumen.laravel.com/docs/6.x
```
mkdir lumen-app;cd lumen-app;git clone <Repo URL> <yourprojectname>
```

### Step8
Install composer
```
cd yourprojectname;docker run --rm -v $(pwd):/app composer install;cd ../..
```
if you have local repo run following command
```
cd yourprojectname;docker run --rm -v $(pwd):/app YOUR_PRIVATE_REGISTRY_URL/composer install;cd ../..
```

### Step9 (Optional)
Change your docker images with your local repository if you needed.


#### Notice
if you need create project you should follow this.otherwise skip this.
```
cd lumen-app;docker run --rm -v $(pwd):/app composer create-project --prefer-dist laravel/lumen yourprojectname
```

### Step10
change environment variable for lumen with following configuration
```
cp lumen-app/yourprojectname/.env.example lumen-app/yourprojectname/.env
```

Change Following Configuration on lumen-app/.env
```
DB_CONNECTION=mysql
DB_HOST=db
DB_PORT=3306
DB_DATABASE=laravel
DB_USERNAME=laraveluser
DB_PASSWORD=your_laravel_db_password
```

### Step11
change permission for lumen project to access on it
```
sudo chown -R $USER:$USER lumen-app/
```

### Step12
Set hostname for php app on docker-compose file if you needed.

### Step13
Configure SSH Access to PHP Application for Developers
1. Change SSH port to your own random port in docker-compose 
2. Copy example ssh configuration file and change it base on yourself
```
cp ssh_accounts/.sshd_config.example ssh_accounts/sshd_config;cp ssh_accounts/.authorized_keys.example ssh_accounts/authorized_keys
```
3. Input developer ssh public key at the end of ssh_accounts/authorized_keys with specific comment for example name and family


### Step14
run docker compose command
```
docker-compose up -d --build
```

### Step15
Restart ssh service for php app
```
docker-compose exec -u root app service ssh restart
```

### Step16
Creating a User for MySQL
```
docker-compose exec db bash
```
and then 
```
mysql -u root -p
```

on mysql command line to see all databases run
```
show databases;
```

Grant Permission to your user on specific database
```
GRANT ALL ON laravel.* TO 'laraveluser'@'%' IDENTIFIED BY 'your_laravel_db_password';
```

Flush the privileges to notify the MySQL server of the changes:
```
FLUSH PRIVILEGES;
```
and exit from mysql and container mysql


### Step17
You can Migrate your laravel with following command
```
docker-compose exec app php artisan migrate
```

