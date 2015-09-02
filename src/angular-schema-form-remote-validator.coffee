angular.module('schemaForm').config (schemaFormProvider, schemaFormDecoratorsProvider, sfPathProvider) ->

  remote_validator = (name, schema, options) ->
    if (schema.type == 'remote-validator') or (schema.type == 'string' and schema.format == 'remote-validator')
      f = schemaFormProvider.stdFormObj(name, schema, options)
      f.key = options.path
      f.type = 'remote-validator'
      options.lookup[sfPathProvider.stringify(options.path)] = f
      return f
    return

  schemaFormProvider.defaults.string.unshift remote_validator
  #Add to the bootstrap directive
  schemaFormDecoratorsProvider.addMapping 'bootstrapDecorator', 'remote-validator', 'directives/decorators/bootstrap/remote-validator/remote-validator.html'
  schemaFormDecoratorsProvider.createDirective 'remote-validator', 'directives/decorators/bootstrap/remote-validator/remote-validator.html'
  return


angular.module('schemaForm').directive 'remote-validator', ->

  # see http://www.benlesh.com/2012/12/angular-js-custom-validation-via.html

  validateIban = (value) ->
  remote_validator =

    # restrict to an attribute type.
    restrict: 'A'

    # element must have ng-model attribute
    require: 'ngModel'

    # scope = the parent scope
    # elem = the element the directive is on
    # attr = a dictionary of attributes on the element
    # ctrl = the controller for ngModel.
    link: (scope, elem, attr, ctrl) ->

      # add a parser that will process each time the value is
      # parsed into the model when the user updates it.
      ctrl.$parsers.unshift (value) ->

        # test and set the validity after update.
        valid = IBAN.isValid(value)
        ctrl.$setValidity 'remote-validator', valid

        if valid
          value = IBAN.electronicFormat(value)
          scope.$broadcast('schemaFormValidate')

        # if it's valid, return the value to the model,
        # otherwise return undefined.
        if valid then value else undefined

      # add a formatter that will process each time
      # the value is updated on the DOM element.
      ctrl.$formatters.unshift (value) ->

        valid = IBAN.isValid(value)

        # validate.
        ctrl.$setValidity 'remote-validator', valid

        if valid
          value = IBAN.printFormat(value)
          scope.$broadcast('schemaFormValidate')

        # return the value or nothing will be written to the DOM.
        value

      return

  return remote_validator
