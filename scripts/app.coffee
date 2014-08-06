
dependencies = ['require', 'exports', 'backbone', 'cs!app/plugin-loader', 'cs!app/front-end/navigation', 'cs!app/router']

define dependencies, (req, exp) ->

	Backbone = req 'backbone'
	PluginLoader = req 'cs!app/plugin-loader'
	Navigation = req 'cs!app/front-end/navigation'
	Router = req 'cs!app/router'


	nav = new Navigation

	pl = new PluginLoader


	pl.on 'config-loaded', (model) ->

		nav.addPluginItem model




	pl.fetch()

	router = new Router()





	class Inst extends Backbone.Model

		initialize: ->

			@set('plugin-loader', pl)
			@set('navigation', nav)
			@set('router', router)

			# router.test()

			setTimeout router.test, 200



	Backbone.history.start();
	new Inst()





