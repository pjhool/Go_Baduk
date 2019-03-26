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
mysql -h localhost -u dragon_admin -D dragondb -p < specs/db/dragon-data.sql   


mkdir translations
sudo su -c 'chgrp www-data translations'
chmod 775 translations/

# cp include/config.php include/config-local.php 
#   export PATH=/opt/lampp/bin:$PATH 

pushd scripts
php make_all_translationfiles.php
popd



sudo su -c 'chgrp www-data include/config-local.php' 
chmod 640 include/config-local.php 


 mkdir temp
 chmod 775 temp
 sudo  su -c 'chgrp www-data temp' 
 
 mkdir temp/userpic
  ln -s temp/userpic .
 sudo  su -c 'chgrp www-data temp/userpic'
 suod  su -c 'chmod g+ws temp/userpic'
 
 cd .. 
 mkdir data-store
  mkdir data-store/rss data-store/qst data-store/wap
  chmod -R 775 data-store
 sudo  su -c 'chgrp -R www-data data-store'
 

# edit my.cnf 

# [mysqld ]  
ft_min_word_len  =  1   #  (default-value is 4)

mysql > REPAIR TABLE Messages QUICK
mysql > REPAIR TABLE Posts QUICK 
 
 

