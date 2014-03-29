// Generated by CoffeeScript 1.7.1
(function() {
  App.fbDataSource = Ember.Object.create({
    applicationId: "QHxNvKcA8CWf1lPooLFa0ZiMP1CoqM6jVJpePuc6",
    javaScriptKey: "RiQLLP8KXJINVz8IdH2psgszdrXlP6SWmtrLrRqI",
    init: function() {
      Parse.initialize(this.get("applicationId"), this.get("javaScriptKey"));
      (function(d) {
        var id, js, ref;
        js = void 0;
        id = 'facebook-jssdk';
        ref = d.getElementsByTagName('script')[0];
        if (d.getElementById(id)) {
          return;
        }
        js = d.createElement('script');
        js.id = id;
        js.async = true;
        js.src = '//connect.facebook.net/en_US/all.js';
        return ref.parentNode.insertBefore(js, ref);
      })(document);
      return window.fbAsyncInit = function() {
        return Parse.FacebookUtils.init({
          appId: "1396886397242959",
          cookie: true,
          xfbml: false
        });
      };
    },
    fbLogin: function(callback) {
      var self;
      self = this;
      return FB.getLoginStatus(function() {
        var userPermission;
        userPermission = "email, user_friends, publish_actions, read_stream, publish_stream";
        return Parse.FacebookUtils.logIn(userPermission, {
          success: function(user) {
            console.log("USER CONNECTED");
            document.getElementById("loading").style.visibility = "visible";
            document.getElementById("button").style.visibility = "hidden";
            return self.registerUser(user, callback);
          },
          error: function(error) {
            if (JSON.stringify(error) !== "{}") {
              callback(null, error);
            }
            return console.log("USER NOT CONNECTED");
          }
        });
      });
    },
    fblogout: function(callback) {
      FB.getLoginStatus(function(response) {
        if (response.status === "unknown") {
          console.log("error");
          return callback("error");
        } else {
          FB.logout();
          return callback(null);
        }
      });
      return console.log("USER DISCONNECTED");
    },
    registerUser: function(user, callback) {
      var self;
      self = this;
      return FB.api("/me?fields=id, name, first_name, last_name, email", function(response) {
        if (!response.error) {
          user.setUsername(self.normalize(response.name));
          user.setEmail(response.email);
          return user.save(null, {
            success: function() {
              console.log("USER UPDATED");
              return callback(response, null);
            },
            error: function() {
              console.log("USER NOT UPDATED");
              return callback(null, error);
            }
          });
        } else {
          return callback(null, response.error);
        }
      });
    },
    normalize: function(string) {
      var Unaccepted, accepted, i, output;
      Unaccepted = "áàäéèëíìïóòöúùuñÁÀÄÉÈËÍÌÏÓÒÖÚÙÜÑçÇ' '";
      accepted = "aaaeeeiiiooouuunAAAEEEIIIOOOUUUNcC''";
      output = string;
      i = 0;
      while (i < Unaccepted.length) {
        output = output.replace(new RegExp(Unaccepted.charAt(i), "gm"), accepted.charAt(i));
        i++;
      }
      return output.toLowerCase();
    },
    getPhoto: function(userId, callback) {
      var query;
      query = "/" + userId + "/picture";
      return FB.api(query, {
        "type": "large"
      }, function(response) {
        if (!response.error) {
          return callback(response.data.url, null);
        } else {
          return callback(null, response.error);
        }
      });
    },
    getFriends: function(callback) {
      var self;
      self = this;
      return FB.api("/me/friends?fields=id, first_name", function(response) {
        if (!response.error) {
          return callback(response.data, null);
        } else {
          return callback(null, response.error);
        }
      });
    },
    postToTimeline: function(postMessage, callback) {
      return FB.api("/me/feed", "post", {
        message: postMessage,
        name: "Spell Your Friends"
      }, function(response) {
        if (!response.error) {
          return callback(null);
        } else {
          return callback(response.error);
        }
      });
    }
  });

}).call(this);
