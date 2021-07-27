## Overview
Connects to Twitter using Ballerina.

The Twitter API can be used to programmatically retrieve data and engage with the conversation on Twitter. When accessing Twitter through Ballerina Twitter Connector, It is required to register a developer application. By default, applications can only access public information on Twitter. Certain operations, such as those responsible for sending or receiving direct Messages and posting a tweet, require additional permissions from user before access user information. These permissions are not granted by default; you choose on a per-application basis whether to provide this access, and can control all the applications authorized on your account.

This module supports [Twitter API](https://developer.twitter.com/en/docs/twitter-api/v1) v1.1 version.

## Prerequisites
Before using this connector in your Ballerina application, complete the following:
* Create [Twitter Developer Account](https://developer.twitter.com/en/apply-for-access)
* Obtaining tokens
        
    Follow [this link](https://developer.twitter.com/en/docs/authentication/oauth-1-0a) and obtain the API key, API key secret, Access token and Access token secret.

## Quickstart

To use the Twitter connector in your Ballerina application, update the .bal file as follows:

### Step 1: Import connector
First, import the ballerinax/twitter module into the Ballerina project.
```ballerina
import ballerinax/twitter;
```
### Step 2: Create a new connector instance
```ballerina
twitter:TwitterConfiguration twitterConfig = {
    apiKey: "<apiKey>",
    apiSecret: "<apiSecret>",
    accessToken: "<accessToken>",
    accessTokenSecret: "<accessTokenSecret>"
};

twitter:Client twitterClient = check new(twitterConfig);
```

### Step 3: Invoke connector operation
1. You can post a tweet as follows with `tweet` method by passing content as a parameter. Successful creation returns the created `Tweet` and the error cases returns an `error` object.

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
2. Use `bal run` command to compile and run the Ballerina program. 

**[You can find more samples here](https://github.com/ballerina-platform/module-ballerinax-twitter/tree/main/twitter/samples)**
