app = angular.module('app', [ 'schemaForm' ])

app.controller 'formCtrl', ($scope) ->

  $scope.schema =
    'type': 'object'
    'title': 'Foo'
    'properties':
      'username':
        'title': 'Username'
        'type': 'string'
        'format': 'remote-validator'
      'phone':
        'title': 'Telephone'
        'type': 'string'
        'format': 'remote-validator'
      'fax':
        'title': 'Facsimile'
        'type': 'string'
        'format': 'remote-validator'
    'required': ['username', 'phone', 'fax']

  $scope.form = [
    {
      key: 'username'
      url: 'http://127.0.0.1:6543/validate'
      validate: 'username'
    }, {
      key: 'phone'
      url: 'http://127.0.0.1:6543/validate'
      validate: 'phone'
    }, {
      key: 'fax'
      url: 'http://127.0.0.1:6543/validate'
      validate: 'phone'
    }
  ]

  $scope.model = {}

  $scope.$watch 'model', ((value) ->
    if value
      $scope.prettyModel = JSON.stringify(value, undefined, 2)
    return
  ), true

  return
