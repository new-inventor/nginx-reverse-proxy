if [[ "TRUE" = "$DH" ]]
then
  openssl dhparam -out dhparam.pem 1024
fi
