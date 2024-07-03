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
import ballerina/lang.array;
import ballerinax/twitter;

configurable string accessToken = ?;

public function main() returns error? {
    twitter:Client twitter = check new ({
        auth: {
            token: accessToken
        }
    });

    string username = "ballerinalang";
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

    twitter:FindTweetByIdQueries queries = {
        tweet\.fields: ["public_metrics"]
    };
    twitter:Tweet[] performingTweets = [];
    foreach twitter:Tweet tweet in tweets {
        twitter:TweetId? tweetId = tweet.id;
        if tweetId is () {
            continue;
        }

        twitter:Get2TweetsIdResponse tweetResponse = check twitter->/tweets/[tweetId](queries = queries);
        twitter:Tweet? tweetData = tweetResponse.data;
        if tweetData !is () {
            tweet.public_metrics = tweetData?.public_metrics;
            performingTweets.push(tweet);
        }
    }

    twitter:Tweet[] sortedPerformingTweets = performingTweets.sort(array:DESCENDING, isolated function(twitter:Tweet t) returns int? => t.public_metrics?.like_count);
    io:println("Top Tweets by ", username, " in the last month: ");
    foreach var tweet in sortedPerformingTweets {
        io:println("Tweet: ", tweet.text);
        io:println("Likes: ", tweet.public_metrics?.like_count);
        io:println("Retweet Count: ", tweet.public_metrics?.retweet_count);
    }
}
