## Analyzing One-Month Tweet Performance

This use case demonstrates how the Twitter API v2 can be utilized to analyze the performance of tweets posted by a user over the past month. The example involves a sequence of actions that leverage the Twitter API v2 to automate the retrieval of tweets and their performance metrics (likes, retweets, replies), and then create a performance report.

## Prerequisites

### 1. Obtain Access token

Refer to the [Setup guide](https://central.ballerina.io/ballerinax/twitter/latest#setup-guide) to obtain access token, if you do not have one

### 2. Configuration

Configure Twitter API v2 related configurations in the `Config.toml` file in the example directory

```bash
accessToken = "<Access Token>"
```

## Run the example

Execute the following command to run the example:

```bash
bal run
```