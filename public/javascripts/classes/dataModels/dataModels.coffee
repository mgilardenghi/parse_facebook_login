
## DATA MODELS - STORE APPLICATION DATA THAT IS SHOWN IN TEMPLATES

## CURRENT USER DATA
App.userData = Ember.Object.extend
	
	firstname: null
	lastname: null
	picture: null
	friends: null
	
	fullname: ->

		return this.firstname + " " + this.lastname 

## GAME DATA
App.gameData = Ember.Object.extend
	
	picture: null
	counter: null
	score: null

	init: ->

		this.set "counter", 1
		this.set "score", 0