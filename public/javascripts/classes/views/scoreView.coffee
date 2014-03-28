
App.ScoreView = Ember.View.extend

	templateName: "score"

	init: ->

		this._super()
		this.set "finalScore", App.MainController.game.score

	actions:
		
		post: ->

			App.MainController.post (error) ->
				unless error
					alert "Congrats! Your score is now posted on Facebook."
				else
					alert JSON.stringify(error)

		goHome: ->

			this.get("controller").transitionToRoute "home"