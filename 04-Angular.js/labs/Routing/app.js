var app = angular.module("productApp", ["ngRoute"]);
app.config(function ($routeProvider) {
  $routeProvider
    .when("/users", {
      templateUrl: "views/users.html",
      controller: "UserController",
    })
    .when("/userdetail/:id", {
      templateUrl: "views/userdetail.html",
      controller: "UserDetailController",
    })
    .when("/about", {
      templateUrl: "views/about.html",
      controller: "AboutController",
    })
    .otherwise({
      redirectTo: "/users",
    });
});

app.controller("MainController", function ($scope, $location) {
  $scope.$location = $location;
  $scope.isActive = function (viewLocation) {
    return viewLocation === $location.path();
  };
});
