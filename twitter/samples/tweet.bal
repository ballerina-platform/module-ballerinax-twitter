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

    string tweetContent = "Learn Ballerina";
    string link = "https://ballerina.io/learn/by-example/introduction/";

    twitter:Tweet|error response = twitterClient->tweet(tweetContent, link);
    if (response is twitter:Tweet) {
        log:printInfo("Tweet posted in timeline: " + response);
    }
}