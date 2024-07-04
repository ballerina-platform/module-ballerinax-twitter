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

import ballerina/http;
import ballerina/log;

listener http:Listener httpListener = new (9090);

http:Service mockService = service object {

    # Remove a bookmarked Post
    #
    # + id - The ID of the authenticated source User whose bookmark is to be removed.
    # + tweet_id - The ID of the Post that the source User is removing from bookmarks.
    # + return - returns can be any of following types
    # http:Ok (The request has succeeded.)
    # http:Response (The request has failed.)
    resource function delete users/[UserIdMatchesAuthenticatedUser id]/bookmarks/[TweetId tweet_id]() returns BookmarkMutationResponse|http:Response {
        return {
            "data": {"bookmarked": false}
        };
    }

    # Causes the User (in the path) to unlike the specified Post
    #
    # + id - The ID of the authenticated source User that is requesting to unlike the Post.
    # + tweet_id - The ID of the Post that the User is requesting to unlike.
    # + return - returns can be any of following types
    # http:Ok (The request has succeeded.)
    # http:Response (The request has failed.)
    resource function delete users/[UserIdMatchesAuthenticatedUser id]/likes/[TweetId tweet_id]() returns UsersLikesDeleteResponse|http:Response {
        return {
            "data": {"liked": false}
        };
    }

    # Causes the User (in the path) to unretweet the specified Post
    #
    # + id - The ID of the authenticated source User that is requesting to repost the Post.
    # + source_tweet_id - The ID of the Post that the User is requesting to unretweet.
    # + return - returns can be any of following types
    # http:Ok (The request has succeeded.)
    # http:Response (The request has failed.)
    resource function delete users/[UserIdMatchesAuthenticatedUser id]/retweets/[TweetId source_tweet_id]() returns UsersRetweetsDeleteResponse|http:Response {
        return {
            "data": {"retweeted": false}
        };
    }

    # Unfollow User
    #
    # + source_user_id - The ID of the authenticated source User that is requesting to unfollow the target User.
    # + target_user_id - The ID of the User that the source User is requesting to unfollow.
    # + return - returns can be any of following types
    # http:Ok (The request has succeeded.)
    # http:Response (The request has failed.)
    resource function delete users/[UserIdMatchesAuthenticatedUser source_user_id]/following/[UserId target_user_id]() returns UsersFollowingDeleteResponse|http:Response {
        return {
            "data": {"following": false}
        };
    }

    # Unmute User by User ID
    #
    # + source_user_id - The ID of the authenticated source User that is requesting to unmute the target User.
    # + target_user_id - The ID of the User that the source User is requesting to unmute.
    # + return - returns can be any of following types
    # http:Ok (The request has succeeded.)
    # http:Response (The request has failed.)
    resource function delete users/[UserIdMatchesAuthenticatedUser source_user_id]/muting/[UserId target_user_id]() returns MuteUserMutationResponse|http:Response {
        return {
            "data": {"muting": false}
        };
    }

    # Post lookup by Post ID
    #
    # + id - A single Post ID.
    # + tweet\.fields - A comma separated list of Tweet fields to display.
    # + expansions - A comma separated list of fields to expand.
    # + media\.fields - A comma separated list of Media fields to display.
    # + poll\.fields - A comma separated list of Poll fields to display.
    # + user\.fields - A comma separated list of User fields to display.
    # + place\.fields - A comma separated list of Place fields to display.
    # + return - returns can be any of following types
    # http:Ok (The request has succeeded.)
    # http:Response (The request has failed.)
    resource function get tweets/[TweetId id](("attachments"|"author_id"|"card_uri"|"context_annotations"|"conversation_id"|"created_at"|"edit_controls"|"edit_history_tweet_ids"|"entities"|"geo"|"id"|"in_reply_to_user_id"|"lang"|"non_public_metrics"|"note_tweet"|"organic_metrics"|"possibly_sensitive"|"promoted_metrics"|"public_metrics"|"referenced_tweets"|"reply_settings"|"scopes"|"source"|"text"|"username"|"withheld")[]? tweet\.fields, ("attachments.media_keys"|"attachments.media_source_tweet"|"attachments.poll_ids"|"author_id"|"edit_history_tweet_ids"|"entities.mentions.username"|"geo.place_id"|"in_reply_to_user_id"|"entities.note.mentions.username"|"referenced_tweets.id"|"referenced_tweets.id.author_id"|"author_screen_name")[]? expansions, ("alt_text"|"duration_ms"|"height"|"media_key"|"non_public_metrics"|"organic_metrics"|"preview_image_url"|"promoted_metrics"|"public_metrics"|"type"|"url"|"variants"|"width")[]? media\.fields, ("duration_minutes"|"end_datetime"|"id"|"options"|"voting_status")[]? poll\.fields, ("connection_status"|"created_at"|"description"|"entities"|"id"|"location"|"most_recent_tweet_id"|"name"|"pinned_tweet_id"|"profile_image_url"|"protected"|"public_metrics"|"receives_your_dm"|"subscription_type"|"url"|"username"|"verified"|"verified_type"|"withheld")[]? user\.fields, ("contained_within"|"country"|"country_code"|"full_name"|"geo"|"id"|"name"|"place_type")[]? place\.fields) returns Get2TweetsIdResponse|http:Response {
        return {
            "data": {"edit_history_tweet_ids": ["1806286701704462623"], "id": "1806286701704462623", "text": "aasbcascbasjbc"}
        };
    }

    resource function get users/'by/username/[string username](("connection_status"|"created_at"|"description"|"entities"|"id"|"location"|"most_recent_tweet_id"|"name"|"pinned_tweet_id"|"profile_image_url"|"protected"|"public_metrics"|"receives_your_dm"|"subscription_type"|"url"|"username"|"verified"|"verified_type"|"withheld")[]? user\.fields, ("most_recent_tweet_id"|"pinned_tweet_id")[]? expansions, ("attachments"|"author_id"|"card_uri"|"context_annotations"|"conversation_id"|"created_at"|"edit_controls"|"edit_history_tweet_ids"|"entities"|"geo"|"id"|"in_reply_to_user_id"|"lang"|"non_public_metrics"|"note_tweet"|"organic_metrics"|"possibly_sensitive"|"promoted_metrics"|"public_metrics"|"referenced_tweets"|"reply_settings"|"scopes"|"source"|"text"|"username"|"withheld")[]? tweet\.fields) returns Get2UsersByUsernameUsernameResponse|http:Response {
        return {
            "data": {"id": "350224247", "name": "Kumar Sangakkara", "username": "KumarSanga2"}
        };
    }

    # Creation of a Post
    #
    # + return - returns can be any of following types
    # http:Created (The request has succeeded.)
    # http:Response (The request has failed.)
    resource function post tweets(@http:Payload TweetCreateRequest payload) returns TweetCreateResponse|http:Response {
        return {
            "data": {"id": "1807808193139204482", "text": "Twitter Test at[1719850035,0.227505100]", "edit_history_tweet_ids": ["1807808193139204482"]}
        };
    }

    # Add Post to Bookmarks
    #
    # + id - The ID of the authenticated source User for whom to add bookmarks.
    # + return - returns can be any of following types
    # http:Ok (The request has succeeded.)
    # http:Response (The request has failed.)
    resource function post users/[UserIdMatchesAuthenticatedUser id]/bookmarks(@http:Payload BookmarkAddRequest payload) returns BookmarkMutationResponse|http:Response {
        return {
            "data": {"bookmarked": true}
        };
    }

    # Follow User
    #
    # + id - The ID of the authenticated source User that is requesting to follow the target User.
    # + return - returns can be any of following types
    # http:Ok (The request has succeeded.)
    # http:Response (The request has failed.)
    resource function post users/[UserIdMatchesAuthenticatedUser id]/following(@http:Payload UsersFollowingCreateRequest payload) returns UsersFollowingCreateResponse|http:Response {
        return {
            "data": {"following": true, "pending_follow": false}
        };
    }

    # Causes the User (in the path) to like the specified Post
    #
    # + id - The ID of the authenticated source User that is requesting to like the Post.
    # + return - returns can be any of following types
    # http:Ok (The request has succeeded.)
    # http:Response (The request has failed.)
    resource function post users/[UserIdMatchesAuthenticatedUser id]/likes(@http:Payload UsersLikesCreateRequest payload) returns UsersLikesCreateResponse|http:Response {
        return {
            "data": {"liked": true}
        };
    }

    # Mute User by User ID.
    #
    # + id - The ID of the authenticated source User that is requesting to mute the target User.
    # + return - returns can be any of following types
    # http:Ok (The request has succeeded.)
    # http:Response (The request has failed.)
    resource function post users/[UserIdMatchesAuthenticatedUser id]/muting(@http:Payload MuteUserRequest payload) returns MuteUserMutationResponse|http:Response {
        return {
            "data": {"muting": true}
        };
    }

    # Causes the User (in the path) to repost the specified Post.
    #
    # + id - The ID of the authenticated source User that is requesting to repost the Post.
    # + return - returns can be any of following types
    # http:Ok (The request has succeeded.)
    # http:Response (The request has failed.)
    resource function post users/[UserIdMatchesAuthenticatedUser id]/retweets(@http:Payload UsersRetweetsCreateRequest payload) returns UsersRetweetsCreateResponse|http:Response {
        return {
            "data": {"retweeted": true, "rest_id": "1807808194787590411"}
        };
    }

    # User lookup by IDs
    #
    # + ids - A list of User IDs, comma-separated. You can specify up to 100 IDs.
    # + user\.fields - A comma separated list of User fields to display.
    # + expansions - A comma separated list of fields to expand.
    # + tweet\.fields - A comma separated list of Tweet fields to display.
    # + return - returns can be any of following types
    # http:Ok (The request has succeeded.)
    # http:Response (The request has failed.)
    resource function get users(UserId[] ids, ("connection_status"|"created_at"|"description"|"entities"|"id"|"location"|"most_recent_tweet_id"|"name"|"pinned_tweet_id"|"profile_image_url"|"protected"|"public_metrics"|"receives_your_dm"|"subscription_type"|"url"|"username"|"verified"|"verified_type"|"withheld")[]? user\.fields, ("most_recent_tweet_id"|"pinned_tweet_id")[]? expansions, ("attachments"|"author_id"|"card_uri"|"context_annotations"|"conversation_id"|"created_at"|"edit_controls"|"edit_history_tweet_ids"|"entities"|"geo"|"id"|"in_reply_to_user_id"|"lang"|"non_public_metrics"|"note_tweet"|"organic_metrics"|"possibly_sensitive"|"promoted_metrics"|"public_metrics"|"referenced_tweets"|"reply_settings"|"scopes"|"source"|"text"|"username"|"withheld")[]? tweet\.fields) returns Get2UsersResponse|http:Response {
        return {
            "data": [{"id": "350224247", "name": "Kumar Sangakkara", "username": "KumarSanga2"}]
        };
    }
};

function init() returns error? {
    if isLiveServer {
        log:printInfo("Skiping mock server initialization as the tests are running on live server");
        return;
    }
    log:printInfo("Initiating mock server");
    check httpListener.attach(mockService, "/");
    check httpListener.'start();
}
