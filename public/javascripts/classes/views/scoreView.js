// Generated by CoffeeScript 1.7.1
(function() {
  App.ScoreView = Ember.View.extend({
    templateName: "score",
    init: function() {
      this._super();
      return this.set("finalScore", App.MainController.game.score);
    },
    actions: {
      post: function() {
        return App.MainController.post(function(error) {
          if (!error) {
            return alert("Congrats! Your score is now posted on Facebook.");
          } else {
            alert(JSON.stringify(error) + "\n\n APPLICATION WILL BE RELOADED. THEN TRY IT AGAIN.");
            pp.MainController.set("isLoggedIn", false);
            return self.get("controller").transitionToRoute("home");
          }
        });
      },
      goHome: function() {
        return this.get("controller").transitionToRoute("home");
      }
    }
  });

}).call(this);
