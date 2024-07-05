# Running Tests

## Prerequisites
You need a bearer token and a Access token from twittter(X) developer account.

To do this, refer to [Ballerina Twitter Connector](https://github.com/ballerina-platform/module-ballerinax-twitter/blob/main/ballerina/Module.md).

And You need Find Your User ID For run some of the tests.
Via This Website you can find it [Twitter ID Finder](https://twiteridfinder.com/).

# Running Tests

There are two test environments for running the Twitter(X) connector tests. The default test environment is the mock server for Twitter API. The other test environment is the actual Twitter (X) API. 

You can run the tests in either of these environments and each has its own compatible set of tests.

 Test Groups | Environment                                       
-------------|---------------------------------------------------
 mock_tests  | Mock server for Twitter(X) API (Defualt Environment) 
 live_tests  | Twitter(X) API                                       

## Running Tests in the Mock Server

To execute the tests on the mock server, ensure that the `IS_LIVE_SERVER` environment variable is either set to `false` or unset before initiating the tests. 

This environment variable can be configured within the `Config.toml` file located in the tests directory or specified as an environmental variable.

#### Using a Config.toml File

Create a `Config.toml` file in the tests directory and the following content:

```toml
isLiveServer = false
```

#### Using Environment Variables

Alternatively, you can set your authentication credentials as environment variables:
If you are using linux or mac, you can use following method:
```bash
   export IS_LIVE_SERVER=false
```
If you are using Windows you can use following method:
```bash
   setx IS_LIVE_SERVER false
```
Then, run the following command to run the tests:

```bash
   ./gradlew clean test
```

## Running Tests Against Twitter(X) Live API

#### Using a Config.toml File

Create a `Config.toml` file in the tests directory and add your authentication credentials a

```toml
   isLiveServer = true
   token = "<your-twitter-access-token>"
   userId = "<your-twitter-user-id>"
```

#### Using Environment Variables

Alternatively, you can set your authentication credentials as environment variables:
If you are using linux or mac, you can use following method:
```bash
   export IS_LIVE_SERVER=true
   export TWITTER_TOKEN ="<your-twitter-access-token>"
   export TWITTER_USER_ID ="<your-twitter-user-id>"
```

If you are using Windows you can use following method:
```bash
   setx IS_LIVE_SERVER true
   setx TWITTER_TOKEN <your-twitter-access-token>
   setx TWITTER_USER_ID  <your-twitter-user-id>
```
Then, run the following command to run the tests:

```bash
   ./gradlew clean test 
```
