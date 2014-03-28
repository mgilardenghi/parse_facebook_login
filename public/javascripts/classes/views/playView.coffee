
App.PlayView = Ember.View.extend
	
	templateName: "play"
	isLastFriend: false

	init: ->

		this._super()
		App.MainController.set "game", App.gameData.create()
		this.updateFriend()

	updateFriend: ->

		self = this
		App.MainController.getPhoto (error) ->
			unless error
				self.set "title", "Friend N° " + App.MainController.game.counter + "/10: Spell My First Name"
				self.set "pictureURL", App.MainController.game.picture
				self.set "inputName", ""
				console.log "\nReal Name: " + App.MainController.user.friends[App.MainController.random].first_name
			else
				alert JSON.stringify(error)

	actions:

		nextFriend: ->

			self = this
			App.MainController.updateScore this.inputName, (gameOver) ->
				unless gameOver
					self.updateFriend()
				else
					self.set "isLastFriend", true
					console.log "\nGAME OVER!"

		goScore: ->
    	
			this.set "isLastFriend", false
			this.get("controller").transitionToRoute "score"