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

import ballerinax/'client.config;

# Client configuration details.
@display {label: "Connection Config"}
public type ConnectionConfig record {|
    *config:ConnectionConfig;
    never auth?;
    # API Key for Twitter
    string apiKey;
    # API Secret for Twitter
    @display {
        label: "",
        kind: "password"
    }
    string apiSecret;
    # Access token  for Twitter
    @display {
        label: "",
        kind: "password"
    }
    string accessToken;
    # Access token secret for Twitter
    @display {
        label: "",
        kind: "password"
    }
    string accessTokenSecret;
|};

# Define a Tweet.
# 
# + created_at - Created time of the status
# + id - Id of the status
# + id_str -
# + text - Text message of the status
# + source - Source app of the status
# + truncated - Whether the status is truncated or not
# + entities - Entity of status
# + in_reply_to_status_id - ID of an existing status that update is in reply to
# + in_reply_to_status_id_str - ID of an existing status that update is in reply to in string
# + in_reply_to_user_id - ID of an existing user update is in reply to
# + in_reply_to_user_id_str - ID of an existing user update is in reply to in string
# + in_reply_to_screen_name - Screen name of an existing user update is in reply to in string
# + user - Detail of user post
# + coordinates - Coordinates of location where posted
# + geo - Geo location details (longitude and latitude)
# + place - Location name where posted
# + contributors - Contributors to a tweet
# + is_quote_status - Indicate the quote status
# + favorited - Whether the status is favorited or not
# + retweeted - Whether the status is retweeted or not
# + favorite_count - Count of the favourites
# + retweet_count - Count of the retweeted status
# + possibly_sensitive - Sensitivie or not
# + lang - Language of tweet
public type Tweet record {
    string created_at;
    int id;
    string id_str?;
    string text;
    boolean truncated?;
    json entities?;
    json 'source?;
    int? in_reply_to_status_id?;
    string? in_reply_to_status_id_str?;
    int? in_reply_to_user_id?;
    string? in_reply_to_user_id_str?;
    string? in_reply_to_screen_name?;
    User user;
    GeoLocation? geo?;
    json coordinates?;
    json place?;
    json contributors?;
    boolean is_quote_status?;
    int retweet_count?;
    int favorite_count?;
    boolean favorited?;
    boolean retweeted?;
    boolean possibly_sensitive?;
    string lang?;
};

# Define the geo location details.
# 
# + latitude - Latitude of the location
# + longitude - Longitude of the location
public type GeoLocation record {
    float latitude?;
    float longitude?;
};

# Define the location details.
# 
# + woeid - Where On Earth IDentifier
# + countryName - Country name
# + countryCode - Country code
# + name - Name of the location
# + placeType - Longitude of the location
# + url - Location URL
public type Location record {
    int woeid?;
    string countryName?;
    string countryCode?;
    string name?;
    PlaceType placeType?;
    string url?;
};

# Define the place type.
# 
# + name - Name of the place
# + code - Location code of the place
public type PlaceType record {
    string name?;
    int code?;
};

# Define Entity.
# 
# + hashtags - Hashtags mentioned in the tweet
# + symbols - Symbols exists
# + user_mentions - Users mentioned in the tweet
# + urls - Urls retated to that tweet
public type Entity record {
    json hashtags?;
    json symbols?;
    json user_mentions?;
    json urls?;
};

# Define User.
# 
# + id - Id of user
# + id_str - Id of user in string
# + name - Display name of user 
# + screen_name - Screen name of user
# + location - Location of user
# + description - Description about the user
# + url - Urls associated with user 
# + followers_count - Count of the followers
# + friends_count - Count of the friends(User's following)
public type User record {
    int id;
    string id_str;
    string name;
    string screen_name;
    string location?;
    string description?;
    string? url?;
    int followers_count?;
    int friends_count?;
};

# Define search request options.
# 
# + count - Number of tweets to return per page, up to a maximum of 100
# + geocode - Geo location of tweets by users
# + lang - Restricts tweets to a language
# + locale - Specify the language of the query sent
# + result_type - Type of search results returned
# + until - Return tweets created before the given date
# + since_id - Minimum tweet Id 
# + max_id - Maximum tweet Id 
# + include_entities - Include entities nodes 
public type SearchOptions record {
    @display {label: "Tweets Count"}
    int count?;
    @display {label: "Geo Location"}
    string geocode?;
    @display {label: "Language"}
    string lang?;
    @display {label: "Query String Language"}
    string locale?;
    @display {label: "Result Type"}
    string result_type?;
    @display {label: "Tweet Date Filter"}
    string until?;
    @display {label: "Minimum Tweet Id"}
    int since_id?;
    @display {label: "Maximum Tweet Id"}
    int max_id?;
    @display {label: "Include Entities Or Not"}
    boolean include_entities?;
};

# Define update tweet options.
# 
# + media_ids - Specify the language of the query sent
# + possibly_sensitive - Whether sensitve ot not
# + lat - Latitude of tweet posted location
# + long - Longitude of tweet posted location
# + place_id - Place Id of tweet posted location
# + display_coordinates - Cordinates related to tweet posted location
# + trim_user - Reduce user details to show(only ID) 
public type UpdateTweetOptions record {
    @display {label: "Media Id"}
    string media_ids?;
    @display {label: "Sensitivie Or Not"}
    boolean possibly_sensitive?;
    @display {label: "Latitude"}
    string lat?;
    @display {label: "Longitude"}
    string long?;
    @display {label: "Place Id"}
    string place_id?;
    @display {label: "Coordinates"}
    boolean display_coordinates?;
    @display {label: "Trim User or Not"}
    boolean trim_user?;
};
