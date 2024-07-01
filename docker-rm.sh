
docker ps -a | grep "$IMAGE_TAG" | awk '{print $1}' | xargs docker stop
docker ps -a | grep "$IMAGE_TAG" | awk '{print $1}'  | xargs docker rm
