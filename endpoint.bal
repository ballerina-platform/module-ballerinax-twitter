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

import ballerina/http;
import ballerina/url;

# Twitter Client object.
#
# + apiId - The consumer key of the Twitter account
# + apiSecret - The consumer secret of the Twitter account
# + accessToken - The access token of the Twitter account
# + accessTokenSecret - The access token secret of the Twitter account
# + twitterClient - HTTP Client endpoint
@display {label: "Twitter"}
public client class  Client {
    
    string apiId;
    string apiSecret;
    string accessToken;
    string accessTokenSecret;

    http:Client twitterClient;

    public isolated function init(@display {label: "Connection Configuration"} TwitterConfiguration twitterConfig) 
                                  returns error? {
        self.twitterClient = check new(TWITTER_API_URL, twitterConfig.clientConfig);
        self.apiId = twitterConfig.apiId;
        self.apiSecret = twitterConfig.apiSecret;
        self.accessToken = twitterConfig.accessToken;
        self.accessTokenSecret = twitterConfig.accessTokenSecret;
    }

    # Update the user's Tweet.
    #
    # + tweetText - The text of tweet to update
    # + url - Link attachment url
    # + updateTweetOptions - Options for tweet update
    # + return - If success, returns Tweet object, else returns error.
    @display {label: "Post Tweet"}
    remote function tweet(@display {label: "Tweet Text"} string tweetText, 
                          @display {label: "Url To Link"} string? url = (),
                          @display {label: "Optional Update Options"} UpdateTweetOptions? updateTweetOptions = ()) 
                          returns @tainted @display {label: "Tweet"} Tweet|error {
        http:Request request = new;

        string mediaIds = "";
        string tweetTextWithUrl = "";

        if (updateTweetOptions?.media_ids is string) {
            mediaIds = <string>updateTweetOptions?.media_ids;
        }

        string resourcePath = TWEET_ENDPOINT;
        if (url is string) {
            tweetTextWithUrl = tweetText + "\n" + url;
        }
        string encodedStatusValue = check url:encode(tweetTextWithUrl, UTF_8);
        string urlParams = STATUS + encodedStatusValue + AMBERSAND;
        string oauthString = "";

        if (mediaIds != "") {
            string encodedMediaValue = check url:encode(mediaIds, UTF_8);
            urlParams = urlParams + MEDIA_IDS + encodedMediaValue + AMBERSAND;
            oauthString = oauthString + MEDIA_IDS + encodedMediaValue + AMBERSAND;
        }
        oauthString = oauthString + getOAuthParameters(self.apiId, self.accessToken) + STATUS + encodedStatusValue + AMBERSAND;

        var requestHeaders = createRequestHeaders(request, POST, resourcePath, self.apiId, self.apiSecret,
            self.accessToken, self.accessTokenSecret, oauthString);
        if (requestHeaders is error) {
            return requestHeaders;
        } else {
            resourcePath = resourcePath + QUESTION_MARK + urlParams;
            http:Response httpResponse = <http:Response> check self.twitterClient->post(resourcePath, request);
            var response = check handleStatusResponse(httpResponse);
            return response;
        }
    }

    # Reply to a Tweet.
    #
    # + tweetText - The text of tweet to update
    # + replyID - Tweet id to be replyed
    # + url - Url of attachment
    # + mediaIds - List of medias have to be attached
    # + return - If success, returns Tweet object, else returns error.
    @display {label: "Reply Tweet"} 
    remote function replyTweet(@display {label: "Text To Reply"} string tweetText, 
                               @display {label: "Tweet Id To Reply"} int replyID, 
                               @display {label: "Url To Link"} string? url = (),
                               @display {label: "Media Id"} string? mediaIds = ()) 
                               returns @tainted @display {label: "Tweet"} Tweet|error {
        http:Request request = new;

        string media_Ids = "";
        string tweetTextWithUrl = "";
        string in_reply_to_status_id = replyID.toString();
        

        if (mediaIds is string) {
            media_Ids = mediaIds != "" ? mediaIds : "";
        }

        string resourcePath = TWEET_ENDPOINT;
        if (url is string) {
            tweetTextWithUrl = tweetText + "\n" + url;
        }
        string encodedStatus = check url:encode(tweetText, UTF_8);
        string urlParams = STATUS + encodedStatus + AMBERSAND;
        string encodedReplyValue = check url:encode(in_reply_to_status_id, UTF_8);
        urlParams = urlParams + REPLY_IDS + encodedReplyValue + AMBERSAND;
        string oauthString = "";

        if (media_Ids != "") {
            string encodedMediaValue = check url:encode(media_Ids, UTF_8);
            urlParams = urlParams + MEDIA_IDS + encodedMediaValue + AMBERSAND;
            oauthString = oauthString + MEDIA_IDS + encodedMediaValue + AMBERSAND;
        }

        oauthString = oauthString + REPLY_IDS + encodedReplyValue + AMBERSAND;
        oauthString = oauthString + getOAuthParameters(self.apiId, self.accessToken) + STATUS + encodedStatus + AMBERSAND;

        var requestHeaders = createRequestHeaders(request, POST, resourcePath, self.apiId, self.apiSecret,
            self.accessToken, self.accessTokenSecret, oauthString);
        if (requestHeaders is error) {
            return requestHeaders;
        } else {
            resourcePath = resourcePath + QUESTION_MARK + urlParams;
            http:Response httpResponse = <http:Response> check self.twitterClient->post(resourcePath, request);
            var response = check handleStatusResponse(httpResponse);
            return response;
        }
    }

    # Retweet a Tweet.
    #
    # + id - The numerical ID of a status
    # + trimUser - User object including only numerical ID. Omit parameter to receive the complete user object
    # + return - If success, returns Tweet object, else returns error
    @display {label: "Make Retweet"} 
    remote function retweet(@display {label: "Tweet Id To Retweet"} int id, 
                            @display {label: "Trim User Or Not"} boolean? trimUser = ()) 
                            returns @tainted @display {label: "Tweet"} Tweet|error {
        http:Request request = new;

        string trim_user = "";
        string urlParams = "";
        string oauthString = "";
        if (trimUser is boolean) {
            trim_user = trimUser.toString();
        }

        if (trim_user != "") {
            string encodedValue = check url:encode(trim_user, UTF_8);
            urlParams = urlParams + "trim_user=" + trim_user + AMBERSAND;
            oauthString = "trim_user=" + trim_user + AMBERSAND;
        }

        oauthString = oauthString + getOAuthParameters(self.apiId, self.accessToken);

        string resourcePath = RETWEET_ENDPOINT + id.toString() + JSON;
        var requestHeaders = createRequestHeaders(request, POST, resourcePath, self.apiId, self.apiSecret,
            self.accessToken, self.accessTokenSecret, oauthString);
        if (requestHeaders is error) {
            error err = error(TWITTER_ERROR,
                              message = "Error occurred while encoding");
            return err;
        } else {
            http:Response httpResponse = <http:Response> check self.twitterClient->post(resourcePath, request);
            var response = check handleStatusResponse(httpResponse);
            return response;
        }
    }

    # Delete a Retweet.
    #
    # + id - The numerical ID of a status
    # + trimUser - User object including only numerical ID. Omit parameter to receive the complete user object
    # + return - If success, returns Tweet object, else returns error
    @display {label: "Delete Retweet"} 
    remote function deleteRetweet(@display {label: "ReTweet Id To Delete"} int id, 
                                  @display {label: "Trim User Or Not"} boolean? trimUser = ()) 
                                  returns @tainted @display {label: "Tweet"} Tweet|error {
        http:Request request = new;
        string oauthString = getOAuthParameters(self.apiId, self.accessToken);

        string resourcePath = UN_RETWEET_ENDPOINT + id.toString() + JSON;
        var requestHeaders = createRequestHeaders(request, POST, resourcePath, self.apiId, self.apiSecret,
            self.accessToken, self.accessTokenSecret, oauthString);
        if (requestHeaders is error) {
            error err = error(TWITTER_ERROR,
                              message = "Error occurred while encoding");
            return err;
        } else {
            http:Response httpResponse = <http:Response> check self.twitterClient->post(resourcePath, request);
            var response = check handleStatusResponse(httpResponse);
            return response;
        }
    }

    # Search for Tweets matching a query.
    #
    # + queryStr - The query string need to be searched
    # + searchOptions - Optional parameter which specify the search options
    # + return - If success, returns Tweet object, else returns error
    @display {label: "Search Tweet By String"} 
    remote function search(@display {label: "Query String To Search"} string queryStr, 
                           @display {label: "Optional Search Options"} SearchOptions? searchOptions = ()) 
                           returns @tainted @display {label: "Array of Tweet"} Tweet[]|error {
        string resourcePath = SEARCH_ENDPOINT;
        string encodedQueryValue = check url:encode(queryStr, UTF_8);
        string urlParams = "q=" + encodedQueryValue + AMBERSAND;
        int? count = searchOptions?.count;
        string? geocode = searchOptions?.geocode;
        string oauthString = getOAuthParameters(self.apiId, self.accessToken) + urlParams;
        if (count is int) {
            oauthString = "count=" + count.toString() + AMBERSAND + oauthString;
        }
        if ((geocode is string) && (geocode != "")) {
            oauthString = "count=" + geocode + AMBERSAND + oauthString;
        }

        http:Request request = new;
        var requestHeaders = createRequestHeaderMap(request, GET, resourcePath, self.apiId, self.apiSecret, self.accessToken,
            self.accessTokenSecret, oauthString);
        if (requestHeaders is error) {
            error err = error(TWITTER_ERROR,
                              message = "Error occurred while encoding");
            return err;
        } else {
            map<string> headerMap = requestHeaders;
            resourcePath = resourcePath + QUESTION_MARK + urlParams;
            if(count is int){
                    resourcePath =  resourcePath + "count=" + count.toString();
            }
            http:Response httpResponse = <http:Response> check self.twitterClient->get(resourcePath, headerMap);
            var response = check handleSearchTweetResponse(httpResponse);
            return response;
        }
    }

    # Show a Tweet.
    #
    # + id - The numerical ID of a status  
    # + trimUser - User object including only numerical ID. Omit parameter to receive the complete user object  
    # + includeMyRetweet - Include retweets 
    # + includeEntities - Include entities nodes 
    # + includeExtAltText - Include alt text of media entities  
    # + includeCardUri - Include card uri attributes
    # + return - If success, returns Tweet object, else returns error
    @display {label: "Show Tweet"} 
    remote function showStatus(@display {label: "Tweet Id To Show"} int id, 
                               @display {label: "Trim User Or Not"} boolean? trimUser = (), 
                               @display {label: "Include Retweet Or Not"} boolean? includeMyRetweet = (), 
                               @display {label: "Include Entities Or Not"} boolean? includeEntities = (), 
                               @display {label: "Include Alt Text Of Media"} boolean? includeExtAltText = (), 
                               @display {label: "Include Card Uri"} boolean? includeCardUri = ()) 
                               returns @tainted @display {label: "Tweet"} Tweet|error {
        http:Request request = new;
        string resourcePath = SHOW_STATUS_ENDPOINT;
        string urlParams = ID + id.toString();
        string oauthString = urlParams + AMBERSAND + getOAuthParameters(self.apiId, self.accessToken);

        var requestHeaders = createRequestHeaderMap(request, GET, resourcePath, self.apiId, self.apiSecret,
            self.accessToken, self.accessTokenSecret, oauthString);
        if (requestHeaders is error) {
            error err = error(TWITTER_ERROR,
                              message = "Error occurred while encoding");
            return err;
        } else {
            map<string> headerMap = requestHeaders;
            resourcePath = resourcePath + QUESTION_MARK + urlParams;
            http:Response httpResponse = <http:Response> check self.twitterClient->get(resourcePath, headerMap);
            var response = check handleStatusResponse(httpResponse);
            return response;
        }
    }

    # Delete a Tweet.
    #
    # + id - The numerical ID of a status
    # + return - If success, returns Tweet object, else returns error
    @display {label: "Delete Tweet"} 
    remote function deleteTweet(@display {label: "Tweet Id"} int id) 
                                returns @tainted @display {label: "Tweet"} Tweet|error {
        http:Request request = new;
        string oauthString = getOAuthParameters(self.apiId, self.accessToken);

        string resourcePath = DESTROY_STATUS_ENDPOINT + id.toString() + JSON;
        var requestHeaders = createRequestHeaders(request, POST, resourcePath, self.apiId, self.apiSecret,
            self.accessToken, self.accessTokenSecret, oauthString);
        if (requestHeaders is error) {
            error err = error(TWITTER_ERROR,
                              message = "Error occurred while encoding");
            return err;
        } else {
            http:Response httpResponse = <http:Response> check self.twitterClient->post(resourcePath, request);
            var response = check handleStatusResponse(httpResponse);
            return response;
        }
    }

    # Get a User object.
    #
    # + userId - The numerical ID of a specific user
    # + return - If success, returns User object, else returns error
    @display {label: "Get User's Detail"} 
    remote function getUser(@display {label: "User Id"} int userId) 
                            returns @tainted @display {label: "User"} User|error {
        http:Request request = new;
        string resourcePath = GET_USER_ENDPOINT;
        string encodedValue = check url:encode((userId.toString()), UTF_8);
        string urlParams = USER_ID + encodedValue + AMBERSAND;
        string oauthString = getOAuthParameters(self.apiId, self.accessToken) + urlParams;

        var requestHeaders = createRequestHeaderMap(request, GET, resourcePath, self.apiId, self.apiSecret,
            self.accessToken, self.accessTokenSecret, oauthString);
        if (requestHeaders is error) {
            error err = error(TWITTER_ERROR,
                              message = "Error occurred while encoding");
            return err;
        } else {
            map<string> headerMap = requestHeaders;
            resourcePath = resourcePath + QUESTION_MARK + urlParams;
            http:Response httpResponse = <http:Response> check self.twitterClient->get(resourcePath, headerMap);
            var response = check handleResponse(httpResponse);
            json[] array = <json[]> response;
            json user = array[0];
            User userRsponse = check user.cloneWithType(User);
            return userRsponse;
        }
    }

    # Get a user's followers.
    #
    # + userId - The numerical ID of a specific user
    # + return - If success, returns User object array, else returns error
    @display {label: "Get User's Followers"} 
    remote function getFollowers(@display {label: "User Id"} int userId) 
                                 returns @tainted @display {label: "Array Of User"} User[]|error {
        http:Request request = new;
        string resourcePath = FOLLOWERS_ENDPOINT;
        string encodedValue = check url:encode((userId.toString()), UTF_8);
        string urlParams = USER_ID + encodedValue + AMBERSAND;
        string oauthString = getOAuthParameters(self.apiId, self.accessToken) + urlParams;

        var requestHeaders = createRequestHeaderMap(request, GET, resourcePath, self.apiId, self.apiSecret,
            self.accessToken, self.accessTokenSecret, oauthString);
        if (requestHeaders is error) {
            error err = error(TWITTER_ERROR,
                              message = "Error occurred while encoding");
            return err;
        } else {
            map<string> headerMap = requestHeaders;
            resourcePath = resourcePath + QUESTION_MARK + urlParams;
            http:Response httpResponse = <http:Response> check self.twitterClient->get(resourcePath, headerMap);
            var response = check handleUserArrayResponse(httpResponse);
            return response;
        }
    }

    # Get a user's following.
    #
    # + userId - The numerical ID of a specific user
    # + return - If success, returns User object array, else returns error
    @display {label: "Get User's Following"} 
    remote function getFollowing(@display {label: "User Id"} int userId) 
                                 returns @tainted @display {label: "Array of User"} User[]|error {
        http:Request request = new;
        string resourcePath = FOLLOWINGS_ENDPOINT;
        string encodedValue = check url:encode((userId.toString()), UTF_8);
        string urlParams = USER_ID + encodedValue + AMBERSAND;
        string oauthString = getOAuthParameters(self.apiId, self.accessToken) + urlParams;

        var requestHeaders = createRequestHeaderMap(request, GET, resourcePath, self.apiId, self.apiSecret,
            self.accessToken, self.accessTokenSecret, oauthString);
        if (requestHeaders is error) {
            error err = error(TWITTER_ERROR,
                              message = "Error occurred while encoding");
            return err;
        } else {
            map<string> headerMap = requestHeaders;
            resourcePath = resourcePath + QUESTION_MARK + urlParams;
            http:Response httpResponse = <http:Response> check self.twitterClient->get(resourcePath, headerMap);
            var response = check handleUserArrayResponse(httpResponse);
            return response;
        }
    }

    # Get a user's tweets in timeline.
    # 
    # + count - Number of tweets returned 
    # + sinceId - Minimum tweet Id 
    # + maxId - Maximum tweet Id 
    # + trimUser - User object including only numerical ID. Omit parameter to receive the complete user object  
    # + excludeReplies - Include retweets 
    # + includeEntities - Include entities nodes
    # + return - If success, returns Tweet object array, else returns error
    @display {label: "Get Current User's Timeline"} 
    remote function getUserTimeline(@display {label: "Count"} int? count = (), 
                                    @display {label: "Minimum Tweet Id"} int? sinceId = (), 
                                    @display {label: "Maximum Tweet Id"} int? maxId = (), 
                                    @display {label: "Trim User Or Not"} boolean? trimUser = (), 
                                    @display {label: "Exclude Replies Or Not"} boolean? excludeReplies = (), 
                                    @display {label: "Include Entities Or Not"} boolean? includeEntities = ()) 
                                    returns @tainted @display {label: "Array of Tweet"} Tweet[]|error {
        http:Request request = new;

        string resourcePath = USER_TIMELINE_ENDPOINT;
        string oauthString = "";
        string urlParams = "";
        oauthString = oauthString + getOAuthParameters(self.apiId, self.accessToken);                    
        if (count is int) {
            urlParams = COUNT + count.toString();
            oauthString = urlParams + AMBERSAND + getOAuthParameters(self.apiId, self.accessToken);
        }

        var requestHeaders = createRequestHeaderMap(request, GET, resourcePath, self.apiId, self.apiSecret,
            self.accessToken, self.accessTokenSecret, oauthString);
        if (requestHeaders is error) {
            error err = error(TWITTER_ERROR,
                              message = "Error occurred while encoding");
            return err;
        } else {
            resourcePath = resourcePath + QUESTION_MARK + urlParams;
            http:Response httpResponse = <http:Response> check self.twitterClient->get(resourcePath, requestHeaders);
            var response = check handleStatusArrayResponse(httpResponse);
            return response;
        }
    }

    # Get a user's last ten tweets.
    # 
    # + sinceId - Minimum tweet Id 
    # + maxId - Maximum tweet Id 
    # + trimUser - User object including only numerical ID. Omit parameter to receive the complete user object  
    # + excludeReplies - Include retweets 
    # + includeEntities - Include entities nodes 
    # + return - If success, returns Tweet object array, else returns error
    @display {label: "Get Last Ten Tweets"} 
    remote function getLast10Tweets(@display {label: "Minimum Tweet Id"} int? sinceId = (), 
                                    @display {label: "Maximum Tweet Id"} int? maxId = (), 
                                    @display {label: "Trim User Or Not"} boolean? trimUser = (), 
                                    @display {label: "Exclude Replies Or Not"} boolean? excludeReplies = (), 
                                    @display {label: "Include Entities Or Not"} boolean? includeEntities = ()) 
                                    returns @tainted @display {label: "Array Of Tweet"} Tweet[]|error {
        http:Request request = new;
        string resourcePath = USER_TIMELINE_ENDPOINT ;
        int count = 10;
        string urlParams = COUNT + count.toString();
        string oauthString = urlParams + AMBERSAND + getOAuthParameters(self.apiId, self.accessToken);

        var requestHeaders = createRequestHeaderMap(request, GET, resourcePath, self.apiId, self.apiSecret,
            self.accessToken, self.accessTokenSecret, oauthString);
        if (requestHeaders is error) {
            error err = error(TWITTER_ERROR,
                              message = "Error occurred while encoding");
            return err;
        } else {
            resourcePath = resourcePath + QUESTION_MARK + urlParams;
            http:Response httpResponse = <http:Response> check self.twitterClient->get(resourcePath, requestHeaders);
            var response = check handleStatusArrayResponse(httpResponse);
            return response;
        }
    }
}

# Twitter configuration
#
# + apiId - Api Key
# + apiSecret - Api Secret
# + accessToken - Access token
# + accessTokenSecret - Access token secret
# + clientConfig - Client configuration  
public type TwitterConfiguration record {
    string apiId;
    string apiSecret;
    string accessToken;
    string accessTokenSecret;
    http:ClientConfiguration clientConfig = {};
};
