#set env vars
#set -o allexport; source .env; set +o allexport;

cat <<EOT > ./servers.json
{
    "Servers": {
        "1": {
            "Name": "local",
            "Group": "Servers",
            "Host": "172.17.0.1",
            "Port": 2632,
            "MaintenanceDB": "postgres",
            "SSLMode": "prefer",
            "Username": "postgres",
            "PassFile": "/pgpass"
        }
    }
}
EOT

SECRET_KEY=$(openssl rand -base64 32 | head -c 44)

cat << EOT >> ./.env

SECRET_KEY=${SECRET_KEY}
EOT