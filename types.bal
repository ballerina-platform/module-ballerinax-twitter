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
# + createdAt - Created time of the status
# + id - Id of the status
# + text - Text message of the status
# + source - Source app of the status
# + truncated - Whether the status is truncated or not
# + inReplyToStatusId - The ID of an existing status that the update is in reply to
# + geo - Geo location details (longitude and latitude)
# + favorited - Whether the status is favorited or not
# + retweeted - Whether the status is retweeted or not
# + favouritesCount - Count of the favourites
# + retweetCount - Count of the retweeted status
# + lang - Language
public type Status record {
    string createdAt;
    int id;
    string text;
    string 'source?;
    boolean truncated?;
    int inReplyToStatusId?;
    GeoLocation geo?;
    boolean favorited?;
    boolean retweeted;
    int favouritesCount?;
    int retweetCount?;
    string lang?;
};

# Define the geo location details.
# + latitude - Latitude of the location
# + longitude - Longitude of the location
public type GeoLocation record {
    float latitude?;
    float longitude?;
};

# Define the location details.
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
# + name - Name of the place
# + code - Location code of the place
public type PlaceType record {
    string name?;
    int code?;
};

# Define the User.
# + id - Id of a user
# + screen_name - Screen name of user
public type User record {
    string id?;
    string screen_name?;
};

# Define the search request.
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

public type UpdateStatusOptions record {
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
