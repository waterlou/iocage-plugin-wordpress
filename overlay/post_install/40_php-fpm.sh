#!/bin/sh
# Start the service

CFG=/usr/local/etc/php.ini
cp ${CFG}-production ${CFG}

CFG=/usr/local/etc/php-fpm.d/www.conf
cp ${CFG}.default ${CFG}
sed -i '' -e "s/;listen.owner/listen.owner/g" ${CFG}
sed -i '' -e "s/;listen.group/listen.mode/g" ${CFG}
sed -i '' -e "s/;listen.mode/listen.mode/g" ${CFG}
sed -i '' -e "s/listen = 127.0.0.1:9000/listen = \/tmp\/php-fpm.sock/g" ${CFG}

# sysrc php_fpm_enable=yes
service php-fpm start

