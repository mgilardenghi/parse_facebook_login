// Generated by CoffeeScript 1.7.1
(function() {
  window.App = Ember.Application.create();

  App.Router.map(function() {
    this.resource("home", {
      path: "/"
    });
    this.resource("play", {
      path: "/play"
    });
    return this.resource("score", {
      path: "/score"
    });
  });

}).call(this);
