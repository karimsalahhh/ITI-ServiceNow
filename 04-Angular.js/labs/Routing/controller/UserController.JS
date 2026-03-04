app.controller("UserController", function ($scope, UserService) {
  $scope.users = [];
  $scope.isLoading = true;
  $scope.errorMessage = "";

  UserService.getUsers()
    .then(function (response) {
      $scope.users = response.data || [];
    })
    .catch(function () {
      $scope.errorMessage = "Unable to load users right now.";
    })
    .finally(function () {
      $scope.isLoading = false;
    });
});
