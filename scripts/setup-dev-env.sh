#!/bin/sh

PROJECT_NAME="privacy-sandbox"
BREW_PREFIX=$(brew --prefix)

echo "Configuring local SSL certificates in $BREW_PREFIX/etc/ssl/$PROJECT_NAME..."
rm -rf $BREW_PREFIX/etc/ssl/$PROJECT_NAME
mkdir -p $BREW_PREFIX/etc/ssl/$PROJECT_NAME
for domain in home adtech ssp dsp publisher advertiser; do
  echo "Setup certificate for ${domain} in $BREW_PREFIX/etc/ssl/$PROJECT_NAME..."
  pushd $BREW_PREFIX/etc/ssl/$PROJECT_NAME
  mkcert ${domain}.localhost
  popd
done
echo "SSL certificates installed."

echo "Installing local MacOS resolver on .localhost using dnsmasq and resolver..."
brew install dnsmasq
echo "listen-address=127.0.0.1" > $BREW_PREFIX/etc/dnsmasq.conf
echo "port=53" >> $BREW_PREFIX/etc/dnsmasq.conf
echo "log-facility=$BREW_PREFIX/var/log/dnsmasq.log" >> $BREW_PREFIX/etc/dnsmasq.conf
echo "conf-dir=$BREW_PREFIX/etc/dnsmasq.d" >> $BREW_PREFIX/etc/dnsmasq.conf
echo "address=/.localhost/127.0.0.1" > $BREW_PREFIX/etc/dnsmasq.d/localhost.conf
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
cat <<EOF > $BREW_PREFIX/etc/nginx.conf
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
mkdir -pv $BREW_PREFIX/etc/nginx/servers
for domain in home adtech ssp dsp publisher advertiser; do
  echo "Installing domain ${domain}.localhost in $BREW_PREFIX/etc/nginx/servers/..."
  cat ./dev-nginx.d/${domain}.localhost| sed "s#<<PREFIX>>#$BREW_PREFIX#g" | sed "s#<<PROJECT_NAME>>#$PROJECT_NAME#g" > $BREW_PREFIX/etc/nginx/servers/${domain}.localhost
done
sudo brew services stop nginx
sudo brew services start nginx
echo "Checking that nginx is properly launched."
sudo brew services info nginx
echo "Nginx reverse proxy is properly installed."
