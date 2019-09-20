//
// This script generates a JWT token using the service_account.json 
// private key file.
// 
// This token can then be used to authenticate a push message send 
// request.
//
// Dependencies:
//
//   node
//   npm install googleapis --save
//

const GOOGLE_APPLICATION_CREDENTIALS    = process.env.GOOGLE_APPLICATION_CREDENTIALS
var {google}                            = require("googleapis");

// Load the service account key JSON file.
const serviceAccount = require(GOOGLE_APPLICATION_CREDENTIALS);

// Define the required scopes.
const scopes = [
  "https://www.googleapis.com/auth/firebase.messaging",
];

// Authenticate a JWT client with the service account.
var jwtClient = new google.auth.JWT(
  serviceAccount.client_email,
  null,
  serviceAccount.private_key,
  scopes
);

// Use the JWT client to generate an access token.
jwtClient.authorize(function(error, tokens) {
  if (error) {
    console.log("Error making request to generate access token:", error);
  } else if (tokens.access_token === null) {
    console.log("Provided service account does not have permission to generate access tokens");
  } else {
    var accessToken = tokens.access_token;
    console.log(accessToken);

    // See the "Using the access token" section below for information
    // on how to use the access token to send authenticated requests to
    // the Realtime Database REST API.
  }
});