define ['backbone'], (Backbone) ->

	class Plugin extends Backbone.Model

		defaults: {}

		initialize: ->

			# load configs

			requirejs ["text!plugins/#{@get('id')}/config.json"], (data) =>



				@set key, val for key, val of JSON.parse data

				console.log @



