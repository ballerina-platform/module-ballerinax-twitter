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

    string tweetContent = "Retweet";

    twitter:Tweet|error response = twitterClient->retweet(<TWEET_ID>);
    if (response is twitter:Tweet) {
        log:printInfo("Retweeted a Tweet : " + response);
    }
}