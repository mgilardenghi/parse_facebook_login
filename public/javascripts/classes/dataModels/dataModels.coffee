
App.userData = Ember.Object.extend
	
	firstname: null
	lastname: null
	picture: null
	friends: null
	
	fullname: ->

		return this.firstname + " " + this.lastname 

App.gameData = Ember.Object.extend
	
	picture: null
	counter: null
	score: null

	init: ->

		this.set "counter", 1
		this.set "score", 0