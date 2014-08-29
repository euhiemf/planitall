

### /Syntax/

return 
	render: [Function]
	before: [Function] (done) ->
		done()
	assets:
		css: 'relative path to css'

	element: [DomElement]


###



define ['backbone', 'cs!path', 'cs!app/clearer', 'cs!app/events', 'cs!app/assets', 'cs!app/loading'], (Backbone, path, clearer, events, Assets, Loading) ->

	class Plugin extends Backbone.Model

		defaults:
			submenus: []

		initialize: ->

			# load configs

			if typeof @get('title') is 'undefined' then @set 'title', @get('id')[0].toUpperCase() + @get('id').substr(1)


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

					assets = new Assets(plugin.assets, prepath, prepath)

					isf = (what, cb) ->
						if typeof plugin[what] is 'function'
							cb(what)
							return true
						else
							return false

					setloads = do (isf, assets, plugin) -> ->
						isf 'onload', -> assets.onload plugin.onload
						isf 'render', -> assets.onload plugin.render

					haveBefore = isf 'before', do(setloads, plugin) -> -> plugin.before(setloads)

					if not haveBefore then setloads()

					
					if plugin.loading
						loading = new Loading()
						loading.render()
						assets.onload loading.remove

					assets.load()

					clearer.add('clear', plugin.element, prepath)


				events.on 'render-plugin:' + @get('id'), render

				@trigger('plugin-loaded')


				# plugin.render()







