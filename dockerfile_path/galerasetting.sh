#!/usr/bin/env bash

[ "$DEBUG" == 'true' ] && set -x

cat << EOF >> /etc/my.cnf.d/server.cnf
[galera]
# Mandatory settings
wsrep_on=ON
wsrep_provider=/usr/lib64/galera/libgalera_smm.so
wsrep_cluster_name='my_wsrep_cluster'
wsrep_cluster_address='gcomm://$clusterip:4567'
binlog_format=row
wsrep_node_name='$HOSTNAME'
wsrep_sst_auth=cluster:1234
wsrep_sst_method=rsync
bind-address=$nodeip
EOF

echo "alias err='vim /var/lib/mysql/$HOSTNAME.err'" >> /etc/bashrc
echo "alias upcluster='service mysql bootstrap'" >> /etc/bashrc
echo "alias updb='service mysql start'" >> /etc/bashrc

GRASTATE=/var/lib/mysql/grastate.dat
[ -f $GRASTATE ] && sed -i "s|safe_to_bootstrap.*|safe_to_bootstrap: 1|g" $GRASTATE

if [ $HOSTNAME == "hostA" ]; then
service mysql bootstrap
tail -f /dev/null
else
service mysql start
tail -f /dev/null
fi

# tail -f /dev/null