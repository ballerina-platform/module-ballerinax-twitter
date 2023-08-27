## Overview

The `ballerinax/twitter.'listener` module provides a Listener to catch events triggered from your Twitter account. This functionality is provided by [Twitter Account Activity API](https://developer.twitter.com/en/docs/twitter-api/enterprise/account-activity-api/overview). 

## Supported trigger types
1. "onTweet" - A new tweet was created
2. "onReply" - A tweet was replied
3. "onReTweet" - A tweet was retweeted
4. "onQuoteTweet" - A quoted tweet was deleted
5. "onFollower" - A user was followed y someother user
6. "onFavourite" - A tweet was liked/favourited by a user
7. "onDelete" - A tweet was deleted
8. "onMention" - A user was mentioned

## Prerequisites
Before using this connector in your Ballerina application, complete the following:

* Create a Twitter developer account.
* Subscribe to events and obtain verification token
    1. Visit https://developer.twitter.com/en/portal/dashboard, create your own Twitter App. 
    2. Get credentials such as API key, API key secret, Access token and Access token secret.
    3. In `Authentication settings` section of your twitter App add the callback url.

## Quickstart
To use the Twitter Listener in your Ballerina application, update the .bal file as follows:

### Step 1: Import listener
Import the `ballerinax/twitter.'listener` module as shown below.
```ballerina
import ballerinax/twitter.'listener as twitter;
```

### Step 2: Create a new listener instance
Create a `twitter:ListenerConfiguration` using your `twitter Verification Token`, port and initialize the listener with it.
```ballerina
configurable string apiKey = ?;
configurable string apiSecret = ?;
configurable string accessToken = ?;
configurable string accessTokenSecret = ?;
string callbackUrl =  ?;
string environment =  ?;
string port =  ?;

int PORT = check ints:fromString(port);

listener twitter:Listener twitterListener = new (PORT, apiKey, apiSecret, accessToken, accessTokenSecret, callbackUrl, environment);
```

### Step 3: Implement a listener remote function
1. Now you can implement a listener remote function supported by this connector.

* `onTweet`, `onReply`, `onReTweet`, `onQuoteTweet`, `onFollower`, `onFavourite`,
`onDelete`, `onMention` are the supported remote functions.

* Write a remote function to receive a particular event type. Implement your logic within that function as shown in the below sample.

* Following is a simple sample for using Twitter listener
```ballerina
import ballerina/log;
import ballerinax/twitter.'listener as twitter;

configurable string apiKey = ?;
configurable string apiSecret = ?;
configurable string accessToken = ?;
configurable string accessTokenSecret = ?;
string callbackUrl =  ?;
string environment =  ?;
string port =  ?;

int PORT = check ints:fromString(port);

listener twitter:Listener twitterListener = new (PORT, apiKey, apiSecret, accessToken, accessTokenSecret, callbackUrl, environment);

service / on twitterListener {
    isolated remote function onTweet(TweetEvent event) returns error? {
        log:printInfo("New Tweet");
        log:printInfo((event.tweet_create_events).toJsonString());
    }
}
```
2. Use `bal run` command to compile and run the Ballerina program. 

* Register the request URL
    1. Run your ballerina service (similar to above sample) on prefered port.
    2. Start ngrok on same port using the command ``` ./ngrok http 9090 ```
    3. In `Authentication settings` section of your twitter App settings, paste the URL issued by ngrok following with your service path (eg : ```https://bf31de7fd929.ngrok.io/webhook/twitter```) (`'/webhook/twitter'` should be added after thr ngrok URL).

* Receiving events
    * After successful addition of callback url, your ballerina service will receive events. 

**NOTE:**
If the user's logic inside any remote method of the connector listener throws an error, connector internal logic will 
covert that error into a HTTP 500 error response and respond to the webhook (so that event may get redelivered), 
otherwise it will respond with HTTP 200 OK. Due to this architecture, if the user logic in listener remote operations
includes heavy processing, the user may face HTTP timeout issues for webhook responses. In such cases, it is advised to
process events asynchronously as shown below.

```ballerina
import ballerinax/twitter.'listener as twitter;

configurable string apiKey = ?;
configurable string apiSecret = ?;
configurable string accessToken = ?;
configurable string accessTokenSecret = ?;
configurable string callbackUrl =  ?;
configurable string environment =  ?;
configurable string port =  ?;

int PORT = check ints:fromString(port);

listener twitter:Listener twitterListener = new (PORT, apiKey, apiSecret, accessToken, accessTokenSecret, callbackUrl, environment);

service / on twitterListener {
    remote function onTweet(twitter:TweetEvent eventInfo) returns error? {
        _ = @strand { thread: "any" } start userLogic(eventInfo);
    }
}
function userLogic(twitter:TweetEvent eventInfo) returns error? {
    // Write your logic here
}
```
