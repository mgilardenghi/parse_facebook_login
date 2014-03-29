// Generated by CoffeeScript 1.7.1
(function() {
  App.MainController = Ember.Controller.create({
    user: null,
    game: null,
    isLoggedIn: false,
    randoms: [],
    random: 0,
    login: function(callback) {
      var self;
      self = this;
      return App.fbDataSource.fbLogin(function(parseUser, error) {
        if (!error) {
          return App.fbDataSource.getPhoto(parseUser.id, function(picture, error) {
            if (!error) {
              return App.fbDataSource.getFriends(function(friendList, error) {
                if (!error) {
                  self.set("user", App.userData.create());
                  self.user.set("firstname", parseUser.first_name);
                  self.user.set("lastname", parseUser.last_name);
                  self.user.set("picture", picture);
                  self.user.set("friends", friendList);
                  document.getElementById("loading").style.visibility = "hidden";
                  self.set("isLoggedIn", true);
                  return callback(self.user, null);
                } else {
                  return callback(null, error);
                }
              });
            } else {
              return callback(null, error);
            }
          });
        } else {
          return callback(null, error);
        }
      });
    },
    logout: function() {
      App.fbDataSource.fblogout();
      return this.set("isLoggedIn", false);
    },
    getPhoto: function(callback) {
      var self;
      self = this;
      this.random = this.getRandom();
      return App.fbDataSource.getPhoto(this.user.friends[this.random].id, function(pictureUrl, error) {
        if (!error) {
          self.game.set("picture", pictureUrl);
          return callback(null);
        } else {
          return callback(error);
        }
      });
    },
    getRandom: function() {
      var max, min, random;
      min = 0;
      max = this.user.friends.length - 1;
      random = Math.floor(Math.random() * (max - min + 1)) + min;
      while (this.randoms.indexOf(random) > 0) {
        random = Math.floor(Math.random() * (max - min + 1)) + min;
      }
      this.randoms.push(random);
      return random;
    },
    updateScore: function(typedName, callback) {
      var inputName, realName;
      realName = App.fbDataSource.normalize(this.user.friends[this.random].first_name);
      inputName = App.fbDataSource.normalize(typedName);
      if (realName === inputName) {
        this.game.score++;
        console.log("Typed Name: " + inputName);
        console.log("Yeah! - Score: " + this.game.score);
      } else {
        console.log("Typed Name: " + inputName);
        console.log("Ouch!");
      }
      this.game.counter++;
      if (this.game.counter < 11) {
        return callback(false);
      } else {
        this.set("randoms", []);
        return callback(true);
      }
    },
    post: function(callback) {
      var message;
      message = this.user.firstname + " has played Spell Your Friends. The Score is: " + this.game.score + "/10!";
      return App.fbDataSource.postToTimeline(message, function(error) {
        if (!error) {
          return callback(null);
        } else {
          return callback(error);
        }
      });
    }
  });

}).call(this);
