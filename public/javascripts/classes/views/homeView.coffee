
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

		## log in parse width user's facebook data
		login: ->
			
			## updates home template width current user data
			self = this
			App.MainController.login (data, error) ->
				unless error
					self.set "title", "Hi there, " + data.fullname()
					self.set "pictureUrl", data.picture
				else
					alert JSON.stringify(error)

		## log out from Facebook
		## if user is not connected to facebook logout will throw an error. It is neccesary to
		## reload app in order to get a Facebook valid access token
		logout: ->

			confirm = window.confirm "ALERT! YOU WILL BE DISCONNECTED FROM FACEBOOK"
			if confirm
				App.MainController.logout (error) ->
					if error
						location.reload()

		## transition to play route
		goPlay: ->

			this.get("controller").transitionToRoute "play"