#!/bin/sh
set -e

# Start Portainer
docker stack deploy --compose-file docker-compose.portainer.yml portainer

docker image build --no-cache \
--tag bcgdv/api:latest --build-arg GIT_COMMIT=$(git log -1 --format=%H) .

# Run this command to find git commit (might need to install jq):-
# docker inspect bcgdv/api:latest | jq '.[].ContainerConfig.Labels'

# Manage sensitive data with Docker secrets.
# NOTE: This is just a demo. However, sensitive data should never be kept in plain sight and in plain text
echo "3x4mpl3" | docker secret create postgres-passwd -

# Start Air Quality stack on port 5000 by default
API_HOST_PORT=5000 docker stack deploy --compose-file docker-compose.yml airQuality

# Start second stack on a different API port number
# NOTE: due to port conflict, adminer will need to be started on a different port or adminer will need to be disabled
# API_HOST_PORT=5002 docker stack deploy --compose-file docker-compose.yml airQuality_2