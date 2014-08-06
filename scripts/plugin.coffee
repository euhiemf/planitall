define ['backbone', 'cs!path'], (Backbone, path) ->

	class Plugin extends Backbone.Model

		defaults:
			submenus: []

		initialize: ->

			# load configs


			requirejs ["text!plugins/#{@get('id')}/config.json"], (data) =>

				@set key, val for key, val of JSON.parse data

				@parseConfig()

				@collection.trigger('config-loaded', @)


		parseConfig: ->

			main = @get('main')

			if not main then return

			pluginregex = /[^!]*!/
			plugin = pluginregex.exec main

			if plugin
				main = main.replace pluginregex, ''
				plugin = plugin[0]


			prepath = "plugins/#{@get('id')}"

			main = plugin + path.join prepath, main

			@load main

		load: (path) ->

			console.log path
			# requirejs [path]







