# Overview
Connects to Twitter using Ballerina.

The Twitter API can be used to programmatically retrieve data and engage with the conversation on Twitter. When accessing Twitter through Ballerina Twitter Connector, It is required to register a developer application. By default, applications can only access public information on Twitter. Certain operations, such as those responsible for sending or receiving direct Messages and posting a tweet, require additional permissions from user before access user information. These permissions are not granted by default; you choose on a per-application basis whether to provide this access, and can control all the applications authorized on your account.

This module supports [Twitter API](https://developer.twitter.com/en/docs/twitter-api/v1) v1.1 version.

## Prerequisites
Before using this connector in your Ballerina application, complete the following:
* Create [Twitter Developer Account](https://developer.twitter.com/en/apply-for-access)
* Obtaining tokens
        
    Follow [this link](https://developer.twitter.com/en/docs/authentication/oauth-1-0a) and obtain the API key, API key secret, Access token and Access token secret.

* Configure the connector with obtained tokens

## Quickstart

To use the Twitter connector in your Ballerina application, update the .bal file as follows:

### Step 1: Import Twitter module
First, import the ballerinax/twitter module into the Ballerina project.
```ballerina
import ballerinax/twitter;
```
### Step 2: Initialize the Twitter client giving necessary credentials
```ballerina
twitter:TwitterConfiguration twitterConfig = {
    apiKey: "<apiKey>",
    apiSecret: "<apiSecret>",
    accessToken: "<accessToken>",
    accessTokenSecret: "<accessTokenSecret>"
};

twitter:Client twitterClient = check new(twitterConfig);
```

### Step 3: Create a twitter post
```ballerina
public function main() {
    string tweetContent = "Sample tweet";
    var result = twitterClient->tweet(tweetContent);
    if (result is twitter:Tweet) {
        io:println("Tweet: ", result.toString());
    } else {
        io:println("Error: ", result.toString());
    }
}
```

## Quick reference
The following code snippets shows how the connector operations can be used in different scenarios after initializing the client.
* Create a twitter post
    ``` ballerina
    string tweetContent = "Sample tweet";
    var result = twitterClient->tweet(tweetContent);
    if (result is twitter:Tweet) {
        io:println("Tweet: ", result.toString());
    } else {
        io:println("Error: ", result.toString());
    }
    ```

* Search for tweets using a search string
    ```ballerina
    string queryStr = "SriLanka";
    twitter:SearchOptions request = {
        count: 10
    };

    twitter:Tweet[]|error response = twitterClient->search(queryStr, request);
    if (response is twitter:Tweet[]) {
        log:printInfo("Statuses Details: " + response.toString());
    } else {
        log:printError("Error: " + response.toString());
    }
    ```

* Search for a user by user's Id
    ```ballerina
    twitter:User|error response = twitterClient->getUser(userId);
    if (response is twitter:User) {
        log:printInfo("User Details: " + response.toString());
    } else {
        log:printError("Error: " + response.toString());
    }
    ```

***[You can find more samples here](https://github.com/ballerina-platform/module-ballerinax-twitter/tree/main/twitter/samples)***