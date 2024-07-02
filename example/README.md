# Examples

The `twitter` connector provides practical examples illustrating usage in various scenarios. Explore these [examples](https://github.com/ballerina-platform/module-ballerinax-twitter/tree/main/examples), covering use cases like Direct message company mentions, and tweet performance tracker.

1. [Direct message company mentions](https://github.com/ballerina-platform/module-ballerinax-twitter/tree/main/examples/DM-mentions) - Integrate Twitter to send direct messages to users who mention the company in tweets.

2. [Tweet performance tracker](https://github.com/ballerina-platform/module-ballerinax-twitter/tree/main/examples/tweet-performance-tracker) - Analyze the performance of tweets posted by a user over the past month.


## Prerequisites

1. Generate Twitter credentials to authenticate the connector as described in the [Setup guide](https://central.ballerina.io/ballerinax/twitter/latest#setup-guide).

2. For each example, create a `Config.toml` file the related configuration. Here's an example of how your `Config.toml` file should look:

    ```toml
    accessToken="<Access Token>"
    ```

## Running an Example

Execute the following commands to build an example from the source:

* To build an example:

    ```bash
    bal build
    ```

* To run an example:

    ```bash
    bal run
    ```
