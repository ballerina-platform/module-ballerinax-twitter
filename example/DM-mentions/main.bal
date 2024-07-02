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
    
    // Initialize the client
    twitter:Client twitter = check new ({
        auth: {
            token: accessToken
        }
    });

    // a search query to search for tweets
    string searchQuery = "#ballerinaSupport";

    // search for recent tweets
    twitter:Get2TweetsSearchRecentResponse tweetList = check twitter->/tweets/search/recent(
        query = searchQuery,
        max_results = 10
    );

    // Initialize tweetIdList and userIdList
    twitter:TweetId[] tweetIdList = [];
    twitter:UserId[] userIdList = [];

    // Extract tweets from the response
    twitter:Tweet[] tweets = tweetList.data ?: [];

    // Iterate through the tweets and extract the tweet IDs
    foreach twitter:Tweet tweet in tweets {
        tweetIdList.push(tweet.id ?: "");
    }

    // Iterate through the tweet IDs and extract the user IDs
    foreach twitter:TweetId tweetId in tweetIdList {
        if (tweetId == "") {
            continue;
        }

        // Find the author ID of the tweet
        twitter:FindTweetByIdQueries queries = {
                    tweet\.fields: ["author_id"]
                };
        twitter:Get2TweetsIdResponse tweetResponse = check twitter->/tweets/[tweetId](queries = queries);

        userIdList.push(tweetResponse.data?.author_id ?: "");
    }

    // Iterate through the user IDs and send a DM to each user
    foreach twitter:UserId userId in userIdList {
        if (userId == "") {
            continue;
        }

        io:println("User ID: ", userId);

        // Send a DM to the user
        twitter:CreateDmEventResponse DMResponse = check twitter->/dm_conversations/with/[userId]/messages.post(
            payload = {
                            text: "Thank you for reaching us! We will reach you soon"
                        }
        );

        if (DMResponse.data != null) {
            io:println("DM sent successfully");
        } else {
            io:println("Failed to send DM", DMResponse);
        }
    }
}