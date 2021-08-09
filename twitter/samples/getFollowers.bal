import ballerina/log;
import ballerinax/twitter;

configurable string apiKey = ?;
configurable string apiSecret = ?;
configurable string accessToken = ?;
configurable string accessTokenSecret = ?;

public function main() {

    // Add the Twitter credentials as the Configuration
    twitter:TwitterConfiguration configuration = {
        apiKey: apiKey,
        apiSecret: apiSecret,
        accessToken: accessToken,
        accessTokenSecret: accessTokenSecret
    };

    twitter:Client twitterClient = new(configuration);

    twitter:Tweet|error response = twitterClient->getFollowers(<USER_ID>);
    if (response is User[] && response.length() > 0) {
        log:printInfo("Follower detail: " + response);
    }
}