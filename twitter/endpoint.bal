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
import ballerina/time;
import ballerina/url;
import ballerina/uuid;

# Ballerina Twitter connector provides the capability to access Twitter API.
# This connector lets you to perform operations related to Tweets and users.
#
# + apiKey - Consumer key of the Twitter account
# + apiSecret - Consumer secret of the Twitter account
# + accessToken - Access token of the Twitter account
# + accessTokenSecret - Access token secret of the Twitter account
# + twitterClient - Connector HTTP endpoint
@display {label: "Twitter", iconPath: "resources/twitter.svg"}
public isolated client class  Client {
    
    private final string apiKey;
    private final string apiSecret;
    private final string accessToken;
    private final string accessTokenSecret;

    private final http:Client twitterClient;

    # Initializes the connector. During initialization you have to pass API credentials.
    # Create a [Twitter Developer Account](https://developer.twitter.com/en/apply-for-access) and obtain credentials following [this guide](https://developer.twitter.com/en/docs/authentication/oauth-1-0a). 
    #
    # + twitterConfig - Configuration for the connector
    # + httpConfig - HTTP configuration
    # + return - `http:Error` in case of failure to initialize or `null` if successfully initialized 
    public isolated function init(ConnectionConfig twitterConfig, http:ClientConfiguration httpConfig = {}) 
                                  returns error? {
        self.twitterClient = check new(TWITTER_API_URL, httpConfig);
        self.apiKey = twitterConfig.apiKey;
        self.apiSecret = twitterConfig.apiSecret;
        self.accessToken = twitterConfig.accessToken;
        self.accessTokenSecret = twitterConfig.accessTokenSecret;
    }

    # Update the user's Tweet.
    #
    # + tweetText - Text of tweet to update
    # + url - Link attachment url
    # + updateTweetOptions - Options for tweet update
    # + return - If success, returns 'Tweet' object, else returns error
    @display {label: "Post Tweet"}
    isolated remote function tweet(@display {label: "Tweet Text"} string tweetText, 
                          @display {label: "URL To Link"} string? url = (),
                          @display {label: "Optional Update Options"} UpdateTweetOptions? updateTweetOptions = ()) 
                          returns @tainted @display {label: "Tweet"} Tweet|error {
        http:Request request = new;

        string mediaIds = "";
        string tweetTextWithUrl = "";
        string encodedStatusValue = "";

        if (updateTweetOptions?.media_ids is string) {
            mediaIds = <string>updateTweetOptions?.media_ids;
        }

        string resourcePath = TWEET_ENDPOINT;
        if (url is string) {
            tweetTextWithUrl = tweetText + "\n" + url;
            encodedStatusValue = check url:encode(tweetTextWithUrl, UTF_8);
        } else {
            encodedStatusValue = check url:encode(tweetText, UTF_8);
        }

        string urlParams = STATUS + encodedStatusValue + AMBERSAND;
        string oauthString = "";

        if (mediaIds != "") {
            string encodedMediaValue = check url:encode(mediaIds, UTF_8);
            urlParams = urlParams + MEDIA_IDS + encodedMediaValue + AMBERSAND;
            oauthString = oauthString + MEDIA_IDS + encodedMediaValue + AMBERSAND;
        }
        string nonce = uuid:createType1AsString();
        [int, decimal] & readonly currentTime = time:utcNow();
        string timeStamp = currentTime[0].toString();
        oauthString = oauthString + getOAuthParameters(self.apiKey, self.accessToken, nonce, timeStamp) + STATUS + encodedStatusValue + AMBERSAND;

        var requestHeaders = createRequestHeaders(request, POST, resourcePath, self.apiKey, self.apiSecret,
            self.accessToken, self.accessTokenSecret, oauthString, nonce, timeStamp);
        if (requestHeaders is error) {
            return requestHeaders;
        } else {
            resourcePath = resourcePath + QUESTION_MARK + urlParams;
            http:Response httpResponse = check self.twitterClient->post(resourcePath, request);
            var response = check handleStatusResponse(httpResponse);
            return response;
        }
    }

    # Reply to a Tweet.
    #
    # + tweetText - Text of tweet to update
    # + replyID - Tweet id to be replyed
    # + url - URL of attachment
    # + return - If success, returns 'Tweet' object, else returns error
    @display {label: "Reply Tweet"} 
    isolated remote function replyTweet(@display {label: "Text To Reply"} string tweetText, 
                               @display {label: "Tweet ID To Reply"} int replyID, 
                               @display {label: "URL To Link"} string? url = ()) 
                               returns @tainted @display {label: "Tweet"} Tweet|error {
        http:Request request = new;

        string tweetTextWithUrl = "";
        string in_reply_to_status_id = replyID.toString();

        string resourcePath = TWEET_ENDPOINT;
        if (url is string) {
            tweetTextWithUrl = tweetText + "\n" + url;
        }
        string encodedStatus = check url:encode(tweetText, UTF_8);
        string urlParams = STATUS + encodedStatus + AMBERSAND;
        string encodedReplyValue = check url:encode(in_reply_to_status_id, UTF_8);
        urlParams = urlParams + REPLY_IDS + encodedReplyValue + AMBERSAND;
        string oauthString = "";

        string nonce = uuid:createType1AsString();
        [int, decimal] & readonly currentTime = time:utcNow();
        string timeStamp = currentTime[0].toString();
        oauthString = oauthString + REPLY_IDS + encodedReplyValue + AMBERSAND;
        oauthString = oauthString + getOAuthParameters(self.apiKey, self.accessToken, nonce, timeStamp) + STATUS + encodedStatus + AMBERSAND;

        var requestHeaders = createRequestHeaders(request, POST, resourcePath, self.apiKey, self.apiSecret,
            self.accessToken, self.accessTokenSecret, oauthString, nonce, timeStamp);
        if (requestHeaders is error) {
            return requestHeaders;
        } else {
            resourcePath = resourcePath + QUESTION_MARK + urlParams;
            http:Response httpResponse = check self.twitterClient->post(resourcePath, request);
            var response = check handleStatusResponse(httpResponse);
            return response;
        }
    }

    # Retweet a Tweet.
    #
    # + id - Numerical ID of a status
    # + return - If success, returns 'Tweet' object, else returns error
    @display {label: "Make Retweet"} 
    isolated remote function retweet(@display {label: "Tweet ID To Retweet"} int id) 
                            returns @tainted @display {label: "Tweet"} Tweet|error {
        http:Request request = new;

        string urlParams = "";
        string oauthString = "";
        string nonce = uuid:createType1AsString();
        [int, decimal] & readonly currentTime = time:utcNow();
        string timeStamp = currentTime[0].toString();
        oauthString = oauthString + getOAuthParameters(self.apiKey, self.accessToken, nonce, timeStamp);

        string resourcePath = RETWEET_ENDPOINT + id.toString() + JSON;
        var requestHeaders = createRequestHeaders(request, POST, resourcePath, self.apiKey, self.apiSecret,
            self.accessToken, self.accessTokenSecret, oauthString, nonce, timeStamp);
        if (requestHeaders is error) {
            error err = error(TWITTER_ERROR,
                              message = "Error occurred while encoding");
            return err;
        } else {
            http:Response httpResponse = check self.twitterClient->post(resourcePath, request);
            var response = check handleStatusResponse(httpResponse);
            return response;
        }
    }

    # Delete a Retweet.
    #
    # + id - Numerical ID of a status
    # + return - If success, returns 'Tweet' object, else returns error
    @display {label: "Delete Retweet"} 
    isolated remote function deleteRetweet(@display {label: "ReTweet ID To Delete"} int id) 
                                  returns @tainted @display {label: "Tweet"} Tweet|error {
        http:Request request = new;
        string nonce = uuid:createType1AsString();
        [int, decimal] & readonly currentTime = time:utcNow();
        string timeStamp = currentTime[0].toString();
        string oauthString = getOAuthParameters(self.apiKey, self.accessToken, nonce, timeStamp);

        string resourcePath = UN_RETWEET_ENDPOINT + id.toString() + JSON;
        var requestHeaders = createRequestHeaders(request, POST, resourcePath, self.apiKey, self.apiSecret,
            self.accessToken, self.accessTokenSecret, oauthString, nonce, timeStamp);
        if (requestHeaders is error) {
            error err = error(TWITTER_ERROR,
                              message = "Error occurred while encoding");
            return err;
        } else {
            http:Response httpResponse = check self.twitterClient->post(resourcePath, request);
            var response = check handleStatusResponse(httpResponse);
            return response;
        }
    }

    # Search for Tweets matching a query.
    #
    # + queryStr - Query string need to be searched
    # + searchOptions - Optional parameter which specify the search options
    # + return - If success, returns 'Tweet' object, else returns error
    @display {label: "Search Tweet By String"} 
    isolated remote function search(@display {label: "Query String To Search"} string queryStr, 
                           @display {label: "Optional Search Options"} SearchOptions? searchOptions = ()) 
                           returns @tainted @display {label: "Array Of Tweet"} Tweet[]|error {
        string resourcePath = SEARCH_ENDPOINT;
        string encodedQueryValue = check url:encode(queryStr, UTF_8);
        string urlParams = "q=" + encodedQueryValue + AMBERSAND;
        int? count = searchOptions?.count;
        string? geocode = searchOptions?.geocode;
        string nonce = uuid:createType1AsString();
        [int, decimal] & readonly currentTime = time:utcNow();
        string timeStamp = currentTime[0].toString();
        string oauthString = getOAuthParameters(self.apiKey, self.accessToken, nonce, timeStamp) + urlParams;
        if (count is int) {
            oauthString = "count=" + count.toString() + AMBERSAND + oauthString;
        }
        if ((geocode is string) && (geocode != "")) {
            oauthString = "count=" + geocode + AMBERSAND + oauthString;
        }

        http:Request request = new;
        var requestHeaders = createRequestHeaderMap(request, GET, resourcePath, self.apiKey, self.apiSecret, self.accessToken,
            self.accessTokenSecret, oauthString, nonce, timeStamp);
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
            http:Response httpResponse = check self.twitterClient->get(resourcePath, headerMap);
            var response = check handleSearchTweetResponse(httpResponse);
            return response;
        }
    }

    # Show a Tweet.
    #
    # + id - Numerical ID of a status  
    # + trimUser - User object including only numerical ID. Omit parameter to receive the complete user object  
    # + includeMyRetweet - Include retweets 
    # + includeEntities - Include entities nodes 
    # + includeExtAltText - Include alt text of media entities  
    # + includeCardUri - Include card uri attributes
    # + return - If success, returns 'Tweet' object, else returns error
    @display {label: "Show Tweet"} 
    isolated remote function showStatus(@display {label: "Tweet ID To Show"} int id, 
                               @display {label: "Trim User Or Not"} boolean? trimUser = (), 
                               @display {label: "Include Retweet Or Not"} boolean? includeMyRetweet = (), 
                               @display {label: "Include Entities Or Not"} boolean? includeEntities = (), 
                               @display {label: "Include Alt Text Of Media"} boolean? includeExtAltText = (), 
                               @display {label: "Include Card Uri"} boolean? includeCardUri = ()) 
                               returns @tainted @display {label: "Tweet"} Tweet|error {
        http:Request request = new;
        string resourcePath = SHOW_STATUS_ENDPOINT;
        string urlParams = ID + id.toString();
        string nonce = uuid:createType1AsString();
        [int, decimal] & readonly currentTime = time:utcNow();
        string timeStamp = currentTime[0].toString();
        string oauthString = urlParams + AMBERSAND + getOAuthParameters(self.apiKey, self.accessToken, nonce, timeStamp);

        var requestHeaders = createRequestHeaderMap(request, GET, resourcePath, self.apiKey, self.apiSecret,
            self.accessToken, self.accessTokenSecret, oauthString, nonce, timeStamp);
        if (requestHeaders is error) {
            error err = error(TWITTER_ERROR,
                              message = "Error occurred while encoding");
            return err;
        } else {
            map<string> headerMap = requestHeaders;
            resourcePath = resourcePath + QUESTION_MARK + urlParams;
            http:Response httpResponse = check self.twitterClient->get(resourcePath, headerMap);
            var response = check handleStatusResponse(httpResponse);
            return response;
        }
    }

    # Delete a Tweet.
    #
    # + id - Numerical ID of a status
    # + return - If success, returns 'Tweet' object, else returns error
    @display {label: "Delete Tweet"} 
    isolated remote function deleteTweet(@display {label: "Tweet ID"} int id) 
                                returns @tainted @display {label: "Tweet"} Tweet|error {
        http:Request request = new;
        string nonce = uuid:createType1AsString();
        [int, decimal] & readonly currentTime = time:utcNow();
        string timeStamp = currentTime[0].toString();
        string oauthString = getOAuthParameters(self.apiKey, self.accessToken, nonce, timeStamp);

        string resourcePath = DESTROY_STATUS_ENDPOINT + id.toString() + JSON;
        var requestHeaders = createRequestHeaders(request, POST, resourcePath, self.apiKey, self.apiSecret,
            self.accessToken, self.accessTokenSecret, oauthString, nonce, timeStamp);
        if (requestHeaders is error) {
            error err = error(TWITTER_ERROR,
                              message = "Error occurred while encoding");
            return err;
        } else {
            http:Response httpResponse = check self.twitterClient->post(resourcePath, request);
            var response = check handleStatusResponse(httpResponse);
            return response;
        }
    }

    # Get a User object.
    #
    # + userId - Numerical ID of a specific user
    # + return - If success, returns 'User' object, else returns error
    @display {label: "Get User's Detail"} 
    isolated remote function getUser(@display {label: "User ID"} int userId) 
                            returns @tainted @display {label: "User"} User|error {
        http:Request request = new;
        string resourcePath = GET_USER_ENDPOINT;
        string encodedValue = check url:encode((userId.toString()), UTF_8);
        string urlParams = USER_ID + encodedValue + AMBERSAND;
        string nonce = uuid:createType1AsString();
        [int, decimal] & readonly currentTime = time:utcNow();
        string timeStamp = currentTime[0].toString();
        string oauthString = getOAuthParameters(self.apiKey, self.accessToken, nonce, timeStamp) + urlParams;

        var requestHeaders = createRequestHeaderMap(request, GET, resourcePath, self.apiKey, self.apiSecret,
            self.accessToken, self.accessTokenSecret, oauthString, nonce, timeStamp);
        if (requestHeaders is error) {
            error err = error(TWITTER_ERROR,
                              message = "Error occurred while encoding");
            return err;
        } else {
            map<string> headerMap = requestHeaders;
            resourcePath = resourcePath + QUESTION_MARK + urlParams;
            http:Response httpResponse = check self.twitterClient->get(resourcePath, headerMap);
            var response = check handleResponse(httpResponse);
            json[] array = <json[]> response;
            json user = array[0];
            User userRsponse = check user.cloneWithType(User);
            return userRsponse;
        }
    }

    # Get a user's followers.
    #
    # + userId - Numerical ID of a specific user
    # + return - If success, returns 'User' object array, else returns error
    @display {label: "Get User's Followers"} 
    isolated remote function getFollowers(@display {label: "User ID"} int userId) 
                                 returns @tainted @display {label: "Array Of User"} User[]|error {
        http:Request request = new;
        string resourcePath = FOLLOWERS_ENDPOINT;
        string encodedValue = check url:encode((userId.toString()), UTF_8);
        string urlParams = USER_ID + encodedValue + AMBERSAND;
        string nonce = uuid:createType1AsString();
        [int, decimal] & readonly currentTime = time:utcNow();
        string timeStamp = currentTime[0].toString();
        string oauthString = getOAuthParameters(self.apiKey, self.accessToken, nonce, timeStamp) + urlParams;

        var requestHeaders = createRequestHeaderMap(request, GET, resourcePath, self.apiKey, self.apiSecret,
            self.accessToken, self.accessTokenSecret, oauthString, nonce, timeStamp);
        if (requestHeaders is error) {
            error err = error(TWITTER_ERROR,
                              message = "Error occurred while encoding");
            return err;
        } else {
            map<string> headerMap = requestHeaders;
            resourcePath = resourcePath + QUESTION_MARK + urlParams;
            http:Response httpResponse = check self.twitterClient->get(resourcePath, headerMap);
            var response = check handleUserArrayResponse(httpResponse);
            return response;
        }
    }

    # Get a user's following.
    #
    # + userId - Numerical ID of a specific user
    # + return - If success, returns 'User' object array, else returns error
    @display {label: "Get User's Following"} 
    isolated remote function getFollowing(@display {label: "User ID"} int userId) 
                                 returns @tainted @display {label: "Array Of User"} User[]|error {
        http:Request request = new;
        string resourcePath = FOLLOWINGS_ENDPOINT;
        string encodedValue = check url:encode((userId.toString()), UTF_8);
        string urlParams = USER_ID + encodedValue + AMBERSAND;
        string nonce = uuid:createType1AsString();
        [int, decimal] & readonly currentTime = time:utcNow();
        string timeStamp = currentTime[0].toString();
        string oauthString = getOAuthParameters(self.apiKey, self.accessToken, nonce, timeStamp) + urlParams;

        var requestHeaders = createRequestHeaderMap(request, GET, resourcePath, self.apiKey, self.apiSecret,
            self.accessToken, self.accessTokenSecret, oauthString, nonce, timeStamp);
        if (requestHeaders is error) {
            error err = error(TWITTER_ERROR,
                              message = "Error occurred while encoding");
            return err;
        } else {
            map<string> headerMap = requestHeaders;
            resourcePath = resourcePath + QUESTION_MARK + urlParams;
            http:Response httpResponse = check self.twitterClient->get(resourcePath, headerMap);
            var response = check handleUserArrayResponse(httpResponse);
            return response;
        }
    }

    # Get a user's tweets in timeline.
    # 
    # + count - Number of tweets returned 
    # + sinceId - Minimum tweet ID 
    # + maxId - Maximum tweet ID 
    # + trimUser - User object including only numerical ID. Omit parameter to receive the complete user object  
    # + excludeReplies - Include retweets 
    # + includeEntities - Include entities nodes
    # + return - If success, returns 'Tweet' object array, else returns error
    @display {label: "Get Current User's Timeline"} 
    isolated remote function getUserTimeline(@display {label: "Count"} int? count = (), 
                                    @display {label: "Minimum Tweet ID"} int? sinceId = (), 
                                    @display {label: "Maximum Tweet ID"} int? maxId = (), 
                                    @display {label: "Trim User Or Not"} boolean? trimUser = (), 
                                    @display {label: "Exclude Replies Or Not"} boolean? excludeReplies = (), 
                                    @display {label: "Include Entities Or Not"} boolean? includeEntities = ()) 
                                    returns @tainted @display {label: "Array Of Tweet"} Tweet[]|error {
        http:Request request = new;

        string resourcePath = USER_TIMELINE_ENDPOINT;
        string oauthString = "";
        string urlParams = "";
        string nonce = uuid:createType1AsString();
        [int, decimal] & readonly currentTime = time:utcNow();
        string timeStamp = currentTime[0].toString();
        oauthString = oauthString + getOAuthParameters(self.apiKey, self.accessToken, nonce, timeStamp);                    
        if (count is int) {
            urlParams = COUNT + count.toString();
            oauthString = urlParams + AMBERSAND + getOAuthParameters(self.apiKey, self.accessToken, nonce, timeStamp);
        }

        var requestHeaders = createRequestHeaderMap(request, GET, resourcePath, self.apiKey, self.apiSecret,
            self.accessToken, self.accessTokenSecret, oauthString, nonce, timeStamp);
        if (requestHeaders is error) {
            error err = error(TWITTER_ERROR,
                              message = "Error occurred while encoding");
            return err;
        } else {
            resourcePath = resourcePath + QUESTION_MARK + urlParams;
            http:Response httpResponse = check self.twitterClient->get(resourcePath, requestHeaders);
            var response = check handleStatusArrayResponse(httpResponse);
            return response;
        }
    }

    # Get a user's last ten tweets.
    # 
    # + sinceId - Minimum tweet ID 
    # + maxId - Maximum tweet ID 
    # + trimUser - User object including only numerical ID. Omit parameter to receive the complete user object  
    # + excludeReplies - Include retweets 
    # + includeEntities - Include entities nodes 
    # + return - If success, returns 'Tweet' object array, else returns error
    @display {label: "Get Last Ten Tweets"} 
    isolated remote function getLast10Tweets(@display {label: "Minimum Tweet ID"} int? sinceId = (), 
                                    @display {label: "Maximum Tweet ID"} int? maxId = (), 
                                    @display {label: "Trim User Or Not"} boolean? trimUser = (), 
                                    @display {label: "Exclude Replies Or Not"} boolean? excludeReplies = (), 
                                    @display {label: "Include Entities Or Not"} boolean? includeEntities = ()) 
                                    returns @tainted @display {label: "Array Of Tweet"} Tweet[]|error {
        http:Request request = new;
        string resourcePath = USER_TIMELINE_ENDPOINT ;
        int count = 10;
        string urlParams = COUNT + count.toString();
        string nonce = uuid:createType1AsString();
        [int, decimal] & readonly currentTime = time:utcNow();
        string timeStamp = currentTime[0].toString();
        string oauthString = urlParams + AMBERSAND + getOAuthParameters(self.apiKey, self.accessToken, nonce, timeStamp);

        var requestHeaders = createRequestHeaderMap(request, GET, resourcePath, self.apiKey, self.apiSecret,
            self.accessToken, self.accessTokenSecret, oauthString, nonce, timeStamp);
        if (requestHeaders is error) {
            error err = error(TWITTER_ERROR,
                              message = "Error occurred while encoding");
            return err;
        } else {
            resourcePath = resourcePath + QUESTION_MARK + urlParams;
            http:Response httpResponse = check self.twitterClient->get(resourcePath, requestHeaders);
            var response = check handleStatusArrayResponse(httpResponse);
            return response;
        }
    }
}

# Twitter configuration
#
# + apiKey - Api Key
# + apiSecret - Api Secret
# + accessToken - Access token
# + accessTokenSecret - Access token secret
@display{label: "Connection Config"} 
public type ConnectionConfig record {
    @display {label: "API Key"}
    string apiKey;
    @display {label: "API Secret"}
    string apiSecret;
    @display {label: "Access Token"}
    string accessToken;
    @display {label: "Access Token Secret"}
    string accessTokenSecret;
};
