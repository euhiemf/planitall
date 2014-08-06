define ['require', 'exports', 'backbone', 'cs!app/app'], (req, exp) ->

	Backbone = req 'backbone'

	class Router extends Backbone.Router

		initialize: ->
			@on 'route', (page, params) ->

				# instances = req 'cs!app/app'
				# console.log instances
				console.log 'navigating to', page


		test: ->

			instances = req 'cs!app/app'
			console.log instances

		routes:
			'plugins': 'plugins'
			'plugin/:action/:id': 'plugins'
			'home': 'home'
			'*anything': 'gohome'

		'plugins': ->
			# app.get('views').get('plugins').render()
			console.log 'will render plugins'



		'plugin': (action, id) ->
			console.log 'will', action, 'with', id


		'gohome': ->
			@navigate 'home'

		'home': ->

			# app.get('views').get('home').render()
			console.log 'will render home'