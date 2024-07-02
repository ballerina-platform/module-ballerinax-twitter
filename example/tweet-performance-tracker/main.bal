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
import ballerina/time;
import ballerinax/twitter;

configurable string accessToken = ?;

public function main() returns error? {

    // Initialize the client
    twitter:Client twitter = check new ({
        auth: {
            token: accessToken
        }
    });

    // Define the username to track and the time range
    string username = "";
    time:Utc utcTimeNow = time:utcNow();
    time:Utc utcTimeBeforeMonth = time:utcAddSeconds(utcTimeNow, -2592000);

    // Initialize tweetsPerformingList
    twitter:Tweet[] tweetsPerformingList = [];

    // Retrieve user by username
    twitter:Get2UsersByUsernameUsernameResponse responseUser = check twitter->/users/'by/username/[username]();
    twitter:User? user = responseUser.data;

    if (user is twitter:User) {
        twitter:UserId userId = user.id;

        // Retrieve tweets posted by the user in the past month
        twitter:Get2UsersIdTweetsResponse responseUserTweets = check twitter->/users/[userId]/tweets({
            start_time: time:utcToString(utcTimeBeforeMonth),
            end_time: time:utcToString(utcTimeNow)
        });
        twitter:Tweet[] tweets = responseUserTweets.data ?: [];

        // Define query parameters
        twitter:FindTweetByIdQueries queries = {
            tweet\.fields: ["public_metrics"]
        };

        // Retrieve detailed metrics for each tweet
        foreach twitter:Tweet tweet in tweets {
            twitter:TweetId tweetId = tweet.id ?: "";
            twitter:Get2TweetsIdResponse responseTweet = check twitter->/tweets/[tweetId](queries = queries);
            twitter:Tweet? tweetData = responseTweet.data;

            if tweetData != null {
                tweet.public_metrics = tweetData.public_metrics;
                tweetsPerformingList.push(tweet);
            }
        }
    }

    // Sort tweetsPerformingList by like_count using bubble sort
    int n = tweetsPerformingList.length();
    boolean swapped = false;
    foreach int i in 0 ... n - 2 {
        swapped = false;
        foreach int j in 1 ... n - 1 - i {
            if (tweetsPerformingList[j - 1].public_metrics?.like_count < tweetsPerformingList[j].public_metrics?.like_count) {
                twitter:Tweet temp = tweetsPerformingList[j - 1];
                tweetsPerformingList[j - 1] = tweetsPerformingList[j];
                tweetsPerformingList[j] = temp;
                swapped = true;
            }
        }
        if (!swapped) {
            break;
        }
    }

    // Print the sorted tweets
    io:println("Top Tweets by ", username, " in the last month: ");
    foreach var tweet in tweetsPerformingList {
        io:println("Tweet: ", tweet.text);
        io:println("Likes: ", tweet.public_metrics?.like_count);
        io:println("Retweet Count: ", tweet.public_metrics?.retweet_count);
    }
}