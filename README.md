# Protected Audience demo

## Introduction

This demo shows the simple usage of the [Protected Audience API](https://developer.chrome.com/blog/fledge-api/). In this demo, there are 4 actors involved in the process: advertiser, publisher, DSP, and SSP. Each actors interact with one another to render a retargeted ads to the user. 

## Local development

### Setup environment

To run locally, the resources from DSP/SSP must be served over HTTPS. Unfortunately, Firebase emulator [does not support HTTPS localhost](https://github.com/firebase/firebase-tools/issues/1908). Therefore, we will setup a reverse proxy with `nginx` to serve DSP/SSP resources over HTTPS.
1. Install Homebrew
2. Run `scripts/setup-dev-env.sh`

The script will do the following:
1. Deploy SSL certificates for each domain of the project in `$(brew --prefix)/etc/ssl/privacy-sandbox`
2. Install dnsmasq and uses the MacOS dynamic resolver to register the *.localhost domain to respond on 127.0.0.1
3. Install a local nginx configured to serve as an HTTPS reverse proxy using configurations from `./dev-nginx.d`

### Clean the environment

To remove SSL certificates and custom nginx reverse proxy configuration when no longer needed:
1. Run `scripts/cleanup-dev-env.sh`

The script will do the following:
1. Removes SSL certificates for each domain of the project in `$(brew --prefix)/etc/ssl/privacy-sandbox`
3. Removes local nginx reverse proxy configurations from `./dev-nginx.d`

Since the *.localhost is a catch-all resolver with no specific configuration linked, it is kept.

### Setup Firebase

- Setup [Firebase tools](https://github.com/firebase/firebase-tools)

### Setup repository

- `git clone https://github.com/googlechromelabs/protected-audience-demo`
- `cd protected-audience-demo`
- `npm install`

### Start emulator

```
npm run dev
```

And visit `https://home.localhost` for the main page

### Deploy code

```
npm run deploy
```

This will deploy the project in the firebase project referenced in the .firebase.json file.

## Key files

* Buyer's interest group logic - [`/sites/dsp/join-ad-interest-group.js`](https://github.com/GoogleChromeLabs/protected-audience-demo/blob/main/sites/dsp/join-ad-interest-group.js) - DSP resource that adds an interest group for the user.
* Buyer's bidding logic - [`/sites/dsp/bid.js`](https://github.com/GoogleChromeLabs/protected-audience-demo/blob/main/sites/dsp/bid.js) - DSP resource that contains the bidding logic for the auction.
* Seller's auction logic - [`/sites/ssp/run-auction.js`](https://github.com/GoogleChromeLabs/protected-audience-demo/blob/main/sites/ssp/run-auction.js) - SSP resource that executes the in-browser auction.
* Seller's decision logic - [`/sites/ssp/decision-logic.js`](https://github.com/GoogleChromeLabs/protected-audience-demo/blob/main/sites/ssp/decision-logic.js) - SSP resource that decides the winner among the bidders.

## Hostnames

### Production

- Main - https://protected-audience-demo.web.app/
- Advertiser - https://protected-audience-demo-advertiser.web.app/
- Publisher- https://protected-audience-demo-publisher.web.app/
- DSP - https://protected-audience-demo-dsp.web.app/
- SSP - https://protected-audience-demo-ssp.web.app/

### Local

- Main - https://home.localhost
- Adtech - https://adtech.localhost
- Advertiser - https://advertiser.localhost
- Publisher - https://publisher.localhost
- DSP - https://dsp.localhost
- SSP - https://ssp.localhost
