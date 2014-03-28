
App.fbDataSource = Ember.Object.create
  
  applicationId: "QHxNvKcA8CWf1lPooLFa0ZiMP1CoqM6jVJpePuc6"
  javaScriptKey: "RiQLLP8KXJINVz8IdH2psgszdrXlP6SWmtrLrRqI"
  
  init: ->

    Parse.initialize this.get("applicationId"), this.get("javaScriptKey")
  
    ## include Facebook SDK script
    ((d) ->
      js = undefined
      id = 'facebook-jssdk'
      ref = d.getElementsByTagName('script')[0]
      return  if d.getElementById(id)
      js = d.createElement('script')
      js.id = id
      js.async = true
      js.src = '//connect.facebook.net/en_US/all.js'
      ref.parentNode.insertBefore js, ref
    ) document   
 
    ## Load Parse SDK - must be initialized when facebook SDK initialization ends
    window.fbAsyncInit = ->

      Parse.FacebookUtils.init
        appId      : "1396886397242959"   ## facebook APP ID
        cookie     : true                 ## enable cookies to allow the server to access the session
        xfbml      : false                ## parse XFBML, used to include social plugins such as facebook 'like' button
  

  # log in Parse with facebook
  fbLogin: (callback) ->
    
    self = this
    ## getLoginStatus call refresh the facebook access token. Otherwise Parse.FacebookUtils.logIn
    ## will failed returning an expired token message
    FB.getLoginStatus () ->
      userPermission = "email, user_friends, publish_actions, read_stream, publish_stream"    
      Parse.FacebookUtils.logIn userPermission,                   
        success: (user) -> 
          console.log "USER CONNECTED"
          self.registerUser user, callback
        error: (error) ->
          console.log "USER NOT CONNECTED"
          callback null, error
 
  
  # log out of Parse
  fblogout: ->

    Parse.User.logOut()
    console.log "USER DISCONNECTED"


  # get facebook data and create user in Parse
  registerUser: (user, callback) ->
    
    self = this
    FB.api "/me?fields=id, name, first_name, last_name, email", (response) ->         
      unless response.error
        user.setUsername self.normalize(response.name) 
        user.setEmail response.email
        user.save null,
          success: ->
            console.log "USER UPDATED"
            callback response, null
          error: ->
            console.log "USER NOT UPDATED"
            callback null, error
      else
        callback null, response.error
  
  
  # normalize string
  normalize: (string) ->

    Unaccepted = "áàäéèëíìïóòöúùuñÁÀÄÉÈËÍÌÏÓÒÖÚÙÜÑçÇ' '"    # blanks are also removed  
    accepted = "aaaeeeiiiooouuunAAAEEEIIIOOOUUUNcC''"       # Example: 'firstNamelastName'   
    output = string                               
    i = 0
    while i < Unaccepted.length
      output = output.replace new RegExp(Unaccepted.charAt(i),"gm"), accepted.charAt(i)   # RegExp creates a regular expression
      i++                                                                                 # where g = global and m = multiline in                                                                                        # order to remove all unaccepted characters apparences
    output.toLowerCase()
  
 
  # get user picture
  getPhoto: (userId, callback) ->

    query = "/" + userId + "/picture" 
    FB.api query, "type": "large", (response) -> 
      unless response.error
        callback response.data.url, null
      else
        callback null, response.error 
  
 
  # get user friends list
  getFriends: (callback) ->

    self = this
    FB.api "/me/friends?fields=id, first_name", (response) -> 
      unless response.error       
        callback response.data, null
      else
        callback null, response.error
 

  # Post the score to Facebook Timeline
  postToTimeline: (postMessage, callback) ->
    
    FB.api "/me/feed", "post",
      message: postMessage
      name: "Spell Your Friends"
      (response) ->     
        unless response.error
          callback null
        else 
          callback response.error