
## EMBER APP - MAIN CONTROLLER 

App.MainController = Ember.Controller.create
  
  ## data models
  user: null
  game: null
  
  ## boolean that shows user data in home template when 'true'
  ## else shows login button
  isLoggedIn: false
  
  ## local variables
  randoms: []
  random: 0

  ## log in Parse with facebook - creates or updates facebook user in Parse
  login: (callback) ->

    self = this
    App.fbDataSource.fbLogin (parseUser, error) ->           
      unless error
        App.fbDataSource.getPhoto parseUser.id, (picture, error) ->
          unless error
            App.fbDataSource.getFriends (friendList, error) ->
              unless error
                self.set "user", App.userData.create()
                self.user.set "firstname", parseUser.first_name
                self.user.set "lastname", parseUser.last_name
                self.user.set "picture", picture
                self.user.set "friends", friendList
                document.getElementById("loading").style.visibility = "hidden";
                self.set "isLoggedIn", true
                callback self.user, null
              else
                callback null, error
          else
            callback null, error
      else
        callback null, error  

  ## logs out from Facebook
  logout: ->

    App.fbDataSource.fblogout()
    self.set "isLoggedIn", false

  ## gets facebook picture
  getPhoto: (callback) ->

    self = this
    this.random = this.getRandom()
    App.fbDataSource.getPhoto this.user.friends[this.random].id, (pictureUrl, error) ->
      unless error
        self.game.set "picture", pictureUrl
        callback null
      else
        callback error

  ## creates random numbers for user's friends 
  getRandom: ->

    min = 0
    max = this.user.friends.length - 1
    random = Math.floor( Math.random() * (max - min + 1) )  + min
    while this.randoms.indexOf(random) > 0
      random = Math.floor( Math.random() * (max - min + 1) )  + min
    this.randoms.push random
    return random

  ## compares friend's real name with typed name by user and updates score
  updateScore: (typedName, callback) ->

    realName =  App.fbDataSource.normalize this.user.friends[this.random].first_name
    inputName = App.fbDataSource.normalize typedName

    if realName == inputName
      this.game.score++
      console.log "Typed Name: " + inputName
      console.log "Yeah! - Score: " + this.game.score
    else
      console.log "Typed Name: " + inputName
      console.log "Ouch!" 

    this.game.counter++
    
    if this.game.counter < 11
      callback false
    else
      this.set "randoms", []
      callback true
  
  # Post the score to Facebook Timeline
  post: (callback) ->

    message = this.user.firstname + " has played Spell Your Friends. The Score is: " + this.game.score + "/10!"
    App.fbDataSource.postToTimeline message, (error) ->
      unless error
        callback null
      else 
        callback error