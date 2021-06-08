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

# Define the status.
# 
# + created_at - Created time of the status
# + id - Id of the status
# + id_str -
# + text - Text message of the status
# + source - Source app of the status
# + truncated - Whether the status is truncated or not
# + in_reply_to_status_id - The ID of an existing status that the update is in reply to
# + geo - Geo location details (longitude and latitude)
# + favorited - Whether the status is favorited or not
# + retweeted - Whether the status is retweeted or not
# + favorite_count - Count of the favourites
# + retweet_count - Count of the retweeted status
# + possibly_sensitive - Sensitivie or not
# + lang - Language
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
    User? user?;
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

public type Entity record {
    json hashtags?;
    json symbols?;
    json user_mentions?;
    json urls?;
};

# Define User.
# + id - Id of user
# + screen_name - Screen name of user
public type User record {
    int id?;
    string id_str?;
    string name?;
    string screen_name?;
    string location?;
    string description?;
    string? url?;
    int followers_count?;
    int friends_count?;
};

# Define search request.
# 
# + count - The number of tweets to return per page, up to a maximum of 100
# + geocode - Geo location of tweets by users
# + lang - Restricts tweets to a language
# + locale - Specify the language of the query sent
# + result_type - Type of search results returned
# + until - Return tweets created before the given date
# + since_id - Minimum tweet Id 
# + max_id - Maximum tweet Id 
# + include_entities - Include entities nodes 
public type SearchOptions record {
    int count?;
    string geocode?;
    string lang?;
    string locale?;
    string result_type?;
    string until?;
    int since_id?;
    int max_id?;
    boolean include_entities?;
};

public type UpdateTweetOptions record {
    int in_reply_to_status_id?;
    boolean auto_populate_reply_metadata?;
    string exclude_reply_user_ids?;
    string attachment_url?;
    string media_ids?;
    boolean possibly_sensitive?;
    string lat?;
    string long?;
    string place_id?;
    boolean display_coordinates?;
    boolean trim_user?;
    boolean enable_dmcommands?;
    boolean fail_dmcommands?;
    string card_uri?;
};
