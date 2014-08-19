define ['backbone', 'localstorage', 'cs!app/plugin'], (Backbone, LocalStorage, Plugin) ->

	class PluginLoader extends Backbone.Collection

		model: Plugin

		localStorage: new LocalStorage('plugins')


		initialize: ->

			@loadedConfigs = 0
			@loadedPlugins = 0
			@numberOfPlugins = 0

			@on 'add', (model) =>

				model.once 'config-loaded', (model) =>

					model.trigger('eligable-for-nav-render', model)


					@loadedConfigs++

					if @loadedConfigs is @length then @trigger('configs-loaded')

				model.once 'plugin-loaded', (model) =>

					@loadedPlugins++

					if @loadedPlugins is @numberOfPlugins then @trigger('plugins-loaded')

					# nav.addPluginItem model
		

	new PluginLoader()
