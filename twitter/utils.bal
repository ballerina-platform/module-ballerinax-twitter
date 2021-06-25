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

import ballerina/crypto;
import ballerina/http;
import ballerina/regex;
import ballerina/time;
import ballerina/url;
import ballerina/uuid;

string timeStamp = "";
string nonce = "";

isolated function handleResponse(http:Response httpResponse) returns @tainted json|error {
    json response = check httpResponse.getJsonPayload();
    if (httpResponse.statusCode is http:STATUS_OK) {
        return response;
    } else {
        return response;
    }
}

isolated function handleStatusResponse(http:Response httpResponse) returns @tainted Tweet|error {
    json response = check httpResponse.getJsonPayload();
    if (httpResponse.statusCode is http:STATUS_OK) {
        return check response.cloneWithType(Tweet);
    } else {
        return error(response.toString());
    }
}

isolated function handleStatusArrayResponse(http:Response httpResponse) returns @tainted Tweet[]|error {
    json response = check httpResponse.getJsonPayload();
    if (httpResponse.statusCode is http:STATUS_OK) {
        Tweet[] statuses = [];
        int i = 0;
        foreach json jsonStatus in <json[]>response {
            statuses[i] = check jsonStatus.cloneWithType(Tweet);
            i = i + 1;
        }
        return statuses;
    } else {
        return error(response.toString());
    }
}

isolated function handleUserResponse(http:Response httpResponse) returns @tainted User|error {
    json response = check httpResponse.getJsonPayload();
    if (httpResponse.statusCode is http:STATUS_OK) {
        return check response.cloneWithType(User);
    } else {
        return error(response.toString());
    }
}

isolated function handleSearchTweetResponse(http:Response httpResponse) returns @tainted Tweet[]|error {
    json response = check httpResponse.getJsonPayload();
    if (httpResponse.statusCode is http:STATUS_OK) {
        Tweet[] searchResponse = [];
        var tweetResponse = response.statuses;
        if (tweetResponse is json) {
            int i = 0;
            foreach json jsonStatus in <json[]>tweetResponse {
                searchResponse[i] = check jsonStatus.cloneWithType(Tweet);
                i = i + 1;
            }
            return searchResponse;
        }
        else {
            return setResponseError(response);
        }
    } else {
        return error(response.toString());
    }
}

isolated function handleUserArrayResponse(http:Response httpResponse) returns @tainted User[]|error {
    json response = check httpResponse.getJsonPayload();
    if (httpResponse.statusCode is http:STATUS_OK) {
        User[] userResponse = [];
        var userListResponse = response.users;
        if (userListResponse is json) {
            int i = 0;
            foreach json jsonStatus in <json[]>userListResponse {
                userResponse[i] = check jsonStatus.cloneWithType(User);
                i = i + 1;
            }
            return userResponse;
        }
        else {
            return setResponseError(response);
        }
    } else {
        return error(response.toString());
    }
}

function getOAuthParameters(string consumerKey, string accessToken) returns string {
    nonce = uuid:createType1AsString();
    [int, decimal] & readonly currentTime = time:utcNow();
    timeStamp = currentTime[0].toString();
    string paramStr = "oauth_consumer_key=" + consumerKey + "&oauth_nonce=" + nonce +
        "&oauth_signature_method=HMAC-SHA1&oauth_timestamp=" + timeStamp + "&oauth_token=" + accessToken
        + "&oauth_version=1.0&";
    return paramStr;
}

function createRequestHeaders(http:Request request, string httpMethod, string resourcePath, string consumerKey,
        string consumerSecret, string accessToken, string accessTokenSecret, string paramStr) returns error? {
    string serviceEndpoint = "https://api.twitter.com" + resourcePath;
    string paramString = paramStr.substring(0, paramStr.length() - 1);
    string encodedServiceEPValue = check url:encode(serviceEndpoint, UTF_8);
    string encodedParamStrValue = check url:encode(paramString, UTF_8);
    string encodedConsumerSecretValue = check url:encode(consumerSecret, UTF_8);
    string encodedAccessTokenSecretValue = check url:encode(accessTokenSecret, UTF_8);

    //Create a signature
    string baseString = httpMethod + "&" + encodedServiceEPValue + "&" + encodedParamStrValue;
    byte[] baseStringByte = baseString.toBytes();
    string keyStr = encodedConsumerSecretValue + "&" + encodedAccessTokenSecretValue;
    byte[] keyArrByte = keyStr.toBytes();
    string signature = (check crypto:hmacSha1(baseStringByte, keyArrByte)).toBase64();

    string encodedSignatureValue = check url:encode(signature, UTF_8);
    string encodedaccessTokenValue = check url:encode(accessToken, UTF_8);

    string oauthHeaderString = "OAuth oauth_consumer_key=\"" + consumerKey +
        "\",oauth_signature_method=\"HMAC-SHA1\",oauth_timestamp=\"" + timeStamp +
        "\",oauth_nonce=\"" + nonce + "\",oauth_version=\"1.0\",oauth_signature=\"" +
        encodedSignatureValue + "\",oauth_token=\"" + encodedaccessTokenValue + "\"";
    request.setHeader("Authorization", regex:replaceAll(oauthHeaderString, "\\\\", ""));
    return ();
}

function createRequestHeaderMap(http:Request request, string httpMethod, string resourcePath, string consumerKey,
        string consumerSecret, string accessToken, string accessTokenSecret, string paramStr) returns map<string>|error {
    string serviceEndpoint = "https://api.twitter.com" + resourcePath;
    string paramString = paramStr.substring(0, paramStr.length() - 1);
    string encodedServiceEPValue = check url:encode(serviceEndpoint, UTF_8);
    string encodedParamStrValue = check url:encode(paramString, UTF_8);
    string encodedConsumerSecretValue = check url:encode(consumerSecret, UTF_8);
    string encodedAccessTokenSecretValue = check url:encode(accessTokenSecret, UTF_8);

    string baseString = httpMethod + "&" + encodedServiceEPValue + "&" + encodedParamStrValue;
    byte[] baseStringByte = baseString.toBytes();
    string keyStr = encodedConsumerSecretValue + "&" + encodedAccessTokenSecretValue;
    byte[] keyStringByte = keyStr.toBytes();
    string signature = (check crypto:hmacSha1(baseStringByte, keyStringByte)).toBase64();

    string encodedSignatureValue = check url:encode(signature, UTF_8);
    string encodedaccessTokenValue = check url:encode(accessToken, UTF_8);

    string oauthHeaderString = "OAuth oauth_consumer_key=\"" + consumerKey +
        "\",oauth_signature_method=\"HMAC-SHA1\",oauth_timestamp=\"" + timeStamp +
        "\",oauth_nonce=\"" + nonce + "\",oauth_version=\"1.0\",oauth_signature=\"" +
        encodedSignatureValue + "\",oauth_token=\"" + encodedaccessTokenValue + "\"";
    return {
        ["Authorization"] : regex:replaceAll(oauthHeaderString, "\\\\", "")
    };
}

isolated function setResponseError(json jsonResponse) returns error {
    json|error errors = check jsonResponse.errors;
    error err;
    if (errors is json[]) {
        err = error(TWITTER_ERROR, message = (check errors[0].message).toString());
    } else if (errors is error) {
        err = errors;
    } else {
        err = error(TWITTER_ERROR);
    }
    return err;
}
