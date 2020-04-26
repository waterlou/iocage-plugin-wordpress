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
sed -i '' -e "s/database_name_here/${DB}/g" ${CFG}
sed -i '' -e "s/username_here/${USER}/g" ${CFG}
sed -i '' -e "s/password_here/${PASS}/g" ${CFG}

SECRETKEY=/root/.secretkey
curl https://api.wordpress.org/secret-key/1.1/salt/ > ${SECRETKEY}
count=0
while IFS= read -r line
do
  case $count in
    0)
      key="'AUTH_KEY'" ;;
    1)
      key="'SECURE_AUTH_KEY'" ;;
    2)
      key="'LOGGED_IN_KEY'" ;;
    3)
      key="'NONCE_KEY'" ;;
    4)
      key="'AUTH_SALT'" ;;
    5)
      key="'SECURE_AUTH_SALT" ;;
    6)
      key="'LOGGED_IN_SALT'" ;;
    7)
      key="'NONCE_SALT'" ;;
    *)
      key="____NOKEY____" ;;
  esac
  sed -i '' -e "/${key}/ c\\
${line}" ${CFG}
  count=$((count+1))
  # echo "$line"
done < ${SECRETKEY}

rm ${SECRETKEY}

chown -R www:www ${WORDPRESS_PATH}
