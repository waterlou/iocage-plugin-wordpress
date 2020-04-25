#!/bin/sh

WORDPRESS_PATH=/usr/local/share/wordpress

mkdir -p ${WORDPRESS_PATH}
cd ${WORDPRESS_PATH}

git clone https://github.com/WordPress/WordPress.git .

CFG=/root/plugin_config

DB=`sysrc -f ${CFG} -n mysql_db`
USER=`sysrc -f ${CFG} -n mysql_user`
PASS=`sysrc -f ${CFG} -n mysql_pass`

CFG=${WORDPRESS_PATH}/wp-config.php
cp ${WORDPRESS_PATH}/wp-config-sample.php ${CFG}
sed -i '' "/put your unique phrase here/d" ${CFG}
sed -i '' -e "s/database_name_here/${DB}/g" ${CFG}
sed -i '' -e "s/username_here/${USER}/g" ${CFG}
sed -i '' -e "s/password_here/${PASS}/g" ${CFG}

SECRETKEY=/root/.secretkey 
curl https://api.wordpress.org/secret-key/1.1/salt/ > ${SECRETKEY}
cat ${SECRETKEY} >> ${CFG}
rm ${SECRETKEY}

chown -R www:www ${WORDPRESS_PATH}
