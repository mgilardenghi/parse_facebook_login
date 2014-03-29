
## EMBER APPLICATION
window.App = Ember.Application.create(
	LOG_ACTIVE_GENERATION: true
)
	
## ROUTER - ROUTES MAP
App.Router.map -> 

	this.resource "home", path: "/"
	this.resource "play", path: "/play"
	this.resource "score", path: "/score"