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


# Generate random bytes and encode them in base64
random_string=$(head -c 32 /dev/urandom | base64)

# Write the random string to the ./.env file
echo "SECRET_KEY=$random_string" >> ./.env

echo "Random string generated and saved to .env file."
