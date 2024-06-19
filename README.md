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

### Prerequisites

1. Download and install Java SE Development Kit (JDK) version 17. You can download it from either of the following sources:

    * [Oracle JDK](https://www.oracle.com/java/technologies/downloads/)
    * [OpenJDK](https://adoptium.net/)

   > **Note:** After installation, remember to set the `JAVA_HOME` environment variable to the directory where JDK was installed.

2. Download and install [Ballerina Swan Lake](https://ballerina.io/).

3. Download and install [Docker](https://www.docker.com/get-started).

   > **Note**: Ensure that the Docker daemon is running before executing any tests.

4. Export Github Personal access token with read package permissions as follows,

    ```bash
    export packageUser=<Username>
    export packagePAT=<Personal access token>
    ```


### Build options

Execute the commands below to build from the source.

1. To build the package:

   ```bash
   ./gradlew clean build
   ```

2. To run the tests:

   ```bash
   ./gradlew clean test
   ```

3. To build the without the tests:

   ```bash
   ./gradlew clean build -x test
   ```

4. To run tests against different environment:

   ```bash
   ./gradlew clean test -Pgroups=<Comma separated groups/test cases>
   ```

5. To debug package with a remote debugger:

   ```bash
   ./gradlew clean build -Pdebug=<port>
   ```

6. To debug with the Ballerina language:

   ```bash
   ./gradlew clean build -PbalJavaDebug=<port>
   ```

7. Publish the generated artifacts to the local Ballerina Central repository:

    ```bash
    ./gradlew clean build -PpublishToLocalCentral=true
    ```

8. Publish the generated artifacts to the Ballerina Central repository:

   ```bash
   ./gradlew clean build -PpublishToCentral=true
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
