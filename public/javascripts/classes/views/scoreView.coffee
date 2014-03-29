
## SCORE VIEW - UPDATES SCORE TEMPLATE DATA 

App.ScoreView = Ember.View.extend

	templateName: "score"

	init: ->

		## shows final score in score template
		this._super()
		this.set "finalScore", App.MainController.game.score

	## score template clicks events
	actions:
		
		## posts score to facebook timeline
		post: ->

			App.MainController.post (error) ->
				unless error
					alert "Congrats! Your score is now posted on Facebook."
				else
					alert JSON.stringify(error) + "\n\n APPLICATION WILL BE RELOADED. THEN TRY IT AGAIN."
					App.MainController.set "isLoggedIn", false
					self.get("controller").transitionToRoute "home"

		## transitions to home route
		goHome: ->

			this.get("controller").transitionToRoute "home"