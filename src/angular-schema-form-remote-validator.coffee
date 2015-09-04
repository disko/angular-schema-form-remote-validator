angular.module('schemaForm').config (schemaFormProvider, schemaFormDecoratorsProvider, sfPathProvider) ->

  remoteValidator = (name, schema, options) ->
    if (schema.type == 'remote-validator') or (schema.type == 'string' and schema.format == 'remote-validator')
      f = schemaFormProvider.stdFormObj(name, schema, options)
      f.key = options.path
      f.type = 'remote-validator'
      options.lookup[sfPathProvider.stringify(options.path)] = f
      return f
    return

  schemaFormProvider.defaults.string.unshift remoteValidator
  #Add to the bootstrap directive
  schemaFormDecoratorsProvider.addMapping 'bootstrapDecorator', 'remote-validator', 'directives/decorators/bootstrap/remote-validator/remote-validator.html'
  schemaFormDecoratorsProvider.createDirective 'remote-validator', 'directives/decorators/bootstrap/remote-validator/remote-validator.html'
  return

angular.module('schemaForm').directive 'remoteValidator', ($q, $http, $log) ->

  # see http://www.benlesh.com/2012/12/angular-js-custom-validation-via.html
  remoteValidator =

    restrict: 'A'  # restrict to an attribute type.
    require: 'ngModel'  # element must have ng-model attribute

    link: (scope, element, attrs, ngModel) ->
      # scope = the parent scope
      # element = the element the directive is on
      # attrs = a dictionary of attributes on the element
      # ngModel = the controller for ngModel.

      url = attrs.remoteValidator
      key = attrs.remoteValidatorKey

      scope.errorMessage = ->
        scope.errMsg || null

      ngModel.$asyncValidators[key] = (value) ->
        $log.info(value)
        data = {}
        data[key] = value
        return $http
          .post(url, data)
          .then (response) ->
            if response.data.valid
              if ngModel.$modelValue && response.data && response.data.what && response.data.with
                ngModel.$modelValue = ngModel.$modelValue.replace(response.data.what, response.data.with)
                scope.$broadcast('schemaFormRedraw')
              return $q.resolve()
            else
              context = scope
              scope.form.validationMessage = {}
              scope.errMsg = response.data.msg
              return $q.reject(response.data.msg)


      # add a parser that will process each time the value is
      # parsed into the model when the user updates it.
      # ngModel.$parsers.unshift (value) ->
      #   # test and set the validity after update.
      #   debugger
      #   valid = scope.validate(value)
      #   ngModel.$setValidity 'remote-validator', valid

      #   if valid
      #     # value = IBAN.electronicFormat(value)
      #     scope.$broadcast('schemaFormValidate')

      #   # if it's valid, return the value to the model,
      #   # otherwise return undefined.
      #   if valid then value else undefined

      # add a formatter that will process each time
      # the value is updated on the DOM element.
      # ngModel.$formatters.unshift (value) ->
      #   debugger
      #   valid = false

      #   # validate.
      #   ctrl.$setValidity 'remote-validator', valid

      #   if valid
      #     # value = IBAN.printFormat(value)
      #     scope.$broadcast('schemaFormValidate')

      #   # return the value or nothing will be written to the DOM.
      #   value


      return

  return remoteValidator
