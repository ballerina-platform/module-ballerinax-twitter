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

import ballerina/http;

# Listener for Twitter connector
@display {label: "Twitter Listener", iconPath: "resources/twitter.svg"}
public class Listener {
    private HttpService httpService;
    private http:Listener httpListener;
    private string callbackUrl = "";
    private string apiKey = "";
    private string apiSecret = "";
    private string accessKey = "";
    private string accessKeySecret = "";
    private string environment = "";
    private string webhookId = "";

    public isolated function init(@display{label: "Port To Listen On"} int port, 
                                  @display{ label: "Twitter API Key" } string apiKey, 
                                  @display { label: "Twitter API Key Secret" } string apiSecret,
                                  @display { label: "Twitter Access Token" } string accessKey, 
                                  @display { label: "Twitter Access Token Secret" } string accessKeySecret,
                                  @display{label: "Callback URL"} string callbackUrl,
                                  @display { label: "Environment" } string environment) returns @tainted error? {
        self.apiKey = apiKey;
        self.apiSecret = apiSecret;
        self.accessKey = accessKey;
        self.accessKeySecret = accessKeySecret;
        self.callbackUrl = callbackUrl;
        self.environment = environment;
        self.httpListener = check new (port);
    }

    public isolated function attach(service object {} s, string[]|string? name) returns @tainted error? {       
        HttpToTwitterAdaptor adaptor = check new (s);
        self.httpService = new HttpService(adaptor, self.apiKey, self.apiSecret, self.accessKey, self.accessKeySecret, self.callbackUrl, self.environment);
        check self.httpListener.attach(self.httpService, name);
    }

    public isolated function detach(SimpleHttpService s) returns @tainted error? {
        return self.httpListener.detach(s);
    }

    public isolated function 'start() returns @tainted error? {
        error? listenerError = self.httpListener.'start();
        check registerWebHookURL(self.apiKey, self.apiSecret, self.accessKey, self.accessKeySecret, self.callbackUrl, self.environment);
        check addSubscription(self.apiKey, self.apiSecret, self.accessKey, self.accessKeySecret, self.environment);
        return listenerError;
    }

    public isolated function gracefulStop() returns @tainted error? {
        check deleteWebHookURL(self.apiKey, self.apiSecret, self.accessKey, self.accessKeySecret, self.webhookId, self.environment);
        check deleteSubscription(self.apiKey, self.apiSecret, self.accessKey, self.accessKeySecret, self.environment);
        return self.httpListener.gracefulStop();
    }

    public isolated function immediateStop() returns @tainted error? {
        check deleteWebHookURL(self.apiKey, self.apiSecret, self.accessKey, self.accessKeySecret, self.webhookId, self.environment);
        check deleteSubscription(self.apiKey, self.apiSecret, self.accessKey, self.accessKeySecret, self.environment);
        return self.httpListener.immediateStop();
    }
}
