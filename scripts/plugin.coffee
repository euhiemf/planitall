define ['backbone', 'cs!path', 'cs!app/clearer', 'cs!app/events', 'cs!app/assets'], (Backbone, path, clearer, events, Assets) ->

	class Plugin extends Backbone.Model

		defaults:
			submenus: []

		initialize: ->

			# load configs


			requirejs ["text!plugins/#{@get('id')}/config.json"], (data) =>

				@set key, val for key, val of JSON.parse data

				@parseConfig()

				@trigger('config-loaded', @)


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


			@collection.numberOfPlugins++

			@load main, prepath

		load: (path, prepath) ->

			requirejs [path], do (prepath) => (plugin) =>


				# view.setElement $('.plugin')

				render = do (plugin, prepath) -> () ->

					clearer.clear(prepath)

					assets = new Assets(plugin.assets, prepath)

					isf = (what, cb) ->
						if typeof plugin[what] is 'function' then cb(what)

					isf 'onload', -> assets.onload plugin.onload
					isf 'render', -> assets.onload plugin.render
					isf 'before', -> plugin.before()

					assets.load()

					clearer.add('clear', plugin.element, prepath)


				events.on 'render-plugin:' + @get('id'), render

				@trigger('plugin-loaded')


				# plugin.render()







