
## HOME VIEW - UPDATES HOME TEMPLATE DATA

App.HomeView = Ember.View.extend
	
	templateName: "home"

	## references the controller 'isLoggedIn' variable
	isLoggedInBinding: "App.MainController.isLoggedIn"

	## checks for isLoggedIn variable changes
	isLoggedInDidChanged: ( ->

		## if user clicks logout button, home template is updated with default data
		unless this.isLoggedIn
			this.set "title", "Welcome To Spell Your Friends"
			this.set "pictureUrl", "images/WhoAreYou.jpg"
	).observes("this.isLoggedIn")

	init: ->

		## if user has logged in, home template shows current user data else default data
		this._super()
		unless this.isLoggedIn
			this.set "title", "Welcome To Spell Your Friends"
			this.set "pictureUrl", "images/WhoAreYou.jpg"
		else
			this.set "title", "Hi there, " + App.MainController.user.fullname()
			this.set "pictureUrl",  App.MainController.user.picture
	
	## home template click events
	actions:

		## login parse width user's facebook data
		login: ->
			
			## shows loading gif
			document.getElementById("loading").style.visibility = "visible";
			document.getElementById("button").style.visibility = "hidden";
			
			## updates home template width current user data 
			self = this
			App.MainController.login (data, error) ->
				unless error
					self.set "title", "Hi there, " + data.fullname()
					self.set "pictureUrl", data.picture
				else
					alert JSON.stringify(error)

		## log out of parse
		logout: ->

			App.MainController.logout()

		## transition to play route
		goPlay: ->

			this.get("controller").transitionToRoute "play"