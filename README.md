# Go_Baduk
Go Baduk Service 
 - Go Server & Go Client 개발 
 

# XAMPP On Ubuntu 16.04 ( 32bit) 
*  1.7.3	Version  
   *   Apache 2.2.14	, MySQL 5.1.41	, Php 5.3.1	 
   *   Install XAMPP :  https://andyhat.co.uk/how-to/intermediate/installing-xampp-ubuntu-1110-and-1204 
   
*  http://code.iamkate.com/articles/xampp-version-history-apache-mysql-php/ 

# PHP5 Version History 
*  https://www.php.net/ChangeLog-5.php  

*  Install PHP5  ACE 3.1.9 
   *    https://i.justrealized.com/2012/install-apc-ubuntu-12-04/ 
   *    download :  https://pecl.php.net/package/apc 
   
# Short Setup    
0. Download sources with images:
```
git clone git://git.code.sf.net/p/dragongoserver/dgs-main DGS_ROOT

Or  download a snapshot from   <http://www.dragongoserver.net/snapshot.php>

Or  git clone ssh://USER@git.code.sf.net/p/dragongoserver/dgs-main DGS_ROOT


```

1. Copy or link  /images/favicon.ico  into the DGS_ROOT folder 
2. Copy all  /images/apple-touch-icon-*.png  into the DGS_ROOT folder to avoid 'page_not_found'-errors. 
3. Create a mysql database and one or more mysql users to access the database: 

 ```
    mysql> CREATE DATABASE dragondb;
    
    mysql> GRANT SELECT, INSERT, UPDATE, DELETE, CREATE TEMPORARY TABLES, LOCK TABLES, CREATE, ALTER, DROP
          ON dragondb.* TO dragon_admin@localhost IDENTIFIED BY 'adminsecret'; 
          
    mysql> GRANT SELECT, INSERT, UPDATE, DELETE, CREATE TEMPORARY TABLES, LOCK TABLES
          ON dragondb.* TO dragon_user@localhost IDENTIFIED BY 'secret';
    
 ```
 4. Create mysql tables:   
   ```
    > mysql -h mysqlhost -u dragon_admin -D dragondb -p < specs/db/dragon-ddl.sql 
    
    > mysql -h mysqlhost -u dragon_admin -D dragondb -p < specs/db/dragon-data.sql
    
  ``` 
  
5. Generate the translations files:
  ```
  > mkdir translations
  > su -c 'chgrp www-data translations'
  > chmod 775 translations/
  > pushd scripts
  > php make_all_translationfiles.php
  > popd
  
  
 optionally, add the latest translations. 
  The data file can be downloaded and extracted from:

   <http://www.dragongoserver.net/snapshot.php>

   gunzip Translationdata.mysql.gz
   mysql -D dragondb < Translationdata.mysql 
   
  
  ```

6. Mail Setup 
```
You need a working mailing setup for this, because a user-registration sends out a mail
with a validation-code to activate the new account. For the registered admin-user
you either temporarily set 'SEND_ACTIVATION_MAIL' to false in your 'include/config-local.php',
which bypasses the mail-activation, or you manually do the activation with the
"ACTIVATE"-statements shown below (2nd next paragraph):

   > mysql -D dragondb

   mysql> UPDATE Players SET Adminlevel=0xffff WHERE Handle='adminusernick';

Then, this user will be able to manage the other admins in the Admin-menu.

You may also need to manually activate the super-admins registration,
because sending email may not work yet sending out a verification-code
after the registration.

   # ACTIVATE-statements:
   mysql> UPDATE Players SET UserFlags=UserFlags & (4|8) WHERE Handle='adminusernick';
   mysql> UPDATE Verification AS V INNER JOIN Players AS P ON P.ID=V.uid
             SET V.Verified=NOW(), V.Counter=V.Counter+1 WHERE P.Handle='adminusernick';



```

7. Adjust config of software and adjust file permissions: 

```
7.1 Copy config-template and adjust for local configuration:

  > cp include/config.php include/config-local.php

7.2 Adjust 'include/config-local.php' to fit to your environment and needed set of
  DGS-features. For configuration of the cache read on first.
  

7.3 Edit permissions for include/config-local.php:

  Find out which group your webserver is using (e.g. www-data).
  > su -c 'chgrp www-data include/config-local.php'
  > chmod 640 include/config-local.php


7.4 Create the CACHE_FOLDER-directory (example):
  mkdir temp
  chmod 775 temp
  su -c 'chgrp www-data temp' 

7.5 Adjust USERPIC_FOLDER in the local config-file.
  Example using CACHE_FOLDER from above as storage:
    (assert that URL-part '/userpic' points to USERPIC_FOLDER-directory ) 
  mkdir temp/userpic
  ln -s temp/userpic .
  su -c 'chgrp www-data temp/userpic'
  su -c 'chmod g+ws temp/userpic'

7.6 Create a directory outside of the document-root with write-access for the webserver.
    This must be configured in "include/config-local.php" with DATASTORE_FOLDER.
  Create the DATASTORE_FOLDER-directory (example) and sub-dirs for RSS/quick-status/WAP:
 
  mkdir data-store
  mkdir data-store/rss data-store/qst data-store/wap
  chmod -R 775 data-store
  su -c 'chgrp -R www-data data-store'
  
7.7 Adjust the used timezone.
    This can be done by creating a file in DGS_ROOT:

     filename:              timeadjust.php
     content (for example): <?php $timeadjust = ...; ?>

7.8 Configure if you use an external ticket-system. 
    If you do NOT use an external ticket-system to track issues set the config 'TICKET_REF'
      to an empty string.  Otherwise you may configure a URL, so that the '<ticket issue>' DGS-tag
      can be used to reference issues in the external ticket-system.

7.9 If you want to adjust the source-code, please have a look to the notes in 'scripts/README.developers'
```

8. MySQL database config: 
```
 In order to support the forum search using a good full-text index,
  the real DragonGoServer <http://www.dragongoserver.net/> changed the
  following server variable:

     <http://dev.mysql.com/doc/refman/5.0/en/server-system-variables.html#sysvar_ft_min_word_len>

     ft_min_word_len  =  1     (default-value is 4)

  After the change you have to rebuild the index for the following tables with:

     REPAIR TABLE Messages QUICK
     REPAIR TABLE Posts QUICK
```     
9. PHP config:

```
  IMPORTANT NOTE: safe_mode should be OFF!

  By now, Dragon works with these PHP directives:

     allow_call_time_pass_reference = Off ;Unused
     allow_url_fopen = Off ;Unused
     always_populate_raw_post_data = Off ;Unused
     arg_separator.input = &
     arg_separator.output = "&amp;" ;or = "&"
     asp_tags = Off ;Unused
     default_charset = ;set to empty or commented
     default_mimetype = "text/html"
     error_reporting = E_ALL
     file_uploads = On ;else the pattern upload will be disabled
     gpc_order = GPC
     implicit_flush = Off ;Unused
     magic_quotes_gpc = Off ;Don't care
     magic_quotes_runtime = Off
     magic_quotes_sybase = Off
     max_execution_time = 30 ;except for some rebuilding scripts with large databases
     memory_limit = 24M
     output_buffering = Off
     post_max_size = 8M ;greater than upload_max_filesize if used
     precision = 14
     register_argc_argv = Off ;Unused
     register_globals = Off ;Don't care
     safe_mode = Off ;else safe_mode_allowed_env_vars= must allow putenv() to modify 'TZ'
    ;set sendmail_* options to your needs
     short_open_tag = Off ;Unused
     track_vars = On ;always enabled as of PHP 4.0.3
     upload_max_filesize = 2M ;if used
     variables_order = EGPCS ;or empty
    [MySQL]
     mysql.allow_persistent = Off ;Unused
     mysql.default_host = ;Unused
     mysql.default_user = ;Unused
     mysql.default_password = ;Unused
     mysql.max_links = -1 ;Unused
     mysql.trace_mode = Off  ; needed for FOUND_ROWS() to work, see config.php ALLOW_SQL_CALC_ROWS

 if using XDebug (or similar) for local PHP development:

  The max-nesting-level of xdebug must be raised, otherwise encoding JSON for the game-editor will fail
  (happens if ENABLE_GAME_VIEWER=true and game-page is used):

  Edit xdebug-config for PHP running in Apache, probably at "/etc/php5/apache2/conf.d/xdebug.ini" and
  adjust (or add) the following config-line:

     xdebug.max_nesting_level=1500

 OPTIONAL: for using FreeType-font drawing rating graphs:

 Check and adjust defines in 'include/graph.php':
  - TTF_PATH
  - TTF_NAME
  - TTF_HEIGHT

```
10. Add some cron jobs. These should preferrably be run on a remote machine, so that the  clock is not running when the network is down. 
```  
  Adjust MAILTO in crontab accordingly.

> crontab -e

----------------
# min  hour day  mon  weekday
# 0-59 0-23 0-31 0-12 0-7

# DGS-live-server triggering clocks
MAILTO= < EMAIL-OF-YOUR-CHOICE >

*/5  *  *  *  *   wget -q -O - http://www.dragongoserver.net/clock_tick.php
0,30 *  *  *  *   wget -q --read-timeout=1800 -O - http://www.dragongoserver.net/halfhourly_cron.php
58   *  *  *  *   wget -q -O - http://www.dragongoserver.net/hourly_cron.php
25   5  *  *  *   wget -q -O - http://www.dragongoserver.net/daily_cron.php
#7,22,37,52 * * * *   wget -q -O - http://www.dragongoserver.net/tournaments/cron_tournaments.php

```

11. Protect the scripts/ folder from outside access: 

```
 The scripts/ folder contains security-sensitive tools reserved to the developers  or the admins team.
 You have to protect it with an authentification process  (using, for example, the .htaccess AuthUserFile command) 
 or at least move the  whole folder outside the server root tree when you have used it.

```

