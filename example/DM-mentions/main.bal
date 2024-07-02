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

    twitter:Get2TweetsSearchRecentResponse supportTweets = check twitter->/tweets/search/recent(
        query = "#ballerinaSupport",
        max_results = 10
    );

    twitter:TweetId[] tweetIds = [];
    twitter:UserId[] userIds = [];
    twitter:Tweet[] tweets = supportTweets.data ?: [];

    foreach twitter:Tweet tweet in tweets {
        if tweet.id !is () {
            tweetIds.push(check tweet.id.ensureType(string));
        }
    }

    foreach twitter:TweetId tweetId in tweetIds {
        twitter:FindTweetByIdQueries searchQuery = {
                    tweet\.fields: ["author_id"]
                };
        twitter:Get2TweetsIdResponse tweetResponse = check twitter->/tweets/[tweetId](queries = searchQuery);
        if tweetResponse.data?.author_id !is () {
            userIds.push(check tweetResponse.data?.author_id.ensureType(string));
        }
    }

    foreach twitter:UserId userId in userIds {
        if userId == "" {
            continue;
        }
        twitter:CreateDmEventResponse DMResponse = check twitter->/dm_conversations/with/[userId]/messages.post(
            payload = {
                            text: "Thank you for reaching us! We will reach you soon"
                        }
        );

        if DMResponse.data !is () {
            io:println("User ID: ", userId);
            io:println("DM sent successfully");
        } else {
            io:println("Failed to send DM", DMResponse);
        }
    }
}
