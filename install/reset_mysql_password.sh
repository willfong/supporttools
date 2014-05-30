awk '{ print ( $(NF) ) }' ~/.mysql_secret | tr -d '\r\n' | xargs -I PASS mysqladmin -pPASS password ""
