## Overview

[Twitter](https://about.twitter.com/) is a widely-used social networking service provided by Twitter, Inc., enabling users to post and interact with messages known as "tweets".

The `ballerinax/twitter` package offers APIs to connect and interact with [Twitter API](https://developer.twitter.com/en/docs/twitter-api) endpoints, specifically based on [Twitter API v2](https://developer.x.com/en/docs/twitter-api/migrate/whats-new).

## Setup guide

To use the Twitter connector, you must have access to the Twitter API through a [Twitter developer account](https://developer.twitter.com/en) and a project under it. If you do not have a Twitter Developer account, you can sign up for one [here](https://developer.twitter.com/en/apply-for-access).

### Step 1: Create a Twitter Developer Project

1. Open the [Twitter Developer Portal](https://developer.twitter.com/en/portal/dashboard).

2. Click on the "Projects & Apps" tab and select an existing project or create a new one for which you want API Keys and Authentication Tokens.

    <img src=https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-twitter/main/docs/setup/resources/twitter-developer-portal.png alt="Twitter Developer Portal" style="width: 70%;">

### Step 2: Set up user authentication settings

1. Scroll down and Click on the **Set up** button to set up user authentication.

    <img src=https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-twitter/main/docs/setup/resources/set-up.png alt="Set up" style="width: 70%;">

2. Complete the user authentication setup.

### Step 3. Obtain Client Id and Client Secret.

1. After completing the setup, you will be provided with your client Id and client secret. Make sure to save the provided client Id and client secret.

    <img src=https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-twitter/main/docs/setup/resources/get-keys.png alt="Get Keys" style="width: 70%;">

### Step 4: Setup OAuth 2.0 Flow

Before proceeding with the Quickstart, ensure you have obtained the Access Token using the following steps:

1. Create an authorization URL using the following format:

    ```
    https://twitter.com/i/oauth2/authorize?response_type=code&client_id=<your_client_id>&redirect_uri=<your_redirect_uri>&scope=tweet.read%20tweet.write%20users.read%20follows.read&state=state&code_challenge=<your_code_challenge>&code_challenge_method=plain
    ```

    Replace `<your_client_id>`, `<your_redirect_uri>`, and `<your_code_challenge>` with your specific values. Make sure to include the necessary scopes depending on your use case.

    Example:

    ```
    https://twitter.com/i/oauth2/authorize?response_type=code&client_id=asdasASDas21Y0OGR4bnUxSzA4c0k6MTpjaQ&redirect_uri=http://example&scope=tweet.read%20tweet.write%20users.read%20follows.read&state=state&code_challenge=D601XXCSK57UineGq62gUnsoasdas1GfKUY8QWhOF9hiN_k&code_challenge_method=plain
    ```

    **Note:** By default, the access token you create through the OAuth 2.0 Flow, as used here, will only remain valid for two hours. There is an alternative way that does not invalidate the access token after 2 hours. To do this, refer to [Obtain access token under offline.access](https://developer.x.com/en/docs/authentication/oauth-2-0/user-access-token).

2. Copy and paste the generated URL into your browser. This will redirect you to the Twitter authorization page.

    <img src=https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-twitter/main/docs/setup/resources/authorize.png alt="Authorize Page" style="width: 70%;">

3. Once you authorize, you will be redirected to your specified redirect URI with an authorization code in the URL.

    Example:

    ```
    http://www.example.com/?state=state&code=QjAtYldxeTZITnd5N0FVN1B3MlliU29rb1hrdmFPUWNXSG5LX1hCRExaeFE3OjE3MTkzODMzNjkxNjQ6MTowOmFjOjE
    ```

    **Note:** Store the authorization code and use it promptly as it expires quickly.

4. Use the obtained authorization code to run the following curl command, replacing `<your_client_id>`, `<your_redirect_url>`, `<your_code_verifier>`, and `<your_authorization_code>` with your specific values:

    ```bash
    curl --location "https://api.twitter.com/2/oauth2/token" ^
    --header "Content-Type: application/x-www-form-urlencoded" ^
    --data-urlencode "code=<your_authorization_code>" ^
    --data-urlencode "grant_type=authorization_code" ^
    --data-urlencode "client_id=<your_client_id>" ^
    --data-urlencode "redirect_uri=<your_redirect_url>" ^
    --data-urlencode "code_verifier=<your_code_verifier>"
    ```

    This command will return the access token necessary for API calls.

    ```json
    {
        "token_type":"bearer",
        "expires_in":7200,
        "access_token":"VWdEaEQ2eEdGdmVSbUJQV1U5LUdWREZuYndVT1JaNDddsdsfdsfdsxcvIZGMzblNjRGtvb3dGOjE3MTkzNzYwOTQ1MDQ6MTowOmF0Oj",
        "scope":"tweet.write users.read follows.read tweet.read"
    }
    ```

5. Store the access token securely for use in your application.

**Note**: We recommend using the OAuth 2.0 Authorization Code with PKCE method as used here, but there is another way using OAuth 2.0 App Only. If you want, you can go through this link: [OAuth 2.0 App Only](https://developer.twitter.com/en/docs/authentication/oauth-2-0/application-only). Refer to this document to check which operations in Twitter API v2 are done using which method: [API reference](https://developer.twitter.com/en/docs/authentication/guides/v2-authentication-mapping).


## Quickstart

To use the `Twitter` connector in your Ballerina application, update the `.bal` file as follows:

### Step 1: Import the module

Import the `twitter` module.

```ballerina
import ballerinax/twitter;
```

### Step 2: Instantiate a new connector

Create a `twitter:ConnectionConfig` with the obtained **Access Token** and initialize the connector with it.

```ballerina
configurable string token = ?;

twitter:Client twitter = check new({
        auth: {
            token
        }
});
```

### Step 3: Invoke the connector operation

Now, utilize the available connector operations.

#### Post a tweet

```ballerina
twitter:TweetCreateResponse postTweet = check twitter->/tweets.post( payload = {
    text: "This is a sample tweet"
});
```

### Step 4: Run the Ballerina application

```bash
bal run
```


## Examples

The `Twitter` connector provides practical examples illustrating usage in various scenarios. Explore these [examples](https://github.com/ballerina-platform/module-ballerinax-twitter/tree/main/examples/), covering the following use cases:

1. [Direct message company mentions](https://github.com/ballerina-platform/module-ballerinax-twitter/tree/main/examples/DM-mentions) - Integrate Twitter to send direct messages to users who mention the company in tweets.

2. [Tweet performance tracker](https://github.com/ballerina-platform/module-ballerinax-twitter/tree/main/examples/tweet-performance-tracker) - Analyze the performance of tweets posted by a user over the past month.
