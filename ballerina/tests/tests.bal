// Copyright (c) 2024, WSO2 LLC. (http://www.wso2.com).
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

import ballerina/os;
import ballerina/test;
import ballerina/time;

configurable boolean isLiveServer = os:getEnv("IS_LIVE_SERVER") == "true";
configurable string userId = isLiveServer ? os:getEnv("TWITTER_USER_ID") : "test";
configurable string token = isLiveServer ? os:getEnv("TWITTER_TOKEN") : "test";
configurable string serviceUrl = isLiveServer ? "https://api.twitter.com/2" : "http://localhost:9090";

ConnectionConfig config = {auth: {token}};
final Client twitter = check new Client(config, serviceUrl);

final string test_user_id = "15594932";
final string test_post_id = "1808153657558311048";

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
isolated function testPostTweet() returns error? {
    time:Utc utc = time:utcNow();
    string tweetText = "Twitter Test at " + utc.toString();
    TweetCreateResponse response = check twitter->/tweets.post(payload = {
        text: tweetText
    });
    test:assertTrue(response?.data !is ());
    test:assertTrue(response?.errors is ());
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
isolated function testgetUserIdByUseName() returns error? {
    Get2UsersByUsernameUsernameResponse response = check twitter->/users/'by/username/["KumarSanga2"];
    test:assertTrue(response?.data !is ());
    test:assertTrue(response?.errors is ());
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
isolated function testUserLikeAPost() returns error? {
    UsersLikesCreateResponse response = check twitter->/users/[userId]/likes.post(
        payload = {
            tweet_id: test_post_id
        }
    );
    test:assertTrue(response?.data !is ());
    test:assertTrue(response?.errors is ());
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
isolated function testUserUnlikeAPost() returns error? {
    UsersLikesDeleteResponse response = check twitter->/users/[userId]/likes/[test_post_id].delete();
    test:assertTrue(response?.data !is ());
    test:assertTrue(response?.errors is ());
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
isolated function testPostLookup() returns error? {
    Get2TweetsIdResponse response = check twitter->/tweets/[test_post_id]();
    test:assertTrue(response?.data !is ());
    test:assertTrue(response?.errors is ());
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
isolated function testBookmarkPost() returns error? {
    BookmarkMutationResponse response = check twitter->/users/[userId]/bookmarks.post(
        payload = {tweet_id: test_post_id}
    );
    test:assertTrue(response?.data !is ());
    test:assertTrue(response?.errors is ());
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
isolated function testBookmarkDelete() returns error? {
    BookmarkMutationResponse response = check twitter->/users/[userId]/bookmarks/[test_post_id].delete();
    test:assertTrue(response?.data !is ());
    test:assertTrue(response?.errors is ());
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
isolated function testRetweet() returns error? {
    UsersRetweetsCreateResponse response = check twitter->/users/[userId]/retweets.post(
        payload = {tweet_id: test_post_id}
    );
    test:assertTrue(response?.data !is ());
    test:assertTrue(response?.errors is ());
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
isolated function testDeleteRetweet() returns error? {
    UsersRetweetsDeleteResponse response = check twitter->/users/[userId]/retweets/[test_post_id].delete();
    test:assertTrue(response?.data !is ());
    test:assertTrue(response?.errors is ());
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
isolated function testFollowSpecificUser() returns error? {
    UsersFollowingCreateResponse response = check twitter->/users/[userId]/following.post(
        payload = {
            target_user_id: test_user_id
        }
    );
    test:assertTrue(response?.data !is ());
    test:assertTrue(response?.errors is ());
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
isolated function testUnfollowSpecificUser() returns error? {
    UsersFollowingDeleteResponse response = check twitter->/users/[userId]/following/[test_user_id].delete();
    test:assertTrue(response?.data !is ());
    test:assertTrue(response?.errors is ());
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
isolated function muteSpecificUser() returns error? {
    MuteUserMutationResponse response = check twitter->/users/[userId]/muting.post(
        payload = {
            target_user_id: test_user_id
        }
    );
    test:assertTrue(response?.data !is ());
    test:assertTrue(response?.errors is ());
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}

isolated function unmuteSpecificUser() returns error? {
    MuteUserMutationResponse response = check twitter->/users/[userId]/muting/[test_user_id].delete();
    test:assertTrue(response?.data !is ());
    test:assertTrue(response?.errors is ());
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
isolated function findSpecificUser() returns error? {
    Get2UsersResponse response = check twitter->/users(ids = [test_user_id]);
    test:assertTrue(response?.data !is ());
    test:assertTrue(response?.errors is ());
}
