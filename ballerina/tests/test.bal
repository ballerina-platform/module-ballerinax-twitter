import ballerina/test;
import ballerina/time;
import ballerina/os;

configurable boolean isLiveServer = os:getEnv("IS_LIVE_SERVER") == "true";
configurable string userId = isLiveServer ? os:getEnv("TWITTER_USER_ID") : "test";
configurable string token = isLiveServer ? os:getEnv("TWITTER_TOKEN") : "test";
configurable string serviceUrl = isLiveServer ? "https://api.twitter.com/2" : "http://localhost:9090/";

ConnectionConfig config = {auth: {token: token}};
final Client baseClient = check new Client(config, serviceUrl);

//Test Posting a Tweet
@test:Config {
}
isolated function testPostTweet() returns error? {
    time:Utc utc = time:utcNow();
    string tweetText = "Twitter Test at " + utc.toString();
    TweetCreateResponse response = check baseClient->/tweets.post(payload = {
        text: tweetText
    });
    test:assertTrue(response?.data !is ());
    test:assertTrue(response?.errors is ());
}

//Test Get Twitter User Id of a user By Username
@test:Config {
}
isolated function testgetUserIdByUseName() returns error? {
    Get2UsersByUsernameUsernameResponse response = check baseClient->/users/'by/username/["KumarSanga2"];
    test:assertTrue(response?.data !is ());
    test:assertTrue(response?.errors is ());
}

//Test Like a Post via Post  ID
@test:Config {
}
isolated function testUserLikeAPost() returns error? {
    UsersLikesCreateResponse response = check baseClient->/users/[userId]/likes.post(
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
    UsersLikesDeleteResponse response = check baseClient->/users/[userId]/likes/["1806286701704462623"].delete();
    test:assertTrue(response?.data !is ());
    test:assertTrue(response?.errors is  ());
}

//Test grab information of a specific post via Id
@test:Config {
}
isolated function testPostLookup() returns error? {
    Get2TweetsIdResponse response = check baseClient->/tweets/["1806286701704462623"]();
    test:assertTrue(response?.data !is ());
    test:assertTrue(response?.errors is  ());
}

//Test Bookmark a Post
@test:Config {
}
isolated function testBookmarkPost() returns error? {
    BookmarkMutationResponse response = check baseClient->/users/[userId]/bookmarks.post(
        payload = {tweet_id: "1806286701704462623"}
    );
    test:assertTrue(response?.data !is ());
    test:assertTrue(response?.errors is  ());
}

//Test Unbookmark a Post
@test:Config {
}
isolated function testBookmarkDelete() returns error? {
    BookmarkMutationResponse response = check baseClient->/users/[userId]/bookmarks/["1806286701704462623"].delete();
    test:assertTrue(response?.data !is ());
    test:assertTrue(response?.errors is  ());
}


//Test Retweet a Post via Post  ID
@test:Config {
}
isolated function testRetweet() returns error? {
    UsersRetweetsCreateResponse response = check baseClient->/users/[userId]/retweets.post(
        payload = {tweet_id: "1806286701704462623"}
    );
    test:assertTrue(response?.data !is ());
    test:assertTrue(response?.errors is  ());
}

//Test Unretweet a Post via Post  ID
@test:Config {
}
isolated function testDeleteRetweet() returns error? {
    UsersRetweetsDeleteResponse response = check baseClient->/users/[userId]/retweets/["1806286701704462623"].delete();
    test:assertTrue(response?.data !is ());
    test:assertTrue(response?.errors is  ());
}

//Test Follow a Specific User
@test:Config {
}
isolated function testFollowSpecificUser() returns error? {
    UsersFollowingCreateResponse response = check baseClient->/users/[userId]/following.post(
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
    UsersFollowingDeleteResponse response = check baseClient->/users/[userId]/following/["1803011651249278976"].delete();
    test:assertTrue(response?.data !is ());
    test:assertTrue(response?.errors is  ());
}

//Test Mute a Specific User
@test:Config {
}
isolated function muteSpecificUser() returns error? {
    MuteUserMutationResponse response = check baseClient->/users/[userId]/muting.post(
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
    MuteUserMutationResponse response = check baseClient->/users/[userId]/muting/["1803011651249278976"].delete();
    test:assertTrue(response?.data !is ());
    test:assertTrue(response?.errors is  ());
}

//Test FInd User Via ID 
@test:Config {
}
isolated function findSpecificUser() returns error? {
    Get2UsersResponse response = check baseClient->/users(ids = ["1803011651249278976"]);
    test:assertTrue(response?.data !is ());
    test:assertTrue(response?.errors is  ());
}
