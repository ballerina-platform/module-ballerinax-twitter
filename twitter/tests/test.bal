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

TwitterConfiguration twitterConfig = {
    apiKey: apiKey,
    apiSecret: apiSecret,
    accessToken: accessToken,
    accessTokenSecret: accessTokenSecret
};

Client twitterClient = check new(twitterConfig);

@test:Config {}
function testTweet() {
    log:printInfo("testTweet");
    [int, decimal] & readonly currentTime = time:utcNow();
    string currentTimeStamp = currentTime[0].toString();
    string status = "Learn Ballerina " + currentTimeStamp;
    UpdateTweetOptions updateTweetOptions = {};
    var tweetResponse = twitterClient->tweet(status, "https://ballerina.io/learn/by-example/introduction/",
                                             updateTweetOptions);

    if (tweetResponse is Tweet) {
        tweetID = <@untainted> tweetResponse.id;
        userID = <@untainted> tweetResponse.user.id;
        log:printInfo(tweetResponse.toString());
        test:assertTrue((tweetResponse.id != 0), "Failed to call tweet()");
    } else {
        test:assertFail(tweetResponse.message());
    }
}

@test:Config {
    dependsOn: [testTweet]
}
function testReplyTweet() {
    log:printInfo("testReplyTweet");
    [int, decimal] & readonly currentTime = time:utcNow();
    string currentTimeStamp = currentTime[0].toString();
    string status = "Reply Learn Ballerina " + currentTimeStamp;
    var tweetResponse = twitterClient->replyTweet(status, tweetID);

    if (tweetResponse is Tweet) {
        replytweetID = <@untainted> tweetResponse.id;
        log:printInfo(tweetResponse.toString());
        test:assertTrue(regex:matches(tweetResponse.text, status), "Failed to call replyTweet()");
    } else {
        test:assertFail(tweetResponse.message());
    }
}

@test:Config {
    dependsOn: [testReplyTweet]
}
function testReTweet() {
    log:printInfo("testReTweet");
    var tweetResponse = twitterClient->retweet(tweetID);

    if (tweetResponse is Tweet) {
        var retweetStatus = tweetResponse?.retweeted;
        if (retweetStatus is boolean) {
            log:printInfo(tweetResponse.toString());
            test:assertTrue(retweetStatus, "Failed to call retweet()");
        } else {
            test:assertFail("Tweet is not retweeted");
        }
    } else {
        test:assertFail(tweetResponse.message());
    }
}

@test:Config {
    dependsOn: [testReTweet]
}
function testDeleteReTweet() {
    log:printInfo("testDeleteReTweet");
    var tweetResponse = twitterClient->deleteRetweet(tweetID);

    if (tweetResponse is Tweet) {
        test:assertEquals(tweetResponse.id, tweetID, "Failed to call deleteRetweet()");
    } else {
        test:assertFail(tweetResponse.message());
    }
}

@test:Config {}
function testSearch() {
    log:printInfo("testSearch");
    string queryStr = "SriLanka";
    SearchOptions request = {
        count: 10
    };
    var tweetResponse = twitterClient->search(queryStr, request);

    if (tweetResponse is error) {
        test:assertFail(tweetResponse.message());
    } else {
        test:assertTrue(tweetResponse.length() > 0, "Failed to call search()");
    }
}

@test:Config {
    dependsOn: [testSearch]
}
function testShowStatus() {
    log:printInfo("testShowStatus");
    var tweetResponse = twitterClient->showStatus(tweetID);

    if (tweetResponse is Tweet) {
        log:printInfo(tweetResponse.toString());
        test:assertEquals(tweetResponse.id, tweetID, "Failed to call showStatus()");
    } else {
        test:assertFail(tweetResponse.message());
    }
}

@test:Config {
    dependsOn: [testShowStatus]
}
function testGetUserTimeline() {
    log:printInfo("testGetUserTimeline");
    var tweetResponse = twitterClient->getUserTimeline(5);

    if (tweetResponse is Tweet[]) {
        test:assertTrue(true, "Failed to call getHomeTimeline()");
    } else {
        test:assertFail(tweetResponse.message());
    }
}

@test:Config {
    dependsOn: [testShowStatus], enable: true
}
function testGetLast10Tweets() {
    log:printInfo("testGetLast10Tweets");
    var tweetResponse = twitterClient->getLast10Tweets(trimUser=true);

    if (tweetResponse is Tweet[]) {
        test:assertTrue(true, "Failed to call getLast10Tweets()");
        foreach var tweet in tweetResponse {
            log:printInfo(tweet.toString());
        }
    } else {
        test:assertFail(tweetResponse.message());
    }
}

@test:Config {
    dependsOn: [testGetUserTimeline]
}
function testGetUser() {
    log:printInfo("testGetUser");
    var userResponse = twitterClient->getUser(userID);

    if (userResponse is User) {
        test:assertEquals(userResponse?.id, userID, "Failed to call getUser()");
    } else {
        test:assertFail(userResponse.message());
    }
}

@test:Config {}
function testGetFollowers() {
    log:printInfo("testGetFollowers");
    var userResponse = twitterClient->getFollowers(userID);

    if (userResponse is error) {
        log:printInfo(userResponse.toString());
        test:assertFail(userResponse.message());
    } else {
        log:printInfo(userResponse.toString());
        test:assertTrue(userResponse.length() > 0, "Failed to call getFollowers()");
    }
}

@test:Config {}
function testGetFollowing() {
    log:printInfo("testGetFollowing");
    var userResponse = twitterClient->getFollowing(userID);

    if (userResponse is error) {
        log:printInfo(userResponse.toString());
        test:assertFail(userResponse.message());
    } else {
        log:printInfo(userResponse.toString());
        test:assertTrue(userResponse.length() > 0, "Failed to call getFollowing()");
    }
}

@test:AfterSuite { }
function afterSuite() {
    var tweetResponse = twitterClient->deleteTweet(tweetID);
    if (tweetResponse is Tweet) {
        test:assertEquals(tweetResponse.id, tweetID, "Failed to call deleteTweet()");
    } else {
        test:assertFail(tweetResponse.message());
    }

    var retweetDeleteResponse = twitterClient->deleteTweet(replytweetID);
    if (retweetDeleteResponse is Tweet) {
        test:assertTrue(true, msg = "Delete Retweet Failed");
    } else {
        test:assertFail(msg = retweetDeleteResponse.message());
    }
}
