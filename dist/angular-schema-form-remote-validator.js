angular.module("schemaForm").run(["$templateCache", function($templateCache) {$templateCache.put("directives/decorators/bootstrap/remote-validator/remote-validator.html","<div class=\"form-group {{form.htmlClass}}\" ng-class=\"{\'has-error\': form.disableErrorState !== true && hasError(), \'has-success\': form.disableSuccessState !== true && hasSuccess(), \'has-feedback\': form.feedback !== false }\"><label class=\"control-label\" ng-show=\"showTitle()\">{{form.title}}</label><div ng-class=\"{\'input-group\': (form.fieldAddonLeft || form.fieldAddonRight)}\"><span ng-if=\"form.fieldAddonLeft\" class=\"input-group-addon\" ng-bind-html=\"form.fieldAddonLeft\"></span> <input aria-describedby=\"{{form.key.slice(-1)[0] + \'Status\'}}\" class=\"form-control {{form.fieldHtmlClass}}\" format=\"form.format\" remote-validator=\"{{form.url}}\" remote-validator-key=\"{{form.validate || form.key.slice(-1)[0]}}\" id=\"{{form.key.slice(-1)[0]}}\" name=\"{{form.key.slice(-1)[0]}}\" ng-disabled=\"form.readonly\" ng-model-options=\"form.ngModelOptions\" ng-model=\"$$value$$\" ng-show=\"form.key\" placeholder=\"{{form.placeholder}}\" schema-validate=\"form\" sf-changed=\"form\" style=\"background-color: white\" type=\"text\"> <span ng-if=\"form.fieldAddonRight\" class=\"input-group-addon\" ng-bind-html=\"form.fieldAddonRight\"></span></div><span ng-if=\"form.feedback !== false\" class=\"form-control-feedback\" ng-class=\"evalInScope(form.feedback) || {\'glyphicon\': true, \'glyphicon-ok\': hasSuccess(), \'glyphicon-remove\': hasError() }\" aria-hidden=\"true\"></span> <span ng-if=\"hasError() || hasSuccess()\" id=\"{{form.key.slice(-1)[0] + \'Status\'}}\" class=\"sr-only\">{{ hasSuccess() ? \'(success)\' : \'(error)\' }}</span> <span class=\"help-block\">{{ (hasError() && errorMessage(schemaError())) || form.description}}</span></div>");}]);
(function() {
  angular.module('schemaForm').config(["schemaFormProvider", "schemaFormDecoratorsProvider", "sfPathProvider", function(schemaFormProvider, schemaFormDecoratorsProvider, sfPathProvider) {
    var remoteValidator;
    remoteValidator = function(name, schema, options) {
      var f;
      if ((schema.type === 'remote-validator') || (schema.type === 'string' && schema.format === 'remote-validator')) {
        f = schemaFormProvider.stdFormObj(name, schema, options);
        f.key = options.path;
        f.type = 'remote-validator';
        options.lookup[sfPathProvider.stringify(options.path)] = f;
        return f;
      }
    };
    schemaFormProvider.defaults.string.unshift(remoteValidator);
    schemaFormDecoratorsProvider.addMapping('bootstrapDecorator', 'remote-validator', 'directives/decorators/bootstrap/remote-validator/remote-validator.html');
    schemaFormDecoratorsProvider.createDirective('remote-validator', 'directives/decorators/bootstrap/remote-validator/remote-validator.html');
  }]);

  angular.module('schemaForm').directive('remoteValidator', ["$q", "$http", "$log", function($q, $http, $log) {
    var remoteValidator;
    remoteValidator = {
      restrict: 'A',
      require: 'ngModel',
      link: function(scope, element, attrs, ngModel) {
        var key, url;
        url = attrs.remoteValidator;
        key = attrs.remoteValidatorKey;
        scope.errorMessage = function() {
          return scope.errMsg || null;
        };
        ngModel.$asyncValidators[key] = function(value) {
          var data;
          $log.info(value);
          data = {};
          data[key] = value;
          return $http.post(url, data).then(function(response) {
            var context;
            if (response.data.valid) {
              if (ngModel.$modelValue && response.data && response.data.what && response.data["with"]) {
                ngModel.$modelValue = ngModel.$modelValue.replace(response.data.what, response.data["with"]);
                scope.$broadcast('schemaFormRedraw');
              }
              return $q.resolve();
            } else {
              context = scope;
              scope.form.validationMessage = {};
              scope.errMsg = response.data.msg;
              return $q.reject(response.data.msg);
            }
          });
        };
      }
    };
    return remoteValidator;
  }]);

}).call(this);
