# angular-schema-form-remote-validator

``angular-schema-form-remote-validator`` provides a schema form field for angular-schema-form. It provides remote validation.

## Usage

1. Define a schema node of type ``string``.
2. Define the corresponding form of type ``remote_validator``.
3. Add an ``url`` property to the form definition containing the validator endpoint URL.

```
schema = {
  'type': 'object',
  'title': 'Foo',
  'properties': {
    'username': {
      'title': 'username',
      'type': 'string'
    }
  },
  'required': ['username']
};
form = [
  {
    key: 'username',
    type: 'remote_validator',
    url: 'check-username'
  }
];
```

## Validator Endpoints

### Request

Validator endpoints must accept ``POST`` requests.
The request body will contain a simple JSON object with only a ``value`` attribute conatining the string to validate:

```
{
  "value": "validate me"
}
```

### Response

Validator endpoints must return a JSON object with at least these properties:

```
{
  "valid": [true|false],
  "msg": "Validation message string, that is displayed when valid==false"
}
```

It can optionally contain a ``replace`` object with two properties (``what`` and ``with``):

```
{
  "valid": [true|false],
  "msg": "Validation message string, that is displayed when valid==false",
  "replace": {
    "what": "(sub)string to replace",
    "with": "string that will replace 'what'"
  }
}
```

## Example

See the included [example](example) folder.
