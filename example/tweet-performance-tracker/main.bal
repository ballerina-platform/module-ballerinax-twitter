// Copyright (c) 2024 WSO2 LLC. (http://www.wso2.com).
//
// WSO2 LLC. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

import ballerina/io;
import ballerinax/twitter;

configurable string accessToken = ?;

public function main() returns error? {
    twitter:Client twitter = check new ({
        auth: {
            token: accessToken
        }
    });

    string username = "ballerinalang";
    twitter:Tweet[] performingTweets = [];

    twitter:Get2UsersByUsernameUsernameResponse userResponse = check twitter->/users/'by/username/[username]();
    twitter:User? user = userResponse.data;
    if user is () {
        io:println("User not found");
        return;
    }

    twitter:UserId userId = user.id;
    twitter:Get2UsersIdTweetsResponse tweetsResponse = check twitter->/users/[userId]/tweets({
        start_time: "2024-06-01T00:00:00Z",
        end_time: "2024-07-01T00:00:00Z"
    });
    twitter:Tweet[]? tweets = tweetsResponse.data;
    if tweets is () {
        io:println("No tweets for the user");
        return;
    }

    foreach twitter:Tweet tweet in tweets {
        twitter:TweetId? tweetId = tweet.id;
        if tweetId is () {
            continue;
        }

        twitter:FindTweetByIdQueries queries = {
            tweet\.fields: ["public_metrics"]
        };
        twitter:Get2TweetsIdResponse tweetResponse = check twitter->/tweets/[tweetId](queries = queries);
        twitter:Tweet? tweetData = tweetResponse.data;
        if tweetData is () {
            continue;
        }
        tweet.public_metrics = tweetData?.public_metrics;
        performingTweets.push(tweet);
    }

    // performingTweets.sort(key = sortTweet);
    boolean swapped = false;
    foreach int i in 0 ... performingTweets.length() - 2 {
        swapped = false;
        foreach int j in 1 ... performingTweets.length() - 1 - i {
            if performingTweets[j - 1].public_metrics?.like_count < performingTweets[j].public_metrics?.like_count {
                twitter:Tweet temp = performingTweets[j - 1];
                performingTweets[j - 1] = performingTweets[j];
                performingTweets[j] = temp;
                swapped = true;
            }
        }
        if !swapped {
            break;
        }
    }

    io:println("Top Tweets by ", username, " in the last month: ");
    foreach var tweet in performingTweets {
        io:println("Tweet: ", tweet.text);
        io:println("Likes: ", tweet.public_metrics?.like_count);
        io:println("Retweet Count: ", tweet.public_metrics?.retweet_count);
    }
}

isolated function sortTweet(twitter:Tweet a, twitter:Tweet b) returns int {
    twitter:Tweet_public_metrics? publicMetricsA = a.public_metrics;
    int likesForA = publicMetricsA !is () ? publicMetricsA.like_count : 0;
    twitter:Tweet_public_metrics? publicMetricsB = b.public_metrics;
    int likesForB = publicMetricsB !is () ? publicMetricsB.like_count : 0;
    return likesForA - likesForB;
}
