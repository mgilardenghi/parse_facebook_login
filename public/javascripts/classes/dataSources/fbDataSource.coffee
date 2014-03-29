
## DATA SOURCE - BACKGROUND PROCESSES THAT CREATE FACEBOOK USER IN PARSE

App.fbDataSource = Ember.Object.create
  
  ## parse pair of keys
  applicationId: "QHxNvKcA8CWf1lPooLFa0ZiMP1CoqM6jVJpePuc6"
  javaScriptKey: "RiQLLP8KXJINVz8IdH2psgszdrXlP6SWmtrLrRqI"
  
  init: ->

    ## inits parse sdk
    Parse.initialize this.get("applicationId"), this.get("javaScriptKey")
  
    ## includes Facebook SDK script in index file
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
 
    ## Loads Parse SDK - must be initialized when facebook SDK initialization ends
    window.fbAsyncInit = ->

      Parse.FacebookUtils.init
        appId      : "1396886397242959"   ## facebook APP ID
        cookie     : true                 ## enable cookies to allow the server to access the session
        xfbml      : false                ## parse XFBML, used to include social plugins such as facebook 'like' button
  
  # logs in Parse with facebook
  fbLogin: (callback) ->
    
    self = this
    ## getLoginStatus call refresh the facebook access token. Otherwise Parse.FacebookUtils.logIn
    ## will failed returning an expired token message
    FB.getLoginStatus () ->
      userPermission = "email, user_friends, publish_actions, read_stream, publish_stream"    
      Parse.FacebookUtils.logIn userPermission,                   
        success: (user) -> 
          console.log "USER CONNECTED"
          ## shows loading gif until user is already registered in parse (connected to app)
          document.getElementById("loading").style.visibility = "visible";
          document.getElementById("button").style.visibility = "hidden";
          self.registerUser user, callback
        error: (error) ->
          ## if user closes facebook login pop-up, error is empty so its not sent
          if error
            callback null, error
          console.log "USER NOT CONNECTED"
 
  # logs out from Facebook
  fblogout: (callback) ->

    FB.logout (response) ->
      unless response.error
        callback null
      else
        callback response.error
    console.log "USER DISCONNECTED"

  # gets facebook data and creates user in Parse
  registerUser: (user, callback) ->
    
    self = this
    FB.api "/me?fields=id, name, first_name, last_name, email", (response) ->         
      unless response.error
        ## normalizes strings and registers data in Parse 
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
  
  
  # normalizes strings
  normalize: (string) ->
                                                            # removes 'tildes' (Latin America Names)
    Unaccepted = "áàäéèëíìïóòöúùuñÁÀÄÉÈËÍÌÏÓÒÖÚÙÜÑçÇ' '"    # and blanks
    accepted = "aaaeeeiiiooouuunAAAEEEIIIOOOUUUNcC''"       # Example: 'firstNamelastName'   
    output = string                               
    i = 0
    while i < Unaccepted.length
      output = output.replace new RegExp(Unaccepted.charAt(i),"gm"), accepted.charAt(i)   # RegExp creates a regular expression
      i++                                                                                 # where g = global and m = multiline in                                                                                        # order to remove all unaccepted characters apparences
    output.toLowerCase()  ## every string is lower case
  
  # get facebook user picture
  getPhoto: (userId, callback) ->

    query = "/" + userId + "/picture" 
    FB.api query, "type": "large", (response) -> 
      unless response.error
        callback response.data.url, null
      else
        callback null, response.error 
  
  # get facebook user friends list
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