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

// Twitter API endpoint
const string TWITTER_API_URL = "https://api.twitter.com";
const string TWEET_ENDPOINT = "/1.1/statuses/update.json";
const string RETWEET_ENDPOINT = "/1.1/statuses/retweet/";
const string UN_RETWEET_ENDPOINT = "/1.1/statuses/unretweet/";
const string SEARCH_ENDPOINT = "/1.1/search/tweets.json";
const string SHOW_STATUS_ENDPOINT = "/1.1/statuses/show.json";
const string DESTROY_STATUS_ENDPOINT = "/1.1/statuses/destroy/";
const string TRENDS_ENDPOINT = "/1.1/trends/closest.json";
const string TRENDS_PLACE_ENDPOINT = "/1.1/trends/place.json";
const string FOLLOWERS_ENDPOINT = "/1.1/followers/list.json";
const string FOLLOWINGS_ENDPOINT = "/1.1/friends/list.json";
const string GET_USER_ENDPOINT = "/1.1/users/lookup.json";
const string LIKE_TWEET_ENDPOINT = "/1.1/favorites/create.json";
const string USER_TIMELINE_ENDPOINT = "/1.1/statuses/home_timeline.json";

const string UTF_8 = "UTF-8";
const string STATUS = "status=";
const string ATTACHMENT_URL = "attachment_url=";
const string MEDIA_IDS = "media_ids=";
const string REPLY_IDS = "in_reply_to_status_id=";
const string ID = "id=";
const string USER_ID = "user_id=";
const string USERNAME = "screen_name=";
const string LAT = "&lat=";
const string LONG = "&long=";
const string COUNT = "count=";
const string POST = "POST";
const string GET = "GET";
const string JSON = ".json";

const string AMBERSAND = "&";
const string QUESTION_MARK = "?";

// Error Codes
const string TWITTER_ERROR = "Twitter Error";
