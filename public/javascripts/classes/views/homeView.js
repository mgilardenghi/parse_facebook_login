// Generated by CoffeeScript 1.7.1
(function() {
  App.HomeView = Ember.View.extend({
    templateName: "home",
    isLoggedInBinding: "App.MainController.isLoggedIn",
    isLoggedInDidChanged: (function() {
      if (!this.isLoggedIn) {
        this.set("title", "Welcome To Spell Your Friends");
        return this.set("pictureUrl", "images/WhoAreYou.jpg");
      }
    }).observes("this.isLoggedIn"),
    init: function() {
      this._super();
      if (!this.isLoggedIn) {
        this.set("title", "Welcome To Spell Your Friends");
        return this.set("pictureUrl", "images/WhoAreYou.jpg");
      } else {
        this.set("title", "Hi there, " + App.MainController.user.fullname());
        return this.set("pictureUrl", App.MainController.user.picture);
      }
    },
    actions: {
      login: function() {
        var self;
        self = this;
        return App.MainController.login(function(data, error) {
          if (!error) {
            self.set("title", "Hi there, " + data.fullname());
            return self.set("pictureUrl", data.picture);
          } else {
            alert(JSON.stringify(error) + "\n\n APPLICATION WILL BE RELOADED. TRY IT AGAIN.");
            return location.reload();
          }
        });
      },
      logout: function() {
        var confirm;
        confirm = window.confirm("ALERT: You will be disconnected from Facebook!");
        if (confirm) {
          return App.MainController.logout(function() {
            return location.reload;
          });
        }
      },
      goPlay: function() {
        return this.get("controller").transitionToRoute("play");
      }
    }
  });

}).call(this);
