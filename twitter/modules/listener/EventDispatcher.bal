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

class EventDispatcher {
    private SupportedRemoteFunctionImpl supportedRemoteFunctionImpl = {};

    private SimpleHttpService httpService;

    isolated function init(SimpleHttpService httpService) {
        self.httpService = httpService;

        string[] methodNames = getServiceMethodNames(httpService);

        foreach var methodName in methodNames {
            match methodName {
                "onTweet" => {
                    self.supportedRemoteFunctionImpl.isOnTweet = true;
                }
                "onReply" => {
                    self.supportedRemoteFunctionImpl.isOnReply = true;
                }
                "onReTweet" => {
                    self.supportedRemoteFunctionImpl.isOnReTweet = true;
                }
                "onQuoteTweet" => {
                    self.supportedRemoteFunctionImpl.isOnQuoteTweet = true;
                }
                "onFollower" => {
                    self.supportedRemoteFunctionImpl.isOnFollower = true;
                }
                "onFavourite" => {
                    self.supportedRemoteFunctionImpl.isOnFavourite = true;
                }
                "onDelete" => {
                    self.supportedRemoteFunctionImpl.isOnDelete = true;
                }
                "onMention" => {
                    self.supportedRemoteFunctionImpl.isOnMention = true;
                }
                _ => {
                    log:printError("Unrecognized method [" + methodName + "] found in the implementation");
                }
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
                if (self.supportedRemoteFunctionImpl.isOnMention) {
                    check callOnMention(self.httpService, eventPayload);
                }
            } else if (retweetedStatus is string) {
                if (self.supportedRemoteFunctionImpl.isOnReTweet) {
                    check callOnReTweet(self.httpService, eventPayload);
                }
            } else if (replyToId is int) {
                if (self.supportedRemoteFunctionImpl.isOnReply) {
                    check callOnReply(self.httpService, eventPayload);
                }
            } else if (quoteStatusId is int) {
                if (self.supportedRemoteFunctionImpl.isOnQuoteTweet) {
                    check callOnQuoteTweet(self.httpService, eventPayload);
                }
            } else {
                if (self.supportedRemoteFunctionImpl.isOnTweet) {
                    check callOnTweet(self.httpService, eventPayload);
                }
            }
        } else if (eventMap.hasKey("follow_events")) {
            FollowEvent eventPayload = check event.cloneWithType(FollowEvent);
            if (self.supportedRemoteFunctionImpl.isOnFollower) {
                check callOnFollower(self.httpService, eventPayload);
            }
        } else if (eventMap.hasKey("favorite_events")) {
            FavouriteEvent eventPayload = check event.cloneWithType(FavouriteEvent);
            if (self.supportedRemoteFunctionImpl.isOnFavourite) {
                check callOnFavourite(self.httpService, eventPayload);
            }
        } else if (eventMap.hasKey("tweet_delete_events")) {
            DeleteTweetEvent eventPayload = check event.cloneWithType(DeleteTweetEvent);
            if (self.supportedRemoteFunctionImpl.isOnDelete) {
                check callOnDelete(self.httpService, eventPayload);
            }
        } else {
            return error("Invalid payload or an eventtype listener currently does not support");
        }
    }
}
