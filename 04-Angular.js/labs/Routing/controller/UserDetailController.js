app.controller(
  "UserDetailController",
  function ($scope, $routeParams, UserService) {
    $scope.userId = $routeParams.id;
    $scope.user = null;
    $scope.isLoading = true;
    $scope.errorMessage = "";

    UserService.getUsersById($scope.userId)
      .then(function (response) {
        const users = response.data || [];
        $scope.user = users.length > 0 ? users[0] : null;
        if ($scope.user === null) {
          $scope.errorMessage = "User not found.";
        }
      })
      .catch(function () {
        $scope.errorMessage = "Unable to load user details.";
      })
      .finally(function () {
        $scope.isLoading = false;
      });
  },
);
