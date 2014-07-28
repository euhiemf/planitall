

if 'global' in this and 'require' in this
	gui = require 'nw.gui'


	# LiveReload
	path = './'
	fs = require 'fs'

	fs.watch path, ->
		location?.reload()



class GetSet extends Backbone.Model
	initialize: (@model) ->



		@on 'change', =>

			attrs = @changedAttributes()

			if attrs

				for key, val of attrs
					@trigger 'loaded:' + key, val, @model
				







class Plugins extends Backbone.Collection

	initialize: ->


class PluginBluepint extends Backbone.Model

	initialize: ->
		@set 'model', @bpm
		@set 'view', @bpv
		@set 'router', @bpr


	render: (context) ->

		do (context) -> (func, args...) ->
			app.clearer.clear()
			func.apply(context, args)
			app.clearer.add('unset', 'html', '.plugin')


	bpm: class extends Backbone.Model

		'default-blueprint-properties':
			navigatable: false
			submenus: []

		constructor: ->

			number_of_plugins = app.get('plugin').collection.length

			id = "#{Math.random().toString(36).substr(2, 6)}-#{number_of_plugins}"

			dbp = @['default-blueprint-properties']

			dbp.title = "Plugin##{id}"
			dbp.id = id
			dbp.imports = new GetSet(@)

			_.defaults @defaults, dbp


			delete @['default-blueprint-properties']



			Backbone.Model.apply @, arguments

	bpv: class extends Backbone.View
		el: '.plugin'


	bpr: class extends Backbone.Router

		constructor: ->

			# clear constructor prototype
			model = @model
			@model = model


			fullurlroute = {}

			baseurl = 'plugin/view/' + @model.get('id') + '/'

			for key, val of @routes
				fullurlroute[baseurl + key.replace(/(^(\.\/))|(^(\/))/, '')] = val


			@routes = _.clone fullurlroute


			@on 'route', ->
				# app.clearer.clear()

			@on 'route', app.get('navigation').select





			Backbone.Router.apply @, arguments






class Plugin extends Backbone.Model

	local: {}
	global: {}
	localAssets: 
		js: {}
		image: {} 
		stylesheet: {}


	Blueprint: new PluginBluepint

	import: (data) ->
		if not data.local and not data.global then data.local = true

		if data.local
			@local[data.import.name] = data.import

			clear = {}
			clear[data.import.name] = @local
			app.clearer.add('remove', 'object', clear)

		else if data.global
			@global[data.import.name] = data.import

	initialize: ->

		@collection = new Plugins

		@collection.on('add', @memorize, @)

		@on('pre-render', @preRender, @)
		@on('post-render', @postRender, @)



	new: (model) ->

		instance = new model

		@collection.add instance

		view: @view
		router: @router
		model: instance

	view: (view) ->

		model = @model

		instance = new view
			model: model


		ref = instance.render or null

		instance.render = do (ref, instance, model) -> () ->
			app.get('plugin').trigger 'pre-render', model

			retu = ref?.apply(instance, arguments)

			app.get('plugin').trigger 'post-render', model

			return retu


		model.view = instance
		model.view.model = model

		view: @view
		router: @router
		model: model

	router: (router) ->


		router::model = @model

		rinstance = new router

		delete router::model


		@model.router = rinstance


		view: @view
		router: @router
		model: @model

	memorize: (model) ->

		id = model.get 'id'

		@set(id, model)

		ev = 'new'
		if model.get('navigatable') then ev += ':navigatable'
		@trigger(ev, model)

	preRender: (model) ->

		app.clearer.clear()

		$('.plugin').loading().hide()

		@loadAssets model



	postRender: (model) ->
		app.clearer.add('unset', 'html', '.plugin')



	loadAssets: (model) ->

		assets = model.get('assets')


		model.set('assetsLength', 0)
		model.set('loadedAssetsCount', 0)

		for type, value of assets

			args = [type, model]

			if Array.isArray(value) then @load(fname, args...) for fname in value else @load(value, args...)

		model.on 'change:loadedAssetsCount', (m, value) =>
			if value is m.get('assetsLength') then @assetsLoaded(m)



		if model.get('assetsLength') is 0
			@assetsLoaded(model)


	parseImport: (properties, model) ->
		# the script file should at this point have been parsed by the web brwower
		if Array.isArray(properties) then @import arrdata for arrdata in properties else @import properties

		model.set('loadedAssetsCount', model.get('loadedAssetsCount') + 1)


	assetsLoaded: (model) ->
		model.trigger('assetsLoaded')
		$('.plugin').loading(false).show()


	load: (path, type, model) ->




		# IF xhr loads faster than javascript execution, this code will break
		model.set('assetsLength', model.get('assetsLength') + 1)


		ext = path.split('.')
		ext = ext[ext.length - 1].toLowerCase()

		types_parse =
			'js':
				dataType: 'text'
				mime: 'text/javascript'
				parent: 'head'
				template: _.template("<script type='text/javascript' src='<%= url %>' id='plugin-script#<%= id %>'></script>")
				return: 'element'
			'stylesheet':
				dataType: 'text'
				mime: 'text/css'
				parent: 'head'
				template: _.template("<link rel='stylesheet' href='<%= url %>' id='plugin-stylesheet#<%= id %>'>")
				return: 'element'
			'image':
				dataType: ''
				mime: 'image/' + ext
				parent: null
				return: 'url'


		parse = types_parse[type]

		id = model.get('id')

		xhr = $.ajax
			success: do (path, id, model, type, parse) => (data, status, jqXHR) =>
				blob = new Blob [data], 
					type: parse.mime

				values =
					id: id

				values.url = URL.createObjectURL(blob)

				if parse.parent

					html = parse.template(values)

					values.element = $ html

					$.ajaxSetup({ cache: true })
					$(parse.parent).append values.element
					$.ajaxSetup({ cache: false })

					app.clearer.add('remove', 'html', values.element)

				model.get('imports').once('loaded:'+path, @parseImport, @)

				if type isnt 'js'
					model.set 'loadedAssetsCount', model.get('loadedAssetsCount') + 1




				@localAssets[type][path] = values[parse.return]

				app.clearer.add 'remove', 'object', { base: @localAssets[type], key: path }, true


			url: "./plugins/#{id}/#{path}"
			context: @
			dataType: parse.dataType
			isLocal: true
			cache: false









		














class Navigation extends Backbone.View

	el: '.navigation'

	initialize: ->

		app.get('plugin').on('new:navigatable', @addPluginItem, @)

	events:
		'click .submenual': 'liclick'
		'click .nosubmenu': 'liclick'

	liclick: (ev) ->
		if ev.target.tagName is 'LI'
			window.location.hash = $(ev.target).children('a').eq(0).attr('href').substr(1)

		
	select: (page, params) =>

		params = _.without params, null

		@$('ul li.selectable').each ->
			$(@).removeClass('selected')


		url = location.hash.slice(1)

		el = @$("li.selectable[data-selectable-id='#{url}']")

		el.addClass('selected')

	menutemplate: _.template $('#menu-item.navigational').html()

	addItem: (attrs) ->

		attrs.link ?= attrs.id

		attrs.stripLink = (st) ->
			return st.replace(/(^(\.\/))|(^(\/))/, '').replace(/(\/)$/, '')

		attrs.haveSubMenu = attrs.hasOwnProperty('submenus') and attrs.submenus.length > 0

		@$('ul.main-navigation').append @menutemplate(attrs)

	addPluginItem: (model) ->

		@addItem
			id: 'plugin-' + model.get('id')
			title: model.get('title')
			link: 'plugin/view/' + model.get('id')
			submenus: model.get('submenus')








class Views extends Backbone.Model

	initialize: ->

		@set 'home', new View.Home
		@set 'plugins', new View.Plugins
		@set 'calendar', new View.Calendar

		for name, view of @attributes
			ref = view.render or null

			view.render = do (ref, view) -> () ->

				app.get('views').trigger 'will-render', view

				app.clearer.add('unset', 'html', '.content')

				ref?.apply view, arguments




class Clearer
	toclear: []

	add: (action, what, value, additional...) =>
		# [remove, unset, show], [html, object], [DOMElement, Object]

		@toclear.push
			what: what
			value: value
			action: action
			additional: additional




	clear: =>
		whachado = 
			html: @removeHTML
			object: @removeObject

		for ob in @toclear
			whachado[ob.what] ob.value, ob.action, ob.additional...

		@toclear = []

	removeHTML: (element, action) ->
		switch action
			when 'remove' then $(element).remove()
			when 'unset' then $(element).html('')
			when 'show' then $(element).show()

	removeObject: (value, action, keys = false) ->

		if keys
			switch action
				when 'remove' then delete value.base[value.key]
				when 'unset' then value.base[value.key] = null
		else 
			for key, val of value
				switch action
					when 'remove' then delete val[key]
					when 'unset' then val[key] = null







class App extends Backbone.Model

	initialize: ->




	start: ->
		
		@set 'plugin', new Plugin
		
		@set 'navigation', new Navigation

		@set 'views', new Views

	'clearer': new Clearer












class Router extends Backbone.Router

	initialize: ->
		@on 'route', (page, params) ->
			app.get('navigation').select(page, params)


	routes:
		'calendar': 'calendar'
		'plugins': 'plugins'
		'plugin/:action/:id': 'plugins'
		'home': 'home'
		'*anything': 'gohome'

	'calendar': ->

		app.get('views').get('calendar').render()

	'plugins': (action = false, id) ->

		if action is false
			app.get('views').get('plugins').render()

		else if action is 'view'
			app.get('plugin').get(id).view.render()

	'gohome': ->
		@navigate 'home'


	'home': ->

		app.get('views').get('home').render()





class AppView extends Backbone.View

	el: '.app'


	initialize: ->



		# Global instances
		window.router = new Router
		window.app = new App {}
		app.view = @

		app.start()


		@$('.side[type="text/template"]').each(@setupnav)


		app.get('views').on('will-render', app.clearer.clear, @)





	setupnav: (index, elm) =>

		id = elm.id

		app.get('navigation').addItem
			id: id
			title: if elm.dataset.hasOwnProperty('title') then elm.dataset.title else id.substr(0, 1).toUpperCase() + id.substr(1)






new AppView()


$(window).on 'load', ->
	Backbone.history.start()