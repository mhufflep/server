docker stop $(docker ps -a -q)
docker rm $(docker ps -a -q)
docker container prune
docker rmi $(docker images -q)
