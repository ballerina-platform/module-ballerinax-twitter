# Overview
Connects to Twitter using Ballerina.

The Twitter API can be used to programmatically retrieve data and engage with the conversation on Twitter. This connector provides access to a variety of different resources in Twitter including the following:
* Tweets
* Users
 
The Twitter API currently consists of two supported versions, as well as different access tiers.
When user wants to access Twitter through Ballerina Twitter Connector, they are required to register an application. By default, applications can only access public information on Twitter. Certain operations, such as those responsible for sending or receiving Direct Messages and posting a Tweet, require additional permissions from user before access user information. These permissions are not granted by default; you choose on a per-application basis whether to provide this access, and can control all the applications authorized on your account.

### Key Features of Twitter
* Create and manage Tweet, Retweet and Reply
* Manage Users and their details

This connector doesn't support all the operations offered by Twitter API V1.1.

This module supports Ballerina Swan Lake Beta 2 version


## Configuring connector
### Prerequisites
- Twitter developer account

### Obtaining tokens
1. Apply for a developer account and receive approval.
https://developer.twitter.com/en/apply-for-access
2. Create a project and an associated developer App in the developer portal.
https://developer.twitter.com/en/portal/dashboard
3. In App permissions you have to give permission of Read, write and access Direct Messages. If a permission level is changed, any user tokens already given to that Twitter app must be revoked and users should authorize the App again in order for the token to acquire the latest permissions.
4. In the app created go to  “Keys and tokens” tab and save your API Key, API Secret, Access Tokens and Access Token Secret in a trusted place as they are not visible after. If you lost those keys and secrets regenerate those.

## Quickstart

### Create a twitter post
#### Step 1: Import Twitter module
First, import the ballerinax/twitter module into the Ballerina project.
```ballerina
import ballerinax/twitter;
```
#### Step 2: Initialize the Twitter client giving necessary credentials
```ballerina
twitter:TwitterConfiguration twitterConfig = {
    apiKey: "<apiKey>",
    apiSecret: "<apiSecret>",
    accessToken: "<accessToken>",
    accessTokenSecret: "<accessTokenSecret>"
};

twitter:Client twitterClient = check new(twitterConfig);
```

#### Step 3: Create a twitter post
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

## Snippets
Snippets of some operations.

- Create a twitter post
    ``` ballerina
    string tweetContent = "Sample tweet";
    var result = twitterClient->tweet(tweetContent);
    if (result is twitter:Tweet) {
        io:println("Tweet: ", result.toString());
    } else {
        io:println("Error: ", result.toString());
    }
    ```

- Search for tweets using a search string
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

- Search for a user by user's Id
    ```ballerina
    twitter:User|error response = twitterClient->getUser(userId);
    if (response is twitter:User) {
        log:printInfo("User Details: " + response.toString());
    } else {
        log:printError("Error: " + response.toString());
    }
    ```

### [You can find more samples here](https://github.com/ballerina-platform/module-ballerinax-twitter/tree/main/twitter/samples)
