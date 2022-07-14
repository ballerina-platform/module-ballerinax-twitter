// Copyright (c) 2021 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
//
// WSO2 Inc. licenses this file to you under the Apache License,
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

import ballerina/log;
import ballerina/os;
import ballerina/regex;
import ballerina/test;
import ballerina/time;

configurable string apiKey = os:getEnv("API_KEY");
configurable string apiSecret = os:getEnv("API_SECRET");
configurable string accessToken = os:getEnv("ACCESS_TOKEN");
configurable string accessTokenSecret = os:getEnv("ACCESS_TOKEN_SECRET");

int tweetID = 0;
int replytweetID = 0;
int userID = 0;
string screenName = "";

ConnectionConfig twitterConfig = {
    apiKey: apiKey,
    apiSecret: apiSecret,
    accessToken: accessToken,
    accessTokenSecret: accessTokenSecret
};

Client twitterClient = check new(twitterConfig);

@test:Config {}
function testTweet() returns error? {
    log:printInfo("testTweet");
    [int, decimal] & readonly currentTime = time:utcNow();
    string currentTimeStamp = currentTime[0].toString();
    string status = "Learn Ballerina " + currentTimeStamp;
    UpdateTweetOptions updateTweetOptions = {};
    Tweet tweetResponse = check twitterClient->tweet(status, "https://ballerina.io/learn/by-example/introduction/",
                                             updateTweetOptions);
    tweetID = <@untainted> tweetResponse.id;
    userID = <@untainted> tweetResponse.user.id;
    screenName = <@untainted> tweetResponse.user.screen_name;
    log:printInfo(tweetResponse.toString());
    test:assertTrue((tweetResponse.id != 0), "Failed to call tweet()");
}

@test:Config {
    dependsOn: [testTweet]
}
function testReplyTweet() returns error? {
    log:printInfo("testReplyTweet");
    [int, decimal] & readonly currentTime = time:utcNow();
    string currentTimeStamp = currentTime[0].toString();
    string status = "Reply Learn Ballerina " + currentTimeStamp;
    Tweet tweetResponse = check twitterClient->replyTweet(status, tweetID);
    replytweetID = <@untainted> tweetResponse.id;
    log:printInfo(tweetResponse.toString());
    test:assertTrue(regex:matches(tweetResponse.text, status), "Failed to call replyTweet()");
}

@test:Config {
    dependsOn: [testReplyTweet]
}
function testReTweet() returns error? {
    log:printInfo("testReTweet");
    Tweet tweetResponse = check twitterClient->retweet(tweetID);
    boolean? retweetStatus = tweetResponse?.retweeted;
    if (retweetStatus is boolean) {
        log:printInfo(tweetResponse.toString());
        test:assertTrue(retweetStatus, "Failed to call retweet()");
    } else {
        test:assertFail("Tweet is not retweeted");
    }
}

@test:Config {
    dependsOn: [testReTweet]
}
function testDeleteReTweet() returns error? {
    log:printInfo("testDeleteReTweet");
    Tweet tweetResponse = check twitterClient->deleteRetweet(tweetID);
    test:assertEquals(tweetResponse.id, tweetID, "Failed to call deleteRetweet()");
}

@test:Config {}
function testSearch() returns error? {
    log:printInfo("testSearch");
    string queryStr = "SriLanka";
    SearchOptions request = {
        count: 10
    };
    Tweet[] tweetResponse = check twitterClient->search(queryStr, request);
    test:assertTrue(tweetResponse.length() > 0, "Failed to call search()");
}

@test:Config {
    dependsOn: [testSearch]
}
function testShowStatus() returns error? {
    log:printInfo("testShowStatus");
    Tweet tweetResponse = check twitterClient->showStatus(tweetID);
    log:printInfo(tweetResponse.toString());
    test:assertEquals(tweetResponse.id, tweetID, "Failed to call showStatus()");
}

@test:Config {
    dependsOn: [testShowStatus]
}
function testGetUserTimeline() returns error? {
    log:printInfo("testGetUserTimeline");
    Tweet[] tweetResponse = check twitterClient->getUserTimeline(5);
    log:printInfo(tweetResponse.toString());
}

@test:Config {
    dependsOn: [testGetUserTimeline], enable: true
}
function testGetUserTweets() returns error? {
    log:printInfo("testGetUserTweets");
    Tweet[] tweetResponse = check twitterClient->getUserTweets(screenName);
    foreach Tweet tweet in tweetResponse {
        log:printInfo(tweet.toString());
    }
}

@test:Config {
    dependsOn: [testGetUserTweets], enable: true
}
function testGetLast10Tweets() returns error? {
    log:printInfo("testGetLast10Tweets");
    Tweet[] tweetResponse = check twitterClient->getLast10Tweets(trimUser=true);
    foreach Tweet tweet in tweetResponse {
        log:printInfo(tweet.toString());
    }
}

@test:Config {
    dependsOn: [testGetLast10Tweets]
}
function testGetUser() returns error? {
    log:printInfo("testGetUser");
    User userResponse = check twitterClient->getUser(userID);
    test:assertEquals(userResponse?.id, userID, "Failed to call getUser()");
}

@test:Config {
   dependsOn: [testGetUser]
}
function testGetUserByHandle() returns error? {
    log:printInfo("testGetUserByHandle");
    User userResponse = check twitterClient->getUserByHandle(screenName);
    test:assertEquals(userResponse?.screen_name, screenName, "Failed to call getUser()");
}

@test:Config {}
function testGetFollowers() returns error? {
    log:printInfo("testGetFollowers");
    User[] followers = check twitterClient->getFollowers(userID);
    log:printInfo(followers.toString());
}

@test:Config {}
function testGetFollowing() returns error? {
    log:printInfo("testGetFollowing");
    User[] following = check twitterClient->getFollowing(userID);
    log:printInfo(following.toString());
}

@test:AfterSuite { }
function afterSuite() returns error? {
    Tweet tweetResponse = check twitterClient->deleteTweet(tweetID);
    test:assertEquals(tweetResponse.id, tweetID, "Failed to call deleteTweet()");

    Tweet retweetDeleteResponse = check twitterClient->deleteTweet(replytweetID);
    log:printInfo(retweetDeleteResponse.toString());
}
