
dependencies = [

	'require',
	'exports',
	'backbone',

	'cs!app/plugin-loader',
	'cs!app/front-end/navigation',
	'cs!app/router'

	'cs!app/events'

	'cs!app/loading'

]



define dependencies, (req, exp) ->

	Backbone = req 'backbone'
	pl = req 'cs!app/plugin-loader'
	nav = req 'cs!app/front-end/navigation'
	router = req 'cs!app/router'
	events = req 'cs!app/events'
	Loading = req 'cs!app/loading'



	pl.on 'eligable-for-nav-render', (model) ->

		nav.addPluginItem model


	pl.on 'configs-loaded', ->

		events.trigger('navigation-rendered')


	pl.on 'plugins-loaded', ->

		events.trigger('plugins-loaded')


	pl.on 'destroy', (model) ->

		nav.removePluginItem model





	pl.fetch()









	class Inst extends Backbone.Model

		initialize: ->

			@set('router', router)



	new Inst()





