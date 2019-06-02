# centos_mariadb_galera
run a mariadb with galera cluster on docker compose

note:
this version design 2 centos container (containerA as hostA and containerB as hostB)
, and given specific ip.

Step to run:
docker-compose up -d --build