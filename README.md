# Ballerina Twitter Connector

[![Build](https://github.com/ballerina-platform/module-ballerinax-twitter/workflows/CI/badge.svg)](https://github.com/ballerina-platform/module-ballerinax-twitter/actions?query=workflow%3ACI)
[![codecov](https://codecov.io/gh/ballerina-platform/module-ballerinax-twitter/branch/main/graph/badge.svg)](https://codecov.io/gh/ballerina-platform/module-ballerinax-twitter)
[![Trivy](https://github.com/ballerina-platform/module-ballerinax-twitter/actions/workflows/trivy-scan.yml/badge.svg)](https://github.com/ballerina-platform/module-ballerinax-twitter/actions/workflows/trivy-scan.yml)
[![GitHub Last Commit](https://img.shields.io/github/last-commit/ballerina-platform/module-ballerinax-twitter.svg)](https://github.com/ballerina-platform/module-ballerinax-twitter/commits/master)
[![GraalVM Check](https://github.com/ballerina-platform/module-ballerinax-twitter/actions/workflows/build-with-bal-test-native.yml/badge.svg)](https://github.com/ballerina-platform/module-ballerinax-twitter/actions/workflows/build-with-bal-test-native.yml)
[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

[Twitter](https://twitter.com/) is a social networking service on which users can post and communicate with a status called "Tweets". Authenticated users can post, like, and retweet tweets. The main goal of Twitter is to connect people and to provide a platform for every person to express their thoughts to a large set of people freely.

This connector provides operations for connecting and interacting with Twitter endpoints over the network. 
For more information about configuration and operations, go to the module(s).
- [`twitter`](twitter/Module.md)

## Building from the source
### Setting up the prerequisites

1. Download and install Java SE Development Kit (JDK) version 11. You can install either [OpenJDK](https://adoptopenjdk.net/) or [Oracle JDK](https://www.oracle.com/java/technologies/javase-jdk11-downloads.html).

   > **Note:** Set the JAVA_HOME environment variable to the path name of the directory into which you installed JDK.

2. Download and install [Ballerina Swan Lake](https://ballerina.io/). 

### Building the source
Execute the following commands to build from the source.

* To build the package:
    ```    
    bal pack ./twitter
    ```
* To run the package after build:
    ```
    bal test ./twitter
    ```
## Contributing to Ballerina
As an open source project, Ballerina welcomes contributions from the community. 

For more information, see the [Contribution Guidelines](https://github.com/ballerina-platform/ballerina-lang/blob/master/CONTRIBUTING.md).

## Code of conduct
All contributors are encouraged to read the [Ballerina Code of Conduct](https://ballerina.io/code-of-conduct).

## Useful links
* Discuss about code changes of the Ballerina project via [ballerina-dev@googlegroups.com](mailto:ballerina-dev@googlegroups.com).
* Chat live with us via our [Discord server](https://discord.gg/ballerinalang).
* Post all technical questions on Stack Overflow with the [#ballerina](https://stackoverflow.com/questions/tagged/ballerina) tag.
