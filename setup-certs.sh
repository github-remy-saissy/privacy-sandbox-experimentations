#!/bin/sh

setup_certs() {
    echo "Setup certificate for $1 domain..."
    pushd certs
    mkcert $1
    popd
}

rm -rf certs
mkdir certs
setup_certs privacy-sandbox.local
setup_certs publisher-news.local
setup_certs advertiser-travel.local
setup_certs advertiser-shopping.local
setup_certs ssp1.local
setup_certs dsp1.local
