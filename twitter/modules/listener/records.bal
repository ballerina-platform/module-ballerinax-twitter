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

# Information about creation event of Tweet/Retweet/Reply/Mention/Quote Tweet 
#
# + for_user_id - User ID  
# + user_has_blocked - Only found in mention events  
# + tweet_create_events - Description about creation events/activity
public type TweetEvent record {
    string for_user_id;
    boolean? user_has_blocked?;
    Tweet[] tweet_create_events;
};

# Information about favourite event
#
# + for_user_id - User ID  
# + favorite_events - Description about event when someone make tweet favourited
public type FavouriteEvent record {
    string for_user_id;
    FavouriteEventInfo[] favorite_events;
};

# Defines a favourite event
#
# + id - ID of favourited tweet   
# + created_at - Event creation time  
# + timestamp_ms - Favourited event timestamp 
# + favorited_status - Tweet object assiciated with event 
# + user - User object who favourited tweet  
public type FavouriteEventInfo record {
    string id;
    string? created_at?;
    int? timestamp_ms?;
    Tweet? favorited_status?;
    User? user?;
};

# Information about delete event
#
# + for_user_id - User ID  
# + tweet_delete_events - Description about delete events 
public type DeleteTweetEvent record {
    string for_user_id;
    DeleteEvent[] tweet_delete_events;
};

# Defines a delete event
#
# + status - Information about tweet deleted  
# + timestamp_ms - Deletion operation timestamp
public type DeleteEvent record {
    DeleteStatus? status?;
    string? timestamp_ms?;
};

# Describes tweet being deleted
#
# + id - ID of tweet deleted
# + user_id - User ID belong to tweet 
public type DeleteStatus record {
    string? id?;
    string? user_id?;
};

# Information about follow event
#
# + for_user_id - User ID  
# + follow_events - Description about events when someone follows user
public type FollowEvent record {
    string for_user_id;
    FollowEventInfo[] follow_events;
};

# Defines a follow event
#
# + 'type - Type of event  
# + created_timestamp - Event created timestamp
# + target - User object follwed 
# + 'source - User object which made the follow request 
public type FollowEventInfo record {
    string 'type;
    string? created_timestamp?;
    json? target?;
    json? 'source?;
};

// public type TwitterEvent TweetEvent|MentionChangeEvent;

# Define Tweet.
#
# + created_at - Created time of the status  
# + id - ID of tweet  
# + id_str - ID of tweet in String
# + text - Text message of the status  
# + truncated - Whether the status is truncated or not  
# + entities - Entity of status  
# + 'source - Description about the source  
# + in_reply_to_status_id - ID of an existing status that update is in reply to  
# + in_reply_to_status_id_str - ID of an existing status that update is in reply to in string  
# + in_reply_to_user_id - ID of an existing user update is in reply to  
# + in_reply_to_user_id_str - ID of an existing user update is in reply to in string  
# + in_reply_to_screen_name - Screen name of an existing user update is in reply to in string  
# + user - Detail of user post  
# + geo - Geo location details (longitude and latitude)  
# + coordinates - Coordinates of location where posted  
# + place - Location name where posted  
# + contributors - Contributors to a tweet  
# + extended_tweet - Extended tweet or not
# + quoted_status_id - ID of quoted tweet
# + quoted_status_id_str - ID of quoted tweet in string
# + quoted_status - Quoted tweet or not
# + quoted_status_permalink - Quoted tweet link
# + is_quote_status - Indicate the quote status  
# + quote_count - Number of quoted tweets 
# + reply_count - Number of replies
# + retweet_count - Count of the retweeted status  
# + favorite_count - Count of the favourites  
# + favorited - Whether the status is favorited or not  
# + retweeted - Whether the status is retweeted or not  
# + filter_level - Filter Level
# + lang - Language of tweet  
# + timestamp_ms - Tweet created timestamp 
# + retweeted_status - Information  about retweeted tweet
# + possibly_sensitive - Sensitivie or not
public type Tweet record {
    string created_at;
    int id;
    string id_str?;
    string text;
    boolean truncated?;
    json? entities?;
    json? 'source?;
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
    json extended_tweet?;
    int? quoted_status_id?;
    string? quoted_status_id_str?;
    Tweet? quoted_status?;
    json? quoted_status_permalink?;
    boolean? is_quote_status?;
    int quote_count?;
    int reply_count?;
    int retweet_count?;
    int favorite_count?;
    boolean favorited?;
    boolean retweeted?;
    string? filter_level?;
    string? lang?;
    string? timestamp_ms?;
    ReTweet? retweeted_status?;
    boolean possibly_sensitive?;
};

# Define a ReTweet.
#
# + created_at - Created time of the status  
# + id - ID of tweet  
# + id_str - ID of tweet in String
# + text - Text message of the status  
# + truncated - Whether the status is truncated or not  
# + entities - Entity of status  
# + 'source - Description about the source  
# + in_reply_to_status_id - ID of an existing status that update is in reply to  
# + in_reply_to_status_id_str - ID of an existing status that update is in reply to in string  
# + in_reply_to_user_id - ID of an existing user update is in reply to  
# + in_reply_to_user_id_str - ID of an existing user update is in reply to in string  
# + in_reply_to_screen_name - Screen name of an existing user update is in reply to in string  
# + user - Detail of user post  
# + geo - Geo location details (longitude and latitude)  
# + coordinates - Coordinates of location where posted  
# + place - Location name where posted  
# + contributors - Contributors to a tweet  
# + extended_tweet - Extended tweet or not
# + quoted_status_id - ID of quoted tweet
# + quoted_status_id_str - ID of quoted tweet in string
# + quoted_status - Quoted tweet or not
# + quoted_status_permalink - Quoted tweet link
# + is_quote_status - Indicate the quote status  
# + quote_count - Number of quoted tweets 
# + reply_count - Number of replies
# + retweet_count - Count of the retweeted status  
# + favorite_count - Count of the favourites  
# + favorited - Whether the status is favorited or not  
# + retweeted - Whether the status is retweeted or not  
# + filter_level - Filter Level
# + lang - Language of tweet  
# + timestamp_ms - Tweet created timestamp 
# + retweeted_status - Information  about retweeted tweet
# + possibly_sensitive - Sensitivie or not
public type ReTweet record {
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
    json extended_tweet?;
    int? quoted_status_id?;
    string? quoted_status_id_str?;
    Tweet? quoted_status?;
    json quoted_status_permalink?;
    boolean is_quote_status?;
    int quote_count?;
    int reply_count?;
    int retweet_count?;
    int favorite_count?;
    boolean favorited?;
    boolean retweeted?;
    string? filter_level?;
    string? lang?;
    string? timestamp_ms?;
    Tweet? retweeted_status?;
    boolean possibly_sensitive?;
};

# Define User.
# 
# + id - Id of user
# + id_str - Id of user in string
# + name - Display name of user 
# + screen_name - Screen name of user
# + location - Location of user
# + description - Description about the user
# + protected - Protected status of user
# + verified - Verified status of user
# + url - Urls associated with user 
# + followers_count - Count of the followers
# + friends_count - Count of the friends(User's following)
# + listed_count - Number of lists  
# + favourites_count - Number of favourited tweets 
# + statuses_count - Number of tweets  
# + created_at - Created time of user 
# + profile_banner_url - (Deprecated) Value will be Null
# + profile_image_url_https - (Deprecated) Value will be Null
# + default_profile - (Deprecated) Value will be Null
# + default_profile_image - (Deprecated) Value will be Null
# + withheld_in_countries - (Deprecated) Value will be Null
# + withheld_scope - (Deprecated) Value will be Null
# + utc_offset - Difference between UTC and current time of location.(Deprecated) Value will be Null 
# + time_zone - Information of time zone.(Deprecated) Value will be Null
# + lang - Language of user.(Deprecated) Value will be Null
# + geo_enabled - Information about location.(Deprecated) Value will be Null
# + following - (Deprecated) Value will be Null
# + follow_request_sent - (Deprecated) Value will be Null  
# + notifications - (Deprecated) Value will be Null
# + has_extended_profile - (Deprecated) Value will be Null
# + profile_location - (Deprecated) Value will be Null
# + contributors_enabled - (Deprecated) Value will be Null
# + profile_image_url - (Deprecated) Value will be Null
# + profile_background_color - (Deprecated) Value will be Null
# + profile_background_image_url - (Deprecated) Value will be Null
# + profile_background_image_url_https - (Deprecated) Value will be Null
# + profile_background_tile - (Deprecated) Value will be Null
# + profile_link_color - (Deprecated) Value will be Null
# + profile_sidebar_border_color - (Deprecated) Value will be Null
# + profile_sidebar_fill_color - (Deprecated) Value will be Null
# + profile_text_color - (Deprecated) Value will be Null
# + profile_use_background_image - (Deprecated) Value will be Null
# + is_translator - (Deprecated) Value will be Null
# + is_translation_enabled - (Deprecated) Value will be Null
# + translator_type - (Deprecated) Value will be Null
public type User record {
    int id;
    string id_str;
    string name;
    string screen_name;
    string? location?;
    string? description?;
    boolean protected?;
    boolean verified?;
    string? url?;
    int followers_count?;
    int friends_count?;
    int listed_count?;
    int favourites_count?;
    int statuses_count?;
    string created_at?;
    string profile_banner_url?;
    string profile_image_url_https?;
    boolean default_profile?;
    boolean default_profile_image?;
    string[]? withheld_in_countries?;
    string? withheld_scope?;
    string? utc_offset?;
    string? time_zone?;
    string? lang?;
    boolean? geo_enabled?;
    string? following?;
    string? follow_request_sent?;
    string? notifications?;
    string? has_extended_profile?;
    string? profile_location?;
    boolean? contributors_enabled?;
    string? profile_image_url?;
    string? profile_background_color?;
    string? profile_background_image_url?;
    string? profile_background_image_url_https?;
    boolean? profile_background_tile?;
    string? profile_link_color?;
    string? profile_sidebar_border_color?;
    string? profile_sidebar_fill_color?;
    string? profile_text_color?;
    boolean? profile_use_background_image?;
    boolean? is_translator?;
    boolean? is_translation_enabled?;
    string? translator_type?;
};

# Define the geo location details.
# 
# + latitude - Latitude of the location
# + longitude - Longitude of the location
public type GeoLocation record {
    float latitude?;
    float longitude?;
};

type SupportedRemoteFunctionImpl record {
    boolean isOnTweet = false;
    boolean isOnReply = false;
    boolean isOnReTweet = false;
    boolean isOnFollower = false;
    boolean isOnFavourite = false;
    boolean isOnDelete = false;
    boolean isOnMention = false;
    boolean isOnQuoteTweet = false;
};
