# Ballerina Twitter Connector

[![Build](https://github.com/ballerina-platform/module-ballerinax-twitter/workflows/CI/badge.svg)](https://github.com/ballerina-platform/module-ballerinax-twitter/actions?query=workflow%3ACI)
[![codecov](https://codecov.io/gh/ballerina-platform/module-ballerinax-twitter/branch/main/graph/badge.svg)](https://codecov.io/gh/ballerina-platform/module-ballerinax-twitter)
[![Trivy](https://github.com/ballerina-platform/module-ballerinax-twitter/actions/workflows/trivy-scan.yml/badge.svg)](https://github.com/ballerina-platform/module-ballerinax-twitter/actions/workflows/trivy-scan.yml)
[![GitHub Last Commit](https://img.shields.io/github/last-commit/ballerina-platform/module-ballerinax-twitter.svg)](https://github.com/ballerina-platform/module-ballerinax-twitter/commits/master)
[![GraalVM Check](https://github.com/ballerina-platform/module-ballerinax-twitter/actions/workflows/build-with-bal-test-graalvm.yml/badge.svg)](https://github.com/ballerina-platform/module-ballerinax-twitter/actions/workflows/build-with-bal-test-graalvm.yml)
[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)


## Overview

[Twitter](https://about.twitter.com/) is a widely-used social networking service provided by Twitter, Inc., enabling users to post and interact with messages known as "tweets".

The `ballerinax/twitter` package offers APIs to connect and interact with [Twitter API](https://developer.twitter.com/en/docs/twitter-api) endpoints, specifically based on [Twitter API v2](https://developer.x.com/en/docs/twitter-api/migrate/whats-new).

## Setup guide

To use the Twitter connector, you must have access to the Twitter API through a [Twitter developer account](https://developer.twitter.com/en) and a project under it. If you do not have a Twitter Developer account, you can sign up for one [here](https://developer.twitter.com/en/apply-for-access).

### Step 1: Create a Twitter Developer Project

1. Open the [Twitter Developer Portal](https://developer.twitter.com/en/portal/dashboard).

2. Click on the "Projects & Apps" tab and select an existing project or create a new one for which you want API Keys and Authentication Tokens.

    ![Twitter Developer Portal](https://github.com/ballerina-platform/module-ballerinax-twitter/blob/main/docs/setup/resources/twitter-developer-portal.png)

### Step 2: Set up user authentication settings

1. Scroll down and Click on the **Set up** button to set up user authentication.

    ![Set up](https://github.com/ballerina-platform/module-ballerinax-twitter/blob/main/docs/setup/resources/set-up.png)

2. Complete the user authentication setup.

### Step 3. Obtain Client Id and Client Secret.

1. After completing the setup, you will be provided with your client Id and client secret. Make sure to save the provided client Id and client secret.

    ![Get Keys](https://github.com/ballerina-platform/module-ballerinax-twitter/blob/main/docs/setup/resources/get-keys.png)

### Step 4: Setup OAuth 2.0 Flow

Before proceeding with the Quickstart, ensure you have obtained the Refresh Token and Access Token using the following steps:

1. Create an authorization URL using the following format:

    ```
    https://twitter.com/i/oauth2/authorize?response_type=code&client_id=<your_client_id>&redirect_uri=<your_redirect_uri>&scope=tweet.read%20tweet.write%20users.read%20follows.read%20offline.access&state=state&code_challenge=<your_code_challenge>&code_challenge_method=plain
    ```

    Replace `<your_client_id>`, `<your_redirect_uri>`, and `<your_code_challenge>` with your specific values. Make sure to include the necessary scopes depending on your use case.

    Example:

    ```
    https://twitter.com/i/oauth2/authorize?response_type=code&client_id=asdasASDas21Y0OGR4bnUxSzA4c0k6MTpjaQ&redirect_uri=http://example&scope=tweet.read%20tweet.write%20users.read%20follows.read%20offline.access&state=state&code_challenge=D601XXCSK57UineGq62gUnsoasdas1GfKUY8QWhOF9hiN_k&code_challenge_method=plain
    ```

    **Note:** By default, the access token you create through the OAuth 2.0 Flow will only stay valid for two hours unless you’ve used the `offline.access` scope.

2. Copy and paste the generated URL into your browser. This will redirect you to the Twitter authorization page.

    ![Authorize Page](https://github.com/ballerina-platform/module-ballerinax-twitter/blob/main/docs/setup/resources/authorize.png)

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

    This command will return the refresh token and access token necessary for API calls.

    ```json
    {
        "token_type":"bearer",
        "expires_in":7200,
        "access_token":"VWdEaEQ2eEdGdmVSbUJQV1U5LUdWREZuYndVT1JaNDdIZGMzblNjRGtvb3dGOjE3MTkzNzYwOTQ1MDQ6MTowOmF0OjE",
        "scope":"follows.read offline.access tweet.write users.read tweet.read",
        "refresh_token":"N21DQUNmRTg5eDJmNFlEYnd4SEhFNFJJSjQ0NGFnSlBNZVJsMG4wX1FpeF9XOjE3MTkzNzYwOTQ1MDQ6MToxOnJ0OjE"
    }
    ```

5. Store the refresh token and access token securely for use in your application.

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


**Note**: Obtained Access tokens are not explicitly expired. Follow the below step to invalidate access token

### Invalidate access token

    ```bash
        curl --location --request POST "https://api.twitter.com/2/oauth2/revoke" ^
        --header "Content-Type: application/x-www-form-urlencoded" ^
        --data-urlencode "token=<your_access_token>" ^
        --data-urlencode "client_id=<your_client_Id>" ^
        --data-urlencode "token_type_hint=access_token"
    ```

    Replace `<your_client_id>`, and `<your_access_token>` with your specific values.


## Building from the source

### Prerequisites

1. Download and install Java SE Development Kit (JDK) version 17. You can download it from either of the following sources:

    * [Oracle JDK](https://www.oracle.com/java/technologies/downloads/)
    * [OpenJDK](https://adoptium.net/)

   > **Note:** After installation, remember to set the `JAVA_HOME` environment variable to the directory where JDK was installed.

2. Download and install [Ballerina Swan Lake](https://ballerina.io/).

3. Download and install [Docker](https://www.docker.com/get-started).

   > **Note**: Ensure that the Docker daemon is running before executing any tests.

4. Export Github Personal access token with read package permissions as follows,

    ```bash
    export packageUser=<Username>
    export packagePAT=<Personal access token>
    ```


### Build options

Execute the commands below to build from the source.

1. To build the package:

   ```bash
   ./gradlew clean build
   ```

2. To run the tests:

   ```bash
   ./gradlew clean test
   ```

3. To build the without the tests:

   ```bash
   ./gradlew clean build -x test
   ```

4. To run tests against different environment:

   ```bash
   ./gradlew clean test -Pgroups=<Comma separated groups/test cases>
   ```

5. To debug package with a remote debugger:

   ```bash
   ./gradlew clean build -Pdebug=<port>
   ```

6. To debug with the Ballerina language:

   ```bash
   ./gradlew clean build -PbalJavaDebug=<port>
   ```

7. Publish the generated artifacts to the local Ballerina Central repository:

    ```bash
    ./gradlew clean build -PpublishToLocalCentral=true
    ```

8. Publish the generated artifacts to the Ballerina Central repository:

   ```bash
   ./gradlew clean build -PpublishToCentral=true
   ```
## Contributing to Ballerina
As an open source project, Ballerina welcomes contributions from the community. 

For more information, see the [Contribution Guidelines](https://github.com/ballerina-platform/ballerina-lang/blob/master/CONTRIBUTING.md).

## Code of conduct
All contributors are encouraged to read the [Ballerina Code of Conduct](https://ballerina.io/code-of-conduct).

## Useful links
* Discuss about code changes of the Ballerina project via [ballerina-dev@googlegroups.com](mailto:ballerina-dev@googlegroups.com).
* Chat live with us via our [Discord server](https://discord.gg/ballerinalang).
* Post all technical questions on Stack Overflow with the [#ballerina](https://stackoverflow.com/questions/tagged/ballerina) tag.
