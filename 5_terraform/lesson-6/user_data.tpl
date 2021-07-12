#!/bin/bash
apt -y update
apt -y install apache2


myip=`curl http://169.254.169.254/latest/meta-data/local-ipv4`

cat <<EOF > /var/www/html/index.html
<html>
<h2>Build by Power of Terraform <font color="red"> v0.12</font></h2><br>
Owner ${f_name} ${l_name} <br>

%{ for x in names ~}
# shellcheck disable=SC2154
Hello to ${x} from ${f_name} <br>
%{ endfor ~}


</html>
EOF
sudo service apache2 start
update-rc.d apache2 on
