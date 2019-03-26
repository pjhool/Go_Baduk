cd $DGS_ROOT 

cp images/favicon.ico  .
cp images/apple-touch-icon-*.png . 


sudo apt-get install mysql-client 

cd /opt/lampp/bin 
./mysqladmin -u root PASSWORD 1234 


xampp에서 패스워드 설정후 phpMyAdmin 패스워드를 동일하게 변경해주어야 합니다.

경로 : xampp/phpMyAdmin/config.inc.php

config.inc.php 파일상에서 “$cfg[‘Servers’][$i][‘password’]” 항목을 검색후 변경한 root password 입력하고 저장 합니다.



/opt/lampp/bin/mysql -u root -p1234

#mysql -u user -p -e 'Your SQL Query Here' database-name

/opt/lampp/bin/mysql -u root -p1234 -e 'CREATE DATABASE dragondb


mysql -h localhost -u dragon_admin -D dragondb -p < specs/db/dragon-ddl.sql  

