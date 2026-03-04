app.service("UserService", function ($http) {
  const apiLink = "https://xrslatldfiyfpszgmptb.supabase.co/rest/v1/users";
  const apiKey = "sb_publishable_NE7gABdzJPAkrW00Aa7cJw_q4TI69h2";

  const config = {
    headers: {
      apikey: apiKey,
      Authorization: "Bearer " + apiKey,
      "Content-Type": "application/json",
    },
  };

  // GET all users
  this.getUsers = function () {
    return $http.get(apiLink, config);
  };

  // GET one user by id
  this.getUsersById = function (id) {
    return $http.get(apiLink + "?id=eq." + id + "&select=*", config);
  };

  // POST new user
  this.createUser = function (user) {
    return $http.post(apiLink, user, config);
  };

  // PUT update user (task asks PUT)
  this.updateUser = function (user) {
    return $http.put(apiLink + "?id=eq." + user.id, user, config);
  };

  // DELETE user
  this.deleteUser = function (id) {
    return $http.delete(apiLink + "?id=eq." + id, config);
  };
});
