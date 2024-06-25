_Authors_: @vish-mv @loshan20011  \
_Created_: 2024/03/26 \
_Updated_: 2024/03/26 \
_Edition_: Swan Lake

## OpenAPI cli command

The following command was used to generate the Ballerina client from the OpenAPI specification. The command should be executed from the repository root directory.

```bash
bal openapi -i docs/spec/openapi.json --mode client --license docs/license.txt -o ballerina
```
Note: The license year is hardcoded to 2024, change if necessary.
