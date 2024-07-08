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

configurable string token = ?;
final twitter:Client twitter = check new ({
    auth: {
        token
    }
});

public function main() returns error? {
    twitter:Get2TweetsSearchRecentResponse supportTweets = check twitter->/tweets/search/recent(
        query = "#ballerinaSupport",
        max_results = 10
    );
    twitter:Tweet[]? tweets = supportTweets.data;
    if tweets is () {
        io:println("No tweets found");
        return;
    }

    twitter:TweetId[] tweetIds = [];
    foreach twitter:Tweet tweet in tweets {
        if tweet.id !is () {
            tweetIds.push(check tweet.id.ensureType(string));
        }
    }

    twitter:UserId[] userIds = [];
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
        twitter:CreateDmEventResponse dmResponse = check twitter->/dm_conversations/with/[userId]/messages.post(
            payload = {
                text: "Thank you for reaching us! We will reach you soon"
            }
        );

        if dmResponse.errors is twitter:Problem[] {
            twitter:Problem[] problems = <twitter:Problem[]>dmResponse.errors;
            foreach twitter:Problem problem in problems {
                io:println("Failed to send DM to user: ", userId);
                io:println("Error: ", problem.detail);
            }
        } else {
            io:println("User ID: ", userId);
            io:println("DM sent successfully");
        }
    }
}
