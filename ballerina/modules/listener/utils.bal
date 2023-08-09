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

import ballerina/crypto;
import ballerina/http;
import ballerina/regex;
import ballerina/time;
import ballerina/url;
import ballerina/uuid;

isolated function registerWebHookURL(string apiKey, string apiSecret, string accessToken, string accessTokenSecret, string callback, string environmentName) returns @tainted error? {
    http:Client httpClient = check new ("https://api.twitter.com");
    http:Request request = new;

    string encodedValue = check url:encode(callback, UTF_8);
    request.setJsonPayload({"url":encodedValue});
    string resourcePath = "/1.1/account_activity/all/" + environmentName + "/webhooks.json";

    string nonce = uuid:createType1AsString();
    [int, decimal] & readonly currentTime = time:utcNow();
    string timeStamp = currentTime[0].toString();
    string oauthString = getOAuthParameters(apiKey, accessToken, nonce, timeStamp);
    var requestHeaders = createRequestHeaders(request, POST, resourcePath, apiKey, apiSecret,
            accessToken, accessTokenSecret, oauthString, nonce, timeStamp);

    if (requestHeaders is error) {
        error err = error(TWITTER_ERROR, message = "Error occurred while encoding");
        return err;
    } else {
        http:Response httpResponse = <http:Response> check httpClient->post(resourcePath, request);
        var response = httpResponse.getJsonPayload();
        if (response is json) {
            return;
        } else {
            return error(TWITTER_ERROR, message = "Error in registering Webhook");
        }
    }
}

isolated function addSubscription(string apiKey, string apiSecret, string accessToken, string accessTokenSecret, string environmentName) returns @tainted error? {
    http:Client httpClient = check new ("https://api.twitter.com");
    http:Request request = new;
    string resourcePath = "/1.1/account_activity/all/" + environmentName + "/subscriptions.json";
        
    string nonce = uuid:createType1AsString();
    [int, decimal] & readonly currentTime = time:utcNow();
    string timeStamp = currentTime[0].toString();
    string oauthString = getOAuthParameters(apiKey, accessToken, nonce, timeStamp);
    var requestHeaders = createRequestHeaders(request, POST, resourcePath, apiKey, apiSecret,
                                                accessToken, accessTokenSecret, oauthString, nonce, timeStamp);

    if (requestHeaders is error) {
        error err = error(TWITTER_ERROR, message = "Error occurred while encoding");
        return err;
    } else {
        http:Response httpResponse = <http:Response> check httpClient->post(resourcePath, request);
        var response = httpResponse.getJsonPayload();
        if (response is json) {
            return;
        } else {
            return error(TWITTER_ERROR, message = "Error in adding Subscription");
        }
    }
}

isolated function deleteWebHookURL(string apiKey, string apiSecret, string accessToken, string accessTokenSecret, string webhookId, string environmentName) returns @tainted error? {
    http:Client httpClient = check new ("https://api.twitter.com");
    http:Request request = new;
    string resourcePath = "/1.1/account_activity/all/" + environmentName + "/webhooks/" + webhookId + ".json";
    string oauthString = "";
    string nonce = uuid:createType1AsString();
    [int, decimal] & readonly currentTime = time:utcNow();
    string timeStamp = currentTime[0].toString();
    oauthString = oauthString + getOAuthParameters(apiKey, accessToken, nonce, timeStamp);
    var requestHeaders = createRequestHeaders(request, POST, resourcePath, apiKey, apiSecret,
            accessToken, accessTokenSecret, oauthString, nonce, timeStamp);

    if (requestHeaders is error) {
        error err = error(TWITTER_ERROR, message = "Error occurred while encoding");
        return err;
    } else {
        http:Response|error httpResponse = httpClient->delete(resourcePath, request);
        if (httpResponse is http:Response) {
           return null; 
        }    
    }
}

isolated function deleteSubscription(string apiKey, string apiSecret, string accessToken, string accessTokenSecret, string environmentName) returns @tainted error? {
    http:Client httpClient = check new ("https://api.twitter.com");
    http:Request request = new;
    string resourcePath = "/1.1/account_activity/all/" + environmentName + "/subscriptions.json";
    string oauthString = "";
    string nonce = uuid:createType1AsString();
    [int, decimal] & readonly currentTime = time:utcNow();
    string timeStamp = currentTime[0].toString();
    oauthString = oauthString + getOAuthParameters(apiKey, accessToken, nonce, timeStamp);
    var requestHeaders = createRequestHeaders(request, POST, resourcePath, apiKey, apiSecret,
            accessToken, accessTokenSecret, oauthString, nonce, timeStamp);

    if (requestHeaders is error) {
        error err = error(TWITTER_ERROR, message = "Error occurred while encoding");
        return err;
    } else {
        http:Response|error httpResponse = httpClient->delete(resourcePath, request);
        if (httpResponse is http:Response) {
           return null; 
        }   
    }
}

isolated function getWebHookId(json webHookResult) returns @tainted string {
    json|error webHookId = webHookResult.id;
    if (webHookId is json) {
        return webHookId.toString();
    } else {
        return "";
    }
}

isolated function getOAuthParameters(string consumerKey, string accessToken, string nonce, string timeStamp) returns string {
    string paramStr = "oauth_consumer_key=" + consumerKey + "&oauth_nonce=" + nonce +
        "&oauth_signature_method=HMAC-SHA1&oauth_timeStamp=" + timeStamp + "&oauth_token=" + accessToken
        + "&oauth_version=1.0&";
    return paramStr;
}

isolated function createRequestHeaders(http:Request request, string httpMethod, string resourcePath, string consumerKey,
                                        string consumerSecret, string accessToken, string accessTokenSecret, string paramStr, string nonce, string timeStamp) returns error? {
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
        "\",oauth_signature_method=\"HMAC-SHA1\",oauth_timeStamp=\"" + timeStamp +
        "\",oauth_nonce=\"" + nonce + "\",oauth_version=\"1.0\",oauth_signature=\"" +
        encodedSignatureValue + "\",oauth_token=\"" + encodedaccessTokenValue + "\"";
    request.setHeader("Authorization", regex:replaceAll(oauthHeaderString, "\\\\", ""));
    return ();
}

# Retrieves whether the particular remote method is available.
#
# + methodName - Name of the required method
# + methods - All available methods
# + return - `true` if method available or else `false`
isolated function isMethodAvailable(string methodName, string[] methods) returns boolean {
    boolean isAvailable = methods.indexOf(methodName) is int;
    if (isAvailable) {
        var index = methods.indexOf(methodName);
        if (index is int) {
            _ = methods.remove(index);
        }
    }
    return isAvailable;
}
