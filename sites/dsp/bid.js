/**
 * Copyright 2022 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
function generateBid(interestGroup, auctionSignals, perBuyerSignals, trustedBiddingSignals, browserSignals) {
  const [testAd] = interestGroup.ads;

  console.log("Methods available in the generateBid():");
  let props = [];
  if (typeof window !== "undefined") {
    for (prop in window) {
      props.push(prop);
    }
    props.sort();
    console.log(`Window: ${props.join("(), ")}()`);
    if (typeof window.sharedStorage !== "undefined") {
      props = [];
      for (prop in window.sharedStorage) {
        props.push(prop);
      }
      props.sort();
      console.log(`window.sharedStorage: ${props.join("(), ")}()`);
    }
    if (typeof window.fence !== "undefined") {
      props = [];
      for (prop in window.fence) {
        props.push(prop);
      }
      props.sort();
      console.log(`window.fence: ${props.join("(), ")}()`);
    }
  }
  if (typeof navigator !== "undefined") {
    props = [];
    for (prop in navigator) {
      props.push(prop);
    }
    props.sort();
    console.log(`Navigator: ${props.join("(), ")}()`);
  }
  if (typeof document !== "undefined") {
    props = [];
    for (prop in document) {
      props.push(prop);
    }
    props.sort();
    console.log(`Document: ${props.join("(), ")}()`);
  }
  if (typeof this !== "undefined") {
    props = [];
    for (prop in this) {
      props.push(prop);
    }
    props.sort();
    console.log(`This: ${props.join("(), ")}()`);
  }

  return {
    bid: 1, // Arbitrary bid value
    ad: {
      adName: testAd.metadata.adName,
    },
    render: testAd.renderUrl,
  };
}

function reportWin() {
  console.log("Methods available in the reportWin():");
  let props = [];
  if (typeof window !== "undefined") {
    for (prop in window) {
      props.push(prop);
    }
    props.sort();
    console.log(`Window: ${props.join("(), ")}()`);
    if (typeof window.sharedStorage !== "undefined") {
      props = [];
      for (prop in window.sharedStorage) {
        props.push(prop);
      }
      props.sort();
      console.log(`window.sharedStorage: ${props.join("(), ")}()`);
    }
    if (typeof window.fence !== "undefined") {
      props = [];
      for (prop in window.fence) {
        props.push(prop);
      }
      props.sort();
      console.log(`window.fence: ${props.join("(), ")}()`);
    }
  }
  if (typeof navigator !== "undefined") {
    props = [];
    for (prop in navigator) {
      props.push(prop);
    }
    props.sort();
    console.log(`Navigator: ${props.join("(), ")}()`);
  }
  if (typeof document !== "undefined") {
    props = [];
    for (prop in document) {
      props.push(prop);
    }
    props.sort();
    console.log(`Document: ${props.join("(), ")}()`);
  }
  if (typeof this !== "undefined") {
    props = [];
    for (prop in this) {
      props.push(prop);
    }
    props.sort();
    console.log(`This: ${props.join("(), ")}()`);
  }

  console.log('report win');
}
