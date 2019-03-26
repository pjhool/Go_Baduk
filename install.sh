cd $DGS_ROOT 

cp images/favicon.ico  .
cp images/apple-touch-icon-*.png . 


sudo apt-get install mysql-client 

cd /opt/lampp/bin 
./mysqladmin -u root PASSWORD 1234 


/opt/lampp/bin/mysql -u root -p1234

#mysql -u user -p -e 'Your SQL Query Here' database-name

/opt/lampp/bin/mysql -u root -p1234 -e 'CREATE DATABASE dragondb


mysql -h localhost -u dragon_admin -D dragondb -p < specs/db/dragon-ddl.sql  

