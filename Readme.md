# Privacy sandbox test

Built based on https://fledge-demo.glitch.me/

## Prerequisites
* Download Chrome Canary
** Either
** start it with --enable-features=AdInterestGroupAPI,InterestGroupStorage,Fledge,FencedFrames
* enable privacy sandbox by default using chrome://flags
* Enable testing in chrome://settings/privacySandbox
* Configure local https for localhost (https://web.dev/how-to-use-local-https/)
** Run ./setup-certs.sh
* Launch the demo: docker-compose up -d

If needed, log into the docker container to look for logs, ...:
docker exec -it privacy-sandbox-fledge-1 sh

