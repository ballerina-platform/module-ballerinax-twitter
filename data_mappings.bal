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

isolated function convertToStatus(json jsonStatus) returns Status {
    Status status = {createdAt:"", id:0, retweeted: false, text:""};
    var createdAt = jsonStatus.created_at;
    if (createdAt is json) {
        status.createdAt = createdAt != null ? createdAt.toString() : "";
    }
    var id = jsonStatus.id;
    if (id is json) {
        status.id = id != null ? convertToInt(id) : 0;
    }
    var text = jsonStatus.text;
    if (text is json) {
        status.text = text != null ? text.toString() : "";
    }
    var sourceOut = jsonStatus.'source;
    if (sourceOut is json) {
        status.'source = sourceOut != null ? sourceOut.toString() : "";
    }
    var truncated = jsonStatus.truncated;
    if (truncated is json) {
        status.truncated = truncated != null ? convertToBoolean(truncated) : false;
    }
    var inReplyToStatusId = jsonStatus.in_reply_to_status_id;
    if (inReplyToStatusId is json) {
        status.inReplyToStatusId = inReplyToStatusId != null ? convertToInt(inReplyToStatusId) : 0;
    }
    var favorited = jsonStatus.favorited;
    if (favorited is json) {
        status.favorited = favorited != null ? convertToBoolean(favorited) : false;
    }
    var retweeted = jsonStatus.retweeted;
    if (retweeted is json) {
        status.retweeted = retweeted != null ? convertToBoolean(retweeted) : false;
    }
    var favouritesCount = jsonStatus.favourites_count;
    if (favouritesCount is json) {
        status.favouritesCount = favouritesCount != null ? convertToInt(favouritesCount) : 0;
    }
    var retweetCount = jsonStatus.retweet_count;
    if (retweetCount is json) {
        status.retweetCount = retweetCount != null ? convertToInt(retweetCount) : 0;
    }
    var lang = jsonStatus.lang;
    if (lang is json) {
        status.lang = lang != null ? lang.toString() : "";
    }
    var geo = jsonStatus.geo;
    if (geo is json) {
        status.geo = geo != null ? convertToGeoLocation(geo) : {};
    }
    return status;
}

isolated function convertToUser(json jsonUser) returns User {
    User user = {};
    var id = jsonUser.id;
    if (id is json) {
        user.id = id != null ? id.toString() : "";
    }
    var screen_name = jsonUser.screen_name;
    if (screen_name is json) {
        user.screen_name = screen_name != null ? screen_name.toString() : "";
    }
    return user;
}

isolated function convertToInt(json jsonVal) returns int {
    if (jsonVal is int) {
        return jsonVal;
    }
    panic error("Error occurred when converting " + jsonVal.toString() + " to int");
}

isolated function convertToBoolean(json jsonVal) returns boolean {
    if (jsonVal is boolean) {
        return jsonVal;
    }
    panic error("Error occurred when converting " + jsonVal.toString() + " to boolean");
}

isolated function convertToFloat(json jsonVal) returns float {
    if (jsonVal is float) {
        return jsonVal;
    }
    panic error("Error occurred when converting " + jsonVal.toString() + " to float");
}

isolated function convertToGeoLocation(json jsonStatus) returns GeoLocation {
    GeoLocation geoLocation = {};
    var latitude = jsonStatus.geo.latitude;
    if (latitude is json) {
        geoLocation.latitude = latitude != null ? convertToFloat(latitude) : 0.0;
    }
    var longitude = jsonStatus.geo.longitude;
    if (longitude is json) {
        geoLocation.longitude = longitude != null ? convertToFloat(longitude) : 0.0;
    }
    return geoLocation;
}

isolated function convertToStatuses(json[] jsonStatuses) returns Status[] {
    Status[] statuses = [];
    int i = 0;
    foreach json jsonStatus in jsonStatuses {
        statuses[i] = convertToStatus(jsonStatus);
        i = i + 1;
    }
    return statuses;
}

isolated function convertToUsers(json[] jsonUsers) returns User[] {
    User[] users = [];
    int i = 0;
    foreach json jsonUser in jsonUsers {
        users[i] = convertToUser(jsonUser);
        i = i + 1;
    }
    return users;
}


