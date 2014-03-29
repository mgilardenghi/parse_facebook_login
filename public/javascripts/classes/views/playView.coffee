
## PLAY VIEW - UPDATES PLAY TEMPLATE DATA

App.PlayView = Ember.View.extend
	
	templateName: "play"

	## boolean that checks if last user's friend has already been shown
	isLastFriend: false

	init: ->

		## shows first user friend data when rendered play route
		## creates game model data in order to save friends counter and score
		this._super()
		App.MainController.set "game", App.gameData.create()
		this.updateFriend()

	updateFriend: ->

		## updates play template width user's friend data
		self = this
		App.MainController.getPhoto (error) ->
			unless error
				self.set "title", "Friend N° " + App.MainController.game.counter + "/10: Spell My First Name"
				self.set "pictureURL", App.MainController.game.picture
				self.set "inputName", ""
				console.log "\nReal Name: " + App.MainController.user.friends[App.MainController.random].first_name
			else
				alert JSON.stringify(error)
				App.MainController.set "isLoggedIn", false
				self.get("controller").transitionToRoute "home"

	## play template clicks events
	actions:

		## shows next friend
		nextFriend: ->

			self = this
			App.MainController.updateScore this.inputName, (gameOver) ->
				unless gameOver
					self.updateFriend()
				else
					self.set "isLastFriend", true
					console.log "\nGAME OVER!"

		## transition to score route
		goScore: ->
    	
			this.set "isLastFriend", false
			this.get("controller").transitionToRoute "score"