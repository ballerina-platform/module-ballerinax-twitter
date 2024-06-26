## Overview

[Twitter](https://about.twitter.com/) is a widely-used social networking service provided by Twitter, Inc., enabling users to post and interact with messages known as "tweets."

The `ballerinax/twitter` package offers APIs to connect and interact with [Twitter API](https://developer.twitter.com/en/docs/twitter-api) endpoints, specifically based on [Twitter API v2](https://developer.x.com/en/docs/twitter-api/migrate/whats-new).


## Setup guide

To use the Twitter connector, you must have access to the Twitter API through a [Twitter developer account](https://developer.twitter.com/en) and a project under it. If you do not have a Twitter Developer account, you can sign up for one [here](https://developer.twitter.com/en/apply-for-access).

### Step 1: Create a Twitter Developer Project

1. Open the [Twitter Developer Portal](https://developer.twitter.com/en/portal/dashboard).

2. Click on the "Projects & Apps" tab and select an existing project or create a new one for which you want API Keys and Authentication Tokens.

    <img src="https://github.com/ballerina-platform/module-ballerinax-twitter/blob/main/docs/setup/resources/twitter-developer-portal.png" alt="Twitter Developer Portal">

### Step 2: Get Your API Keys and Authentication Tokens.

1. Click on the **Keys and Tokens** tab in the Twitter Developer Portal for your project.

    ![Keys and Tokens](https://github.com/ballerina-platform/module-ballerinax-twitter/blob/main/docs/setup/resources/twitter-keys-and-tokens.png)

2. Click on **Generate** to create your API key, API secret key, Access token, Bearer Token, and Access token secret.

    ![Create Credentials](https://github.com/ballerina-platform/module-ballerinax-twitter/blob/main/docs/setup/resources/create-credentials.png)

3. You will be provided with your keys and tokens. Make sure to save the provided API key, API secret key, Access token, Bearer Token, and Access token secret.

**Note**: You will use the keys and tokens generated from the Twitter Developer Portal to authenticate API requests.

**Note**: We are now using OAuth 2.0 App Only, but there is another way using OAuth 2.0 Authorization Code with PKCE. If you want, you can go through this link: [OAuth 2.0 Authorization Code with PKCE](https://developer.twitter.com/en/docs/authentication/oauth-2-0/user-access-token).


## Quickstart

To use the `Twitter` connector in your Ballerina application, update the `.bal` file as follows:

### Step 1: Import the module

Import the `twitter` module.

```ballerina
import ballerinax/twitter;
```

### Step 2: Instantiate a new connector

Create a `twitter:ConnectionConfig` with the obtained **Bearer Token** tokens and initialize the connector with it.

```ballerina
configurable string bearerToken = ?;

twitter:Client twitterClient = check new({
        auth: {
            token: bearerToken
        }
});
```

### Step 3: Invoke the connector operation

Now, utilize the available connector operations.

#### Post a tweet

```ballerina
var postTweet = check twitterClient->/'2/tweets.post( payload = {
    text: "This is a sample tweet"
});
```

### Step 4: Run the Ballerina application

```bash
bal run
```
