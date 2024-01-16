#set env vars
set -o allexport; source .env; set +o allexport;

#wait until the server is ready
echo "Waiting for software to be ready ..."
sleep 30s;

# docker-compose exec -T api bash -c "node ./packages/api/dist/scripts/bootstrap.js"
docker-compose exec -T admin-cli bash -c './admin.sh bootstrap --workspace-name="Workspace"'