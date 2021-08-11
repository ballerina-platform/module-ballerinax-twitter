// Copyright (c) 2021, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
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

isolated class EventDispatcher {
    private final boolean isOnTweet;
    private final boolean isOnReply;
    private final boolean isOnReTweet;
    private final boolean isOnQuoteTweet;
    private final boolean isOnFollower;
    private final boolean isOnFavourite;
    private final boolean isOnDelete;
    private final boolean isOnMention;
    private final HttpToTwitterAdaptor adaptor;
    
    isolated function init(HttpToTwitterAdaptor adaptor) {
        self.adaptor = adaptor;
        
        string[] methodNames = adaptor.getServiceMethodNames();
        self.isOnTweet = isMethodAvailable("onTweet", methodNames);
        self.isOnReply = isMethodAvailable("onReply", methodNames);
        self.isOnReTweet = isMethodAvailable("onReTweet", methodNames);
        self.isOnQuoteTweet = isMethodAvailable("onQuoteTweet", methodNames);
        self.isOnFollower = isMethodAvailable("onFollower", methodNames);
        self.isOnFavourite = isMethodAvailable("onFavourite", methodNames);
        self.isOnDelete = isMethodAvailable("onDelete", methodNames);
        self.isOnMention = isMethodAvailable("onMention", methodNames);
                        
        if (methodNames.length() > 0) {
            foreach string methodName in methodNames {
                log:printError("Unrecognized method [" + methodName + "] found in user implementation.");
            }
        }
    }

    isolated function dispatch(json event) returns error? {
        map<json> eventMap = <map<json>> event;
        if(eventMap.hasKey("tweet_create_events")) {
            TweetEvent eventPayload = check event.cloneWithType(TweetEvent);
            string? retweetedStatus = (eventPayload.tweet_create_events[0])?.retweeted_status?.created_at;
            int? replyToId = (eventPayload.tweet_create_events[0])?.in_reply_to_status_id;
            int? quoteStatusId = (eventPayload.tweet_create_events[0])?.quoted_status_id;
            if (eventMap.hasKey("user_has_blocked")) {
                if (self.isOnMention) {
                    check self.adaptor.callOnMention(eventPayload);
                }
            } else if (retweetedStatus is string) {
                if (self.isOnReTweet) {
                    check self.adaptor.callOnReTweet(eventPayload);
                }
            } else if (replyToId is int) {
                if (self.isOnReply) {
                    check self.adaptor.callOnReply(eventPayload);
                }
            } else if (quoteStatusId is int) {
                if (self.isOnQuoteTweet) {
                    check self.adaptor.callOnQuoteTweet(eventPayload);
                }
            } else {
                if (self.isOnTweet) {
                    check self.adaptor.callOnTweet(eventPayload);
                }
            }
        } else if (eventMap.hasKey("follow_events")) {
            FollowEvent eventPayload = check event.cloneWithType(FollowEvent);
            if (self.isOnFollower) {
                check self.adaptor.callOnFollower(eventPayload);
            }
        } else if (eventMap.hasKey("favorite_events")) {
            FavouriteEvent eventPayload = check event.cloneWithType(FavouriteEvent);
            if (self.isOnFavourite) {
                check self.adaptor.callOnFavourite(eventPayload);
            }
        } else if (eventMap.hasKey("tweet_delete_events")) {
            DeleteTweetEvent eventPayload = check event.cloneWithType(DeleteTweetEvent);
            if (self.isOnDelete) {
                check self.adaptor.callOnDelete(eventPayload);
            }
        } else {
            return error("Invalid payload or an eventtype listener currently does not support");
        }
    }
}
