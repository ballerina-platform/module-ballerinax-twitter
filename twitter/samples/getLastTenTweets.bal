import ballerina/log;
import ballerinax/twitter;

configurable string apiKey = ?;
configurable string apiSecret = ?;
configurable string accessToken = ?;
configurable string accessTokenSecret = ?;

public function main() {

    // Add the Twitter credentials as the Configuration
    twitter:ConnectionConfig configuration = {
        apiKey: apiKey,
        apiSecret: apiSecret,
        accessToken: accessToken,
        accessTokenSecret: accessTokenSecret
    };

    twitter:Client twitterClient = new(configuration);

    twitter:Tweet|error response = twitterClient->getLast10Tweets();
    if (response is twitter:Tweet[]) {
        foreach var tweet in response {
            log:printInfo(tweet.toString());
        }
    }
}