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

import ballerina/test;
import ballerina/time;
import ballerina/os;

configurable boolean isLiveServer = os:getEnv("IS_LIVE_SERVER") == "true";
configurable string userId = isLiveServer ? os:getEnv("TWITTER_USER_ID") : "test";
configurable string token = isLiveServer ? os:getEnv("TWITTER_TOKEN") : "test";
configurable string serviceUrl = isLiveServer ? "https://api.twitter.com/2" : "http://localhost:9090/";

ConnectionConfig config = {auth: {token: token}};
final Client twitter = check new Client(config, serviceUrl);

//Test Posting a Tweet
@test:Config {
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

//Test Get Twitter User Id of a user By Username
@test:Config {
}
isolated function testgetUserIdByUseName() returns error? {
    Get2UsersByUsernameUsernameResponse response = check twitter->/users/'by/username/["KumarSanga2"];
    test:assertTrue(response?.data !is ());
    test:assertTrue(response?.errors is ());
}

//Test Like a Post via Post  ID
@test:Config {
}
isolated function testUserLikeAPost() returns error? {
    UsersLikesCreateResponse response = check twitter->/users/[userId]/likes.post(
        payload = {
            tweet_id:"1806286701704462623"
        }
    );
    test:assertTrue(response?.data !is ());
    test:assertTrue(response?.errors is  ());
}

//Test Unlike a Post via Post  ID
@test:Config {
}
isolated function testUserUnlikeAPost() returns error? {
    UsersLikesDeleteResponse response = check twitter->/users/[userId]/likes/["1806286701704462623"].delete();
    test:assertTrue(response?.data !is ());
    test:assertTrue(response?.errors is  ());
}

//Test grab information of a specific post via Id
@test:Config {
}
isolated function testPostLookup() returns error? {
    Get2TweetsIdResponse response = check twitter->/tweets/["1806286701704462623"]();
    test:assertTrue(response?.data !is ());
    test:assertTrue(response?.errors is  ());
}

//Test Bookmark a Post
@test:Config {
}
isolated function testBookmarkPost() returns error? {
    BookmarkMutationResponse response = check twitter->/users/[userId]/bookmarks.post(
        payload = {tweet_id: "1806286701704462623"}
    );
    test:assertTrue(response?.data !is ());
    test:assertTrue(response?.errors is  ());
}

//Test Unbookmark a Post
@test:Config {
}
isolated function testBookmarkDelete() returns error? {
    BookmarkMutationResponse response = check twitter->/users/[userId]/bookmarks/["1806286701704462623"].delete();
    test:assertTrue(response?.data !is ());
    test:assertTrue(response?.errors is  ());
}


//Test Retweet a Post via Post  ID
@test:Config {
}
isolated function testRetweet() returns error? {
    UsersRetweetsCreateResponse response = check twitter->/users/[userId]/retweets.post(
        payload = {tweet_id: "1806286701704462623"}
    );
    test:assertTrue(response?.data !is ());
    test:assertTrue(response?.errors is  ());
}

//Test Unretweet a Post via Post  ID
@test:Config {
}
isolated function testDeleteRetweet() returns error? {
    UsersRetweetsDeleteResponse response = check twitter->/users/[userId]/retweets/["1806286701704462623"].delete();
    test:assertTrue(response?.data !is ());
    test:assertTrue(response?.errors is  ());
}

//Test Follow a Specific User
@test:Config {
}
isolated function testFollowSpecificUser() returns error? {
    UsersFollowingCreateResponse response = check twitter->/users/[userId]/following.post(
        payload={
            target_user_id:"1803011651249278976"
        }
    );
    test:assertTrue(response?.data !is ());
    test:assertTrue(response?.errors is  ());
}

//Test Unfollow a Specific User
@test:Config {
}
isolated function testUnfollowSpecificUser() returns error? {
    UsersFollowingDeleteResponse response = check twitter->/users/[userId]/following/["1803011651249278976"].delete();
    test:assertTrue(response?.data !is ());
    test:assertTrue(response?.errors is  ());
}

//Test Mute a Specific User
@test:Config {
}
isolated function muteSpecificUser() returns error? {
    MuteUserMutationResponse response = check twitter->/users/[userId]/muting.post(
        payload={
            target_user_id:"1803011651249278976"
        }
    );
    test:assertTrue(response?.data !is ());
    test:assertTrue(response?.errors is  ());
}

//Test Unmute a Specific User
@test:Config {
}
isolated function unmuteSpecificUser() returns error? {
    MuteUserMutationResponse response = check twitter->/users/[userId]/muting/["1803011651249278976"].delete();
    test:assertTrue(response?.data !is ());
    test:assertTrue(response?.errors is  ());
}

//Test FInd User Via ID 
@test:Config {
}
isolated function findSpecificUser() returns error? {
    Get2UsersResponse response = check twitter->/users(ids = ["1803011651249278976"]);
    test:assertTrue(response?.data !is ());
    test:assertTrue(response?.errors is  ());
}
