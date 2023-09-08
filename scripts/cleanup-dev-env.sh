#!/bin/sh

PROJECT_NAME="privacy-sandbox"

echo "Removing local SSL certificates from $(brew --prefix)/etc/ssl/$PROJECT_NAME..."
rm -rf $(brew --prefix)/etc/ssl/privacy-sandbox
echo "SSL certificates removed."

echo "Removing local Nginx reverse proxy configurations that serve local SSL domains..."
for domain in home adtech ssp dsp publisher advertiser; do
  echo "Removing domain ${domain}.localhost from $(brew --prefix)/etc/nginx/servers/..."
  rm $(brew --prefix)/etc/nginx/servers/${domain}.localhost
done
sudo brew services stop nginx
sudo brew services start nginx
echo "Checking that nginx is properly launched."
sudo brew services
echo "Nginx reverse proxy is running properly."
