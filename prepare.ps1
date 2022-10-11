# This powershell script will check if docker is running, if not it will exit.
# If docker is running it will create a folders called init, nginx/ssl.
# After the folders are created, it will run a docker command to create the initdb.sh script for postgres.
# The script will then create a self signed x509 certificate for nginx.
#
# Check if docker is running
$docker = Get-Service com.docker.service
if ($docker.Status -ne "Running") {
    Write-Host "Docker is not running, please start docker and try again."
    exit
}
# Create folders
Write-Host "Creating folders"
New-Item -ItemType Directory -Path .\init
New-Item -ItemType Directory -Path .\nginx\ssl

# Create initdb.sh
Write-Host "Creating initdb.sh"
docker run --rm guacamole/guacamole /opt/guacamole/bin/initdb.sh --postgres > ./init/initdb.sql

# Create self signed x509 certificate
Write-Host "Creating self signed x509 certificate"
docker run --rm guacamole/guacamole openssl req -nodes -newkey rsa:2048 -new -x509 -keyout nginx/ssl/self-ssl.key -out nginx/ssl/self.cert -subj '/C=US/ST=CA/L=Los Angeles/O=TEST/OU=testing/CN=*.testing.org/emailAddress=ajustinmoore86@gmail.com'
Write-Host "Done"