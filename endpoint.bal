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
# + clientId - The consumer key of the Twitter account
# + clientSecret - The consumer secret of the Twitter account
# + accessToken - The access token of the Twitter account
# + accessTokenSecret - The access token secret of the Twitter account
# + twitterClient - HTTP Client endpoint
@display {label: "Twitter API Client"}
public client class  Client {
    
    string clientId;
    string clientSecret;
    string accessToken;
    string accessTokenSecret;

    http:Client twitterClient;

    public isolated function init(@display {label: "Connection Configuration"} TwitterConfiguration twitterConfig) returns error? {
        self.twitterClient = check new(TWITTER_API_URL, twitterConfig.clientConfig);
        self.clientId = twitterConfig.clientId;
        self.clientSecret = twitterConfig.clientSecret;
        self.accessToken = twitterConfig.accessToken;
        self.accessTokenSecret = twitterConfig.accessTokenSecret;
    }

    # Update the user's Tweet.
    #
    # + tweetText - The text of tweet to update
    # + updateStatusOptions - Options for tweet update
    # + return - If success, returns Status object, else returns error.
    @display {label: "Post a Tweet"}
    remote function tweet(@display {label: "Tweet text"} string tweetText, @display {label: "Optional Update Options"} UpdateStatusOptions? updateStatusOptions = ()) 
                          returns @tainted @display {label: "Status"} Status|error {
        http:Request request = new;

        string mediaIds = "";
        string attachmentUrl = "";

        if (updateStatusOptions?.media_ids is string) {
            mediaIds = <string>updateStatusOptions?.media_ids;
        }
        if (updateStatusOptions?.attachment_url is string) {
            attachmentUrl = <string>updateStatusOptions?.attachment_url;
        }

        string resourcePath = TWEET_ENDPOINT;
        string encodedStatusValue = check url:encode(tweetText, UTF_8);
        string urlParams = STATUS + encodedStatusValue + "&";
        string oauthString = "";

        if (attachmentUrl != "") {
            string encodedAttachmentValue = check url:encode(attachmentUrl, UTF_8);
            urlParams = urlParams + ATTACHMENT_URL + encodedAttachmentValue + "&";
            oauthString = ATTACHMENT_URL + encodedAttachmentValue + "&";
        }

        if (mediaIds != "") {
            string encodedMediaValue = check url:encode(mediaIds, UTF_8);
            urlParams = urlParams + MEDIA_IDS + encodedMediaValue + "&";
            oauthString = oauthString + MEDIA_IDS + encodedMediaValue + "&";
        }
        oauthString = oauthString + getOAuthParameters(self.clientId, self.accessToken) + STATUS + encodedStatusValue + "&";

        var requestHeaders = createRequestHeaders(request, POST, resourcePath, self.clientId, self.clientSecret,
            self.accessToken, self.accessTokenSecret, oauthString);
        if (requestHeaders is error) {
            error err = error(TWITTER_ERROR,
                              message = "Error occurred while encoding");
            return err;
        } else {
            resourcePath = resourcePath + "?" + urlParams;
            var httpResponse = check self.twitterClient->post(resourcePath, request);
            var response = check handleResponse(httpResponse);
            return convertToStatus(response);
        }
    }

    # Reply to a Tweet.
    #
    # + tweetText - The text of tweet to update
    # + replyID - Tweet id to be replyed
    # + mediaIds - List of medias have to be attached
    # + attachmentUrl - Url of attachment
    # + return - If success, returns Status object, else returns error.
    @display {label: "Reply a Tweet"} 
    remote function replyTweet(@display {label: "Text to a Reply"} string tweetText, @display {label: "Tweet Id to Reply"} int replyID, @display {label: "Media Id"} string? mediaIds = (), @display {label: "Attachment Url"} string? attachmentUrl =()) 
                               returns @tainted @display {label: "Status"} Status|error {
        http:Request request = new;

        string media_Ids = "";
        string attachment_Url = "";
        string in_reply_to_status_id = replyID.toString();

        if (mediaIds is string) {
            media_Ids = mediaIds != "" ? mediaIds : "";
        }
        if (attachmentUrl is string) {
            attachment_Url = attachmentUrl != "" ? attachmentUrl : "";
        }

        string resourcePath = TWEET_ENDPOINT;
        string encodedStatus = check url:encode(tweetText, UTF_8);
        string urlParams = STATUS + encodedStatus + "&";
        string encodedReplyValue = check url:encode(in_reply_to_status_id, UTF_8);
        urlParams = urlParams + REPLY_IDS + encodedReplyValue + "&";
        string oauthString = "";

        if (attachment_Url != "") {
            string encodedAttachmentValue = check url:encode(attachment_Url, UTF_8);
            urlParams = urlParams + ATTACHMENT_URL + encodedAttachmentValue + "&";
            oauthString = ATTACHMENT_URL + encodedAttachmentValue + "&";
        }
        if (media_Ids != "") {
            string encodedMediaValue = check url:encode(media_Ids, UTF_8);
            urlParams = urlParams + MEDIA_IDS + encodedMediaValue + "&";
            oauthString = oauthString + MEDIA_IDS + encodedMediaValue + "&";
        }

        oauthString = oauthString + REPLY_IDS + encodedReplyValue + "&";
        oauthString = oauthString + getOAuthParameters(self.clientId, self.accessToken) + STATUS + encodedStatus + "&";

        var requestHeaders = createRequestHeaders(request, POST, resourcePath, self.clientId, self.clientSecret,
            self.accessToken, self.accessTokenSecret, oauthString);
        if (requestHeaders is error) {
            error err = error(TWITTER_ERROR, message = "Error occurred while encoding");
            return err;
        } else {
            resourcePath = resourcePath + "?" + urlParams;
            var httpResponse = check self.twitterClient->post(resourcePath, request);
            var response = check handleResponse(httpResponse);
            return convertToStatus(response);
        }
    }

    # Retweet a Tweet.
    #
    # + id - The numerical ID of a status
    # + trimUser - User object including only numerical ID. Omit parameter to receive the complete user object
    # + return - If success, returns Status object, else returns error
    @display {label: "Make a Retweet"} 
    remote function retweet(@display {label: "Tweet Id to Retweet"} int id, @display {label: "Trim user or not"} boolean? trimUser = ()) returns @tainted @display {label: "Status"} Status|error {
        http:Request request = new;

        string trim_user = "";
        string urlParams = "";
        string oauthString = "";
        if (trimUser is boolean) {
            trim_user = trimUser.toString();
        }

        if (trim_user != "") {
            string encodedValue = check url:encode(trim_user, UTF_8);
            urlParams = urlParams + "trim_user=" + trim_user + "&";
            oauthString = "trim_user=" + trim_user + "&";
        }

        oauthString = oauthString + getOAuthParameters(self.clientId, self.accessToken);

        string resourcePath = RETWEET_ENDPOINT + id.toString() + JSON;
        var requestHeaders = createRequestHeaders(request, POST, resourcePath, self.clientId, self.clientSecret,
            self.accessToken, self.accessTokenSecret, oauthString);
        if (requestHeaders is error) {
            error err = error(TWITTER_ERROR,
                              message = "Error occurred while encoding");
            return err;
        } else {
            var httpResponse = check self.twitterClient->post(resourcePath, request);
            var response = check handleResponse(httpResponse);
            return convertToStatus(response);
        }
    }

    # Delete a Retweet.
    #
    # + id - The numerical ID of a status
    # + trimUser - User object including only numerical ID. Omit parameter to receive the complete user object
    # + return - If success, returns Status object, else returns error
    @display {label: "Delete a Retweet"} 
    remote function deleteRetweet(@display {label: "ReTweet Id to delete"} int id, @display {label: "Trim user or not"} boolean? trimUser = ()) returns @tainted @display {label: "Status"} Status|error {
        http:Request request = new;
        string oauthString = getOAuthParameters(self.clientId, self.accessToken);

        string resourcePath = UN_RETWEET_ENDPOINT + id.toString() + JSON;
        var requestHeaders = createRequestHeaders(request, POST, resourcePath, self.clientId, self.clientSecret,
            self.accessToken, self.accessTokenSecret, oauthString);
        if (requestHeaders is error) {
            error err = error(TWITTER_ERROR,
                              message = "Error occurred while encoding");
            return err;
        } else {
            var httpResponse = check self.twitterClient->post(resourcePath, request);
            var response = check handleResponse(httpResponse);
            return convertToStatus(response);
        }
    }

    # Search for Tweets matching a query.
    #
    # + queryStr - The query string need to be searched
    # + searchOptions - Optional parameter which specify the search options
    # + return - If success, returns Status object, else returns error
    @display {label: "Search statuses by string"} 
    remote function search(@display {label: "Query string to search"} string queryStr, @display {label: "Optional Search Options"} SearchOptions? searchOptions = ()) returns @tainted @display {label: "Array of Status"} Status[]|error {
        string resourcePath = SEARCH_ENDPOINT;
        string encodedQueryValue = check url:encode(queryStr, UTF_8);
        string urlParams = "q=" + encodedQueryValue + "&";
        int? count = searchOptions?.count;
        string? geocode = searchOptions?.geocode;
        string oauthString = getOAuthParameters(self.clientId, self.accessToken) + urlParams;
        if(count is int){
            oauthString = "count=" + count.toString() + "&" + oauthString;
        }
        if(geocode is string){
            if (geocode != "") {
                oauthString = "count=" + geocode + "&" + oauthString;
            }
        }

        http:Request request = new;
        var requestHeaders = createRequestHeaderMap(request, GET, resourcePath, self.clientId, self.clientSecret, self.accessToken,
            self.accessTokenSecret, oauthString);
        if (requestHeaders is error) {
            error err = error(TWITTER_ERROR,
                              message = "Error occurred while encoding");
            return err;
        } else {
            map<string> headerMap = requestHeaders;
            resourcePath = resourcePath + "?" + urlParams;
            if(count is int){
                    resourcePath =  resourcePath + "count=" + count.toString();
            }
            var httpResponse = check self.twitterClient->get(resourcePath, headerMap);
            var response = check handleResponse(httpResponse);
            Status[] searchResponse = [];
            if (response.statuses is json) {
                return convertToStatuses(<json[]>check response.statuses);
            }
            else {
                return setResponseError(response);
            }
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
    # + return - If success, returns Status object, else returns error
    @display {label: "Show a status"} 
    remote function showStatus(@display {label: "Tweet Id to Show"} int id, @display {label: "Trim user or not"} boolean? trimUser = (), @display {label: "Include retweet or not"} boolean? includeMyRetweet = (), 
                               @display {label: "Include entities or not"} boolean? includeEntities = (), @display {label: "Include alt text of media entities or not"} boolean? includeExtAltText = (), @display {label: "Include card uri attributes or not"} boolean? includeCardUri = ()) 
                               returns @tainted @display {label: "Status"} Status|error {
        http:Request request = new;
        string resourcePath = SHOW_STATUS_ENDPOINT;
        string urlParams = ID + id.toString();
        string oauthString = urlParams + "&" + getOAuthParameters(self.clientId, self.accessToken);

        var requestHeaders = createRequestHeaderMap(request, GET, resourcePath, self.clientId, self.clientSecret,
            self.accessToken, self.accessTokenSecret, oauthString);
        if (requestHeaders is error) {
            error err = error(TWITTER_ERROR,
                              message = "Error occurred while encoding");
            return err;
        } else {
            map<string> headerMap = requestHeaders;
            resourcePath = resourcePath + "?" + urlParams;
            var httpResponse = check self.twitterClient->get(resourcePath, headerMap);
            var response = check handleResponse(httpResponse);
            return convertToStatus(response);
        }
    }

    # Delete a Tweet.
    #
    # + id - The numerical ID of a status
    # + return - If success, returns Status object, else returns error
    @display {label: "Delete a Tweet"} 
    remote function deleteTweet(@display {label: "Tweet Id"} int id) returns @tainted @display {label: "Status"} Status|error {
        http:Request request = new;
        string oauthString = getOAuthParameters(self.clientId, self.accessToken);

        string resourcePath = DESTROY_STATUS_ENDPOINT + id.toString() + JSON;
        var requestHeaders = createRequestHeaders(request, POST, resourcePath, self.clientId, self.clientSecret,
            self.accessToken, self.accessTokenSecret, oauthString);
        if (requestHeaders is error) {
            error err = error(TWITTER_ERROR,
                              message = "Error occurred while encoding");
            return err;
        } else {
            var httpResponse = check self.twitterClient->post(resourcePath, request);
            var response = check handleResponse(httpResponse);
            return convertToStatus(response);
        }
    }

    # Get a User object.
    #
    # + userId - The numerical ID of a specific user
    # + return - If success, returns User object, else returns error
    @display {label: "Get a user's detail"} 
    remote function getUser(@display {label: "User Id"} int userId) returns @tainted @display {label: "User"} User|error {
        http:Request request = new;
        string resourcePath = GET_USER_ENDPOINT;
        string encodedValue = check url:encode((userId.toString()), UTF_8);
        string urlParams = USER_ID + encodedValue + "&";
        string oauthString = getOAuthParameters(self.clientId, self.accessToken) + urlParams;

        var requestHeaders = createRequestHeaderMap(request, GET, resourcePath, self.clientId, self.clientSecret,
            self.accessToken, self.accessTokenSecret, oauthString);
        if (requestHeaders is error) {
            error err = error(TWITTER_ERROR,
                              message = "Error occurred while encoding");
            return err;
        } else {
            map<string> headerMap = requestHeaders;
            resourcePath = resourcePath + "?" + urlParams;
            var httpResponse = check self.twitterClient->get(resourcePath, headerMap);
            var response = check handleResponse(httpResponse);
            json[] array = <json[]> response;
            json user = array[0];
            return convertToUser(user);
        }
    }

    # Get a user's followers.
    #
    # + userId - The numerical ID of a specific user
    # + return - If success, returns User object array, else returns error
    @display {label: "Get a user's followers"} 
    remote function getFollowers(@display {label: "User Id"} int userId) returns @tainted @display {label: "Array of User"} User[]|error {
        http:Request request = new;
        string resourcePath = FOLLOWERS_ENDPOINT;
        string encodedValue = check url:encode((userId.toString()), UTF_8);
        string urlParams = USER_ID + encodedValue + "&";
        string oauthString = getOAuthParameters(self.clientId, self.accessToken) + urlParams;

        var requestHeaders = createRequestHeaderMap(request, GET, resourcePath, self.clientId, self.clientSecret,
            self.accessToken, self.accessTokenSecret, oauthString);
        if (requestHeaders is error) {
            error err = error(TWITTER_ERROR,
                              message = "Error occurred while encoding");
            return err;
        } else {
            map<string> headerMap = requestHeaders;
            resourcePath = resourcePath + "?" + urlParams;
            var httpResponse = check self.twitterClient->get(resourcePath, headerMap);
            var response = check handleResponse(httpResponse);
            User[] users = [];
            if (response.users is json) {
                return convertToUsers(<json[]>check response.users);
            }
            else {
                return setResponseError(response);
            }
        }
    }

    # Get a user's following.
    #
    # + userId - The numerical ID of a specific user
    # + return - If success, returns User object array, else returns error
    @display {label: "Get a user's following"} 
    remote function getFollowing(@display {label: "User Id"} int userId) returns @tainted @display {label: "Array of User"} User[]|error {
        http:Request request = new;
        string resourcePath = FOLLOWINGS_ENDPOINT;
        string encodedValue = check url:encode((userId.toString()), UTF_8);
        string urlParams = USER_ID + encodedValue + "&";
        string oauthString = getOAuthParameters(self.clientId, self.accessToken) + urlParams;

        var requestHeaders = createRequestHeaderMap(request, GET, resourcePath, self.clientId, self.clientSecret,
            self.accessToken, self.accessTokenSecret, oauthString);
        if (requestHeaders is error) {
            error err = error(TWITTER_ERROR,
                              message = "Error occurred while encoding");
            return err;
        } else {
            map<string> headerMap = requestHeaders;
            resourcePath = resourcePath + "?" + urlParams;
            var httpResponse = check self.twitterClient->get(resourcePath, headerMap);
            var response = check handleResponse(httpResponse);
            User[] users = [];
            if (response.users is json) {
                return convertToUsers(<json[]>check response.users);
            }
            else {
                return setResponseError(response);
            }
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
    # + return - If success, returns Status object array, else returns error
    @display {label: "Get current user's timeline"} 
    remote function getUserTimeline(@display {label: "Count"} int? count = (), @display {label: "Minimum Tweet Id"} int? sinceId = (), @display {label: "MaximumTweet Id"} int? maxId = (), 
                                    @display {label: "Trim user or not"} boolean? trimUser = (), @display {label: "Exclude replies or not"} boolean? excludeReplies = (), @display {label: "Include entities or not"} boolean? includeEntities = ()) 
                                    returns @tainted @display {label: "Array of Status"} Status[]|error {
        http:Request request = new;

        string resourcePath = USER_TIMELINE_ENDPOINT;
        string oauthString = "";
        string urlParams = "";
        oauthString = oauthString + getOAuthParameters(self.clientId, self.accessToken);                    
        if (count is int) {
            urlParams = COUNT + count.toString();
            oauthString = urlParams + "&" + getOAuthParameters(self.clientId, self.accessToken);
        }

        var requestHeaders = createRequestHeaderMap(request, GET, resourcePath, self.clientId, self.clientSecret,
            self.accessToken, self.accessTokenSecret, oauthString);
        if (requestHeaders is error) {
            error err = error(TWITTER_ERROR,
                              message = "Error occurred while encoding");
            return err;
        } else {
            resourcePath = resourcePath + "?" + urlParams;
            var httpResponse = check self.twitterClient->get(resourcePath, requestHeaders);
            var response = check handleResponse(httpResponse);
            Status[] statuses = [];
            if (response is json) {
                return convertToStatuses(<json[]> response);
            }
            else {
                return setResponseError(response);
            }
        }
    }

    # Get a user's last ten tweets.
    # 
    # + sinceId - Minimum tweet Id 
    # + maxId - Maximum tweet Id 
    # + trimUser - User object including only numerical ID. Omit parameter to receive the complete user object  
    # + excludeReplies - Include retweets 
    # + includeEntities - Include entities nodes 
    # + return - If success, returns Status object array, else returns error
    @display {label: "Get last ten tweets"} 
    remote function getLast10Tweets(@display {label: "Minimum Tweet Id"} int? sinceId = (), @display {label: "MaximumTweet Id"} int? maxId = (), 
                                    @display {label: "Trim user or not"} boolean? trimUser = (), @display {label: "Exclude replies or not"} boolean? excludeReplies = (), @display {label: "Include entities or not"} boolean? includeEntities = ()) 
                                    returns @tainted @display {label: "Array of Status"} Status[]|error {
        http:Request request = new;
        string resourcePath = USER_TIMELINE_ENDPOINT ;
        int count = 10;
        string urlParams = COUNT + count.toString();
        string oauthString = urlParams + "&" + getOAuthParameters(self.clientId, self.accessToken);

        var requestHeaders = createRequestHeaderMap(request, GET, resourcePath, self.clientId, self.clientSecret,
            self.accessToken, self.accessTokenSecret, oauthString);
        if (requestHeaders is error) {
            error err = error(TWITTER_ERROR,
                              message = "Error occurred while encoding");
            return err;
        } else {
            resourcePath = resourcePath + "?" + urlParams;
            var httpResponse = check self.twitterClient->get(resourcePath, requestHeaders);
            var response = check handleResponse(httpResponse);
            Status[] statuses = [];
            if (response is json) {
                return convertToStatuses(<json[]> response);
            }
            else {
                return setResponseError(response);
            }
        }
    }
}

# Twitter configuration
#
# + clientId - Api Key
# + clientSecret - Api Secret
# + accessToken - Access token
# + accessTokenSecret - Access token secret
# + clientConfig - Client configuration  
public type TwitterConfiguration record {
    string clientId;
    string clientSecret;
    string accessToken;
    string accessTokenSecret;
    http:ClientConfiguration clientConfig = {};
};
