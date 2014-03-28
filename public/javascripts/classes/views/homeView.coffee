
App.HomeView = Ember.View.extend
	
	templateName: "home"
	isLoggedInBinding: "App.MainController.isLoggedIn"

	isLoggedInDidChanged: ( ->

		unless this.isLoggedIn
			this.set "title", "Welcome To Spell Your Friends"
			this.set "pictureUrl", "images/WhoAreYou.jpg"
	).observes("this.isLoggedIn")

	init: ->

		this._super()
		unless this.isLoggedIn
			this.set "title", "Welcome To Spell Your Friends"
			this.set "pictureUrl", "images/WhoAreYou.jpg"
		else
			this.set "title", "Hi there, " + App.MainController.user.fullname()
			this.set "pictureUrl",  App.MainController.user.picture
	
	actions:

		login: ->
			
			document.getElementById("loading").style.visibility = "visible";
			document.getElementById("button").style.visibility = "hidden";
			
			self = this
			App.MainController.login (data, error) ->
				unless error
					self.set "title", "Hi there, " + data.fullname()
					self.set "pictureUrl", data.picture
				else
					alert JSON.stringify(error)

		logout: ->

			App.MainController.logout()

		goPlay: ->

			this.get("controller").transitionToRoute "play"