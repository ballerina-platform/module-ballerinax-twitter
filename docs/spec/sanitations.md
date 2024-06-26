_Authors_: @vish-mv @loshan20011  \
_Created_: 2024/03/26 \
_Updated_: 2024/03/26 \
_Edition_: Swan Lake

# Sanitation for OpenAPI specification

This document records the sanitation done on top of the official OpenAPI specification from Twitter (X). The OpenAPI specification is obtained from the [Twitter OpenAPI Documentation](https://api.twitter.com/2/openapi.json/). These changes are implemented to enhance the overall usability and readability of the generated client.

1. **Change the `url` property of the `servers` object**:
   - **Original**: `https://api.twitter.com`
   - **Updated**: `https://api.twitter.com/2`
   - **Reason**: This change is made to ensure that all API paths are relative to the versioned base URL (`/2`), which improves the consistency and usability of the APIs.

2. **Update API Paths**:
   - **Original**: Paths included the version prefix in each endpoint (e.g., `/2/compliance/jobs`).
   - **Updated**: Paths are modified to remove the version prefix from the endpoints, as it is now included in the base URL. For example:
     - **Original**: `/2/compliance/jobs`
     - **Updated**: `/compliance/jobs`
   - **Reason**: This modification simplifies the API paths, making them shorter and more readable. It also centralizes the versioning to the base URL, which is a common best practice.


## OpenAPI cli command

The following command was used to generate the Ballerina client from the OpenAPI specification. The command should be executed from the repository root directory.

```bash
bal openapi -i docs/spec/openapi.json --mode client --license docs/license.txt -o ballerina
```
Note: The license year is hardcoded to 2024, change if necessary.
