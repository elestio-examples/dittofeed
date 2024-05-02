#set env vars
set -o allexport; source .env; set +o allexport;

#wait until the server is ready
echo "Waiting for software to be ready ..."
sleep 30s;

# docker-compose exec -T api bash -c "node ./packages/api/dist/scripts/bootstrap.js"
docker-compose exec -T admin-cli bash -c './admin.sh bootstrap --workspace-name="Workspace"'

if [ -e "./initialized" ]; then
    echo "Already initialized, skipping..."
else
    sed -i 's@limit_req_log_level warn;@limit_req_log_level warn;\n    proxy_read_timeout 300;\n    proxy_connect_timeout 300;\n    proxy_send_timeout 300;\n@g' /opt/elestio/nginx/conf.d/${DOMAIN}.conf

    docker exec elestio-nginx nginx -s reload;
    touch "./initialized"
fi