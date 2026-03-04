app.controller("AboutController", function ($scope) {
  $scope.project = {
    title: "AngularJS Routing Lab",
    description:
      "This lab demonstrates navigation between multiple views using ngRoute, with data loaded from a Supabase REST API.",
    features: [
      "Client-side routes with ngRoute",
      "Reusable UserService for API calls",
      "User list and user detail pages",
      "Bootstrap-based responsive UI",
    ],
  };
});
