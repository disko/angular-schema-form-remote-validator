# WIP – DO NOT USE YET!

## angular-schema-form-remote-validator

``angular-schema-form-remote-validator`` provides a schema form field for angular-schema-form. It provides remote validation.

## Usage

1. Define a schema node of type ``string`` with format format ``remote-validator``.
.
2. Define the corresponding form:

   1. Add an ``url`` property to the form definition containing the validator endpoint URL.
   2. Add a ``validate`` property to the form definition containing the validator's name.

```
schema = {
  'type': 'object',
  'title': 'Foo',
  'properties': {
    'username': {
      'title': 'username',
      'type': 'string',
      'format': 'remote-validator'
    }
  },
  'required': ['username']
};
form = [
  {
    key: 'username',
    url: '/validate',
    validate: 'username'
  }
];
```

## Validator Endpoints

### Request

Validator endpoints must accept ``POST`` requests.
The request body will contain a simple JSON object with a ``key: value`` pair.
``key`` is the attribute to validate – the backend will typically chose the validation method based on ``key``.
``value`` is the value to validate.

For example validation of ``user1`` for being a valid ``username`` would send this JSON object to the backend.

```
{
  "username": "user1"
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

# Work In Progress

This package is wor in progress and should by no means be considered stable.
Things will change!
Use at your own risk.
