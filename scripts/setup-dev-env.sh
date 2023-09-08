#!/bin/sh

PROJECT_NAME="privacy-sandbox"

echo "Configuring local SSL certificates in $(brew --prefix)/etc/ssl/$PROJECT_NAME..."
rm -rf $(brew --prefix)/etc/ssl/privacy-sandbox
mkdir -p $(brew --prefix)/etc/ssl/privacy-sandbox
for domain in home adtech ssp dsp publisher advertiser; do
  echo "Setup certificate for ${domain} in $(brew --prefix)/etc/ssl/privacy-sandbox..."
  pushd $(brew --prefix)/etc/ssl/privacy-sandbox
  mkcert ${domain}.localhost
  popd
done
echo "SSL certificates installed."

echo "Installing local MacOS resolver on .localhost using dnsmasq and resolver..."
brew install dnsmasq
echo "listen-address=127.0.0.1" > $(brew --prefix)/etc/dnsmasq.conf
echo "port=53" >> $(brew --prefix)/etc/dnsmasq.conf
echo "log-facility=$(brew --prefix)/var/log/dnsmasq.log" >> $(brew --prefix)/etc/dnsmasq.conf
echo "conf-dir=$(brew --prefix)/etc/dnsmasq.d" >> $(brew --prefix)/etc/dnsmasq.conf
echo "address=/.localhost/127.0.0.1" > $(brew --prefix)/etc/dnsmasq.d/localhost.conf
sudo brew services stop dnsmasq
sudo brew services start dnsmasq
sudo brew services info dnsmasq

sudo mkdir -v /etc/resolver
sudo bash -c 'echo "nameserver 127.0.0.1" > /etc/resolver/localhost'
sudo dscacheutil -flushcache
sudo killall -HUP mDNSResponder
echo "Checking that .localhost is correctly registered."
scutil --dns
echo "Local DNS MacOS resolver successfully installed."

echo "Installing local Nginx reverse proxy to serve local SSL domains..."
brew install nginx
# Configure a minimal nginx root configuration.
cat <<EOF > $(brew --prefix)/etc/nginx.conf
worker_processes  1;
events {
    worker_connections  1024;
}

http {
    include       mime.types;
    default_type  application/octet-stream;
    sendfile        on;
    keepalive_timeout  65;
    include servers/*;
}
EOF
mkdir -pv $(brew --prefix)/etc/
for domain in home adtech ssp dsp publisher advertiser; do
  echo "Installing domain ${domain}.localhost in $(brew --prefix)/etc/nginx/servers/..."
  cp ./dev-nginx.d/${domain}.localhost $(brew --prefix)/etc/nginx/servers/
done
sudo brew services stop nginx
sudo brew services start nginx
echo "Checking that nginx is properly launched."
sudo brew services info nginx
echo "Nginx reverse proxy is properly installed."
