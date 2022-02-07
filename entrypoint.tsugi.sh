#!/bin/bash

cd /var/www/html/tsugi
touch health.ok
cd /var/www/html/tsugi/mod/curriki
composer install

apache2ctl -D FOREGROUND
