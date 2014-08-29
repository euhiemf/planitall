

dependencies = [

	'require'
	'backbone'

	'jquery'

	'cs!app/events'

	'cs!app/plugin-loader'

	'cs!app/clearer'

]

define dependencies, (req) ->

	Backbone = req 'backbone'
	events = req 'cs!app/events'
	pl = req 'cs!app/plugin-loader'
	$ = req 'jquery'

	clearer = req 'cs!app/clearer'

	class Router extends Backbone.Router

		initialize: ->

			events.on 'navigation-rendered', @setupNav, @

			@on 'route', ->

				# clearer.clear location.hash.substr(1)



		setupNav: ->


			nav = req 'cs!app/front-end/navigation'

			events.on 'route', nav.select

			events.trigger('navigation-done')

			nav.select()



		routes:
			'plugins': 'plugins'
			'plugins/:id': 'plugins'
			'home': 'home'
			'*anything': 'gohome'




		'plugins': (id) ->
			if not id then return events.trigger('render:cs!app/front-end/plugins-listing')
			l = pl.findWhere { id: id }
			events.trigger('render-plugin:' + id, l)




		'gohome': ->
			# @navigate 'home'
			window.location.hash = 'home'

		'home': ->
			events.trigger('render:cs!app/front-end/home')

	new Router()