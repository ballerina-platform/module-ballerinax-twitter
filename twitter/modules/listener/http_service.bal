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
import ballerina/log;

service class HttpService {
    final SupportedRemoteFunctionImpl supportedRemoteFunctionImpl = {};
    private SimpleHttpService httpService;
    private EventDispatcher eventDispatcher;
    private string apiKey;
    private string apiSecret;
    private string accessKey;
    private string accessKeySecret;
    private string callbackUrl;

    public isolated function init(SimpleHttpService httpService, string apiKey, string apiSecret, string accessKey, string accessKeySecret, string callbackUrl, string environmentName) {
        self.eventDispatcher = new (httpService);
        self.httpService = httpService;
        self.callbackUrl = callbackUrl;
        self.apiKey = apiKey;
        self.apiSecret = apiSecret;
        self.accessKey = accessKey;
        self.accessKeySecret = accessKeySecret;
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

    isolated resource function post webhook/twitter(http:Caller caller, http:Request twitterRequest) returns 
                                           @tainted error? {                                        
        json payload = check twitterRequest.getJsonPayload();
        map<json> mapPayload = <map<json>> payload;
        check caller->respond(http:STATUS_OK); 
        error? dispatchResult = self.eventDispatcher.dispatch(payload);
        if (dispatchResult is error) {
            return error("Failed to dispatch event : ", 'error = dispatchResult);
        }
        return;
    }

    isolated resource function get webhook/twitter(http:Caller caller, http:Request twitterRequest) returns 
                                           @tainted error? {                                    
        map<string[]> queryParams = twitterRequest.getQueryParams();
        string[]? crc_token = queryParams["crc_token"];
        string token = "";
        string base64Result= "";

        if (crc_token is string[]){
            string apiSecret = self.apiSecret;
            token = crc_token[0];
            byte[] inputArr = token.toBytes();
            byte[] keyArr = apiSecret.toBytes();
            byte[] output = check crypto:hmacSha256(inputArr, keyArr);
            base64Result = output.toBase64();
            json response = {response_token: "sha256=" + base64Result};
            http:ListenerError? respond = caller->respond(<@untainted>(response));
        } else {
            return error(TWITTER_ERROR, message = "Error in CRC token validation");
        }
    }

    isolated function validateCRCToken(http:Caller caller, http:Request twitterRequest, string apiSecret) returns @tainted error|json {
        map<string[]> queryParams = twitterRequest.getQueryParams();
        string[]? crc_token = queryParams["crc_token"];
        string token = "";
        string base64Result= "";

        if (crc_token is string[]){
            token = crc_token[0];
            byte[] inputArr = token.toBytes();
            byte[] keyArr = apiSecret.toBytes();
            byte[] output = check crypto:hmacSha256(inputArr, keyArr);
            base64Result = output.toBase64();
            json response = {response_token: "sha256=" + base64Result};
            http:ListenerError? respond = caller->respond(<@untainted>(response));
        } else {
                
        }
    }
}
