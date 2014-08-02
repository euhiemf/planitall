

if 'global' in this and 'require' in this
	gui = require 'nw.gui'


	# LiveReload
	path = './'
	fs = require 'fs'

	fs.watch path, ->
		location?.reload()



class PluginScriptImport extends Backbone.Model
	initialize: (@model) ->



		@on 'change', =>


			attrs = @changedAttributes()

			if attrs

				for key, val of attrs
					@trigger 'loaded:' + key, val, @model, key
				





class PluginsSetting extends Backbone.Model

	initialize: ->
		@on 'change', =>
			@save()

		@on 'change:active', =>
			@collection.trigger 'toggle-active', @


class Plugins extends Backbone.Collection

	localStorage: new Store('plugins-settings')

	model: PluginsSetting

	initialize: ->
		@fetch()


	add: (model, options) ->

		filter =
			id: model.get('id')
			title: model.get('title')
			active: true

		Backbone.Collection::add.call this, filter, options


class PluginBluepint extends Backbone.Model

	initialize: ->
		@set 'model', @bpm
		@set 'view', @bpv
		@set 'router', @bpr


	Render: class extends Backbone.Model

		constructor: (@model, @context) ->



		blit: (func, args...) =>

			# clear previouis page
			app.clearer.clear { ignore: ['plugin.' + @model.get('id')] }
			# load assets
			status = @model.get('assets-status')

			# $('.plugin').loading().hide()
			# $('.plugin').loading(false).show()

			# call func


			@model.once 'assets-loaded', =>
				func.apply @context, args
				# add what to clear
				app.clearer.add('unset', 'html', '.plugin')
				app.clearer.add 'execute', 'function', (=> @model.set('assets-status', 0)), { domain: 'plugin.' + @model.get('id') }


			if status is 0 then app.get('plugin').loadAssets @model else if status is 1 then @model.trigger('assets-loaded')


	bpm: class extends Backbone.Model

		'default-blueprint-properties':
			'navigatable': false
			'submenus': []
			'assets-status': 0

		constructor: ->

			number_of_plugins = app.get('plugin').collection.length

			id = "#{Math.random().toString(36).substr(2, 6)}-#{number_of_plugins}"

			dbp = @['default-blueprint-properties']

			dbp.title = "Plugin##{id}"
			dbp.id = id
			dbp.imports = new PluginScriptImport(@)

			_.defaults @defaults, dbp

			delete @['default-blueprint-properties']




			Backbone.Model.apply @, arguments

	bpv: class extends Backbone.View
		el: '.plugin'

		constructor: (options) ->

			Render = app.get('plugin').Blueprint.Render
			@render = new Render(options.model, @)


			Backbone.View.apply @, arguments

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
		template: {}

	getAsset: (type, path) ->
		return @localAssets[type][path]

	Blueprint: new PluginBluepint

	cacheMemory: {}
	inCache: (path) -> 
		_.values(@cacheMemory).indexOf(path) > -1

	cache: (path) ->
		id = Math.random().toString(36).substr(2)
		@cacheMemory[id] = path

		return id

	isAllGlobal: (data) ->

		global = true

		if Array.isArray(data)

			(global = false if @isLocal arrdata) for arrdata in data

		else
			global = @isGlobal(data)

		return global

	isGlobal: (data) ->
		not data.local and data.global
	isLocal: (data) ->
		(not data.local and not data.global) or (data.local and not data.global)

	import: (data, model) ->
		if not data.local and not data.global then data.local = true

		if data.local
			@local[data.import.name] = data.import

			app.clearer.add 'remove', 'object', { base: @local, key: data.import.name }, { domain: 'plugin.' + model.get('id') }

		else if data.global
			if @global.hasOwnProperty(data.import.name)
				console.log 'A key with the name of ' + data.import.name + ' does already exist in global, will not import it!'
			else
				@global[data.import.name] = data.import

	initialize: ->

		@collection = new Plugins


		@collection.on 'toggle-active', (model) =>
			# this model is of type PluginsSetting
			@triggerNav @get(model.get('id'))



	getSettings: (model) =>
		@collection.findWhere({ id: model.get('id') })

	new: (model) ->

		instance = new model

		@collection.add instance

		@memorize(instance)

		view: @view
		router: @router
		model: instance

	view: (view) ->


		model = @model

		instance = new view
			model: model


		model.view = instance
		model.view.model = model

		model.view.listenTo model, 'user-request-main', ->
			@render.trigger 'user-request-main'

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

		@preload(model)

		id = model.get 'id'

		@set(id, model)

		@triggerNav(model)

	preload: (model) ->

		js = model.get('assets')?.js

		if Array.isArray js
			for path in js
				if typeof path isnt 'string'
					if js.preload
						@preloadPath(path.path, model)
		else if typeof js isnt 'undefined'
			if typeof js isnt 'string'
				if js.preload
					@preloadPath(js.path, model)

	preloadPath: (path, model) ->
		if path
			@load(path, 'js', model)



	triggerNav: (model) ->

		ev = 'new'
		if model.get('navigatable') then ev += ':navigatable'
		if @getSettings(model).get('active') is false then ev += ':inactive'

		@trigger(ev, model)


	postRender: (model) ->
		app.clearer.add('unset', 'html', '.plugin')



	loadAssets: (model) ->


		assets = model.get('assets')

		model.set('assetsLength', 0)
		model.set('loadedAssetsCount', 0)


		for type, value of assets

			args = [type, model]

			if Array.isArray(value) then @load(fname, args...) for fname in value else @load(value, args...)

		@listenTo model, 'change:loadedAssetsCount', (m, value) =>
			if value is m.get('assetsLength') then @assetsLoaded(m)



		if model.get('assetsLength') is 0 then @assetsLoaded(model)




	parseImport: (properties, model, path) ->
		# the script file should at this point have been parsed by the web brwower
		if Array.isArray(properties) then @import arrdata, model for arrdata in properties else @import properties, model

		if @isAllGlobal properties then @cache @getUrl(path, model)


		model.set('loadedAssetsCount', model.get('loadedAssetsCount') + 1)


	assetsLoaded: (model) =>

		@stopListening(model, 'change:loadedAssetsCount')

		model.set('assets-status', 1)
		model.trigger('assets-loaded')
		$('.plugin').loading(false).show()



	addLocalAsset: (type, path, what, model) ->
		@localAssets[type][path] = what

		cacheId = @cache @getUrl(path, model)

		app.clearer.add 'remove', 'object', { base: @localAssets[type], key: path }, { domain: 'plugin.' + model.get('id') }
		app.clearer.add 'remove', 'object', { base: @cacheMemory, key: cacheId }, { domain: 'plugin.' + model.get('id') }


	loadfuncs:
		js: (data, id, type, path, model) ->

			blob = new Blob [data], 
				type: 'text/javascript' 

			url = URL.createObjectURL(blob)

			element = $ "<script type='text/javascript' src='#{url}' id='plugin-script##{id}'></script>"

			$.ajaxSetup({ cache: true })
			$('head').append element
			$.ajaxSetup({ cache: false })

			app.clearer.add('remove', 'html', element)

			model.get('imports').once 'loaded:' + path, @parseImport, @

			@addLocalAsset(type, path, element, model)

		stylesheet: (data, id, type, path, model) ->
			blob = new Blob [data], 
				type: 'text/css'


			url = URL.createObjectURL(blob)

			element = $ "<link rel='stylesheet' href='#{url}' id='plugin-stylesheet##{id}'>"

			$.ajaxSetup({ cache: true })
			$('head').append element
			$.ajaxSetup({ cache: false })

			app.clearer.add('remove', 'html', element)


			@addLocalAsset(type, path, element, model)



			model.set 'loadedAssetsCount', model.get('loadedAssetsCount') + 1

		image: (data, id, type, path, model) ->

			ext = path.split('.')
			ext = ext[ext.length - 1].toLowerCase()

			blob = new Blob [data], 
				type: 'image/' + ext

			url = URL.createObjectURL(blob)


			@addLocalAsset(type, path, url, model)

			model.set 'loadedAssetsCount', model.get('loadedAssetsCount') + 1

		template: (data, id, type, path, model) ->

			@addLocalAsset(type, path, _.template(data), model)

			model.set 'loadedAssetsCount', model.get('loadedAssetsCount') + 1


	getUrl: (path, model) ->
		id = model.get('id')
		return "./plugins/#{id}/#{path}"

	load: (path, type, model) ->


		if typeof path isnt 'string' then path = path.path

		url = @getUrl(path, model)

		if @inCache url then return console.log path + ' didnt import, cause cached'

		model.set('assetsLength', model.get('assetsLength') + 1)

		# IF xhr loads faster than javascript execution, this code will break

		id = model.get('id')

		xhr = $.ajax
			success: do (path, id, model, type) => (data, status, jqXHR) =>

				@loadfuncs[type].call @, data, id, type, path, model


			error: do (model) -> (jqXHR, status, error) ->
				# model.set 'assetsLength', model.get('assetsLength') - 1
				$('.plugin').loading(false).show()
				throw new Error("./plugins/#{id}/#{path}")



			url: url
			context: @
			dataType: 'text'
			isLocal: true
			cache: false
			crossDomain: true









		














class Navigation extends Backbone.View

	el: '.navigation'

	initialize: ->

		app.get('plugin').on('new:navigatable', @addPluginItem, @)
		app.get('plugin').on('new:navigatable:inactive', @removePluginItem, @)

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
		attrs.index ?= $('.selectable.nosubmenu, .selectable.submenual').last().data('index') + 1

		attrs.stripLink = (st) ->
			return st.replace(/(^(\.\/))|(^(\/))/, '').replace(/(\/)$/, '')

		attrs.haveSubMenu = attrs.hasOwnProperty('submenus') and attrs.submenus.length > 0

		@$('ul.main-navigation').append @menutemplate(attrs)

	removePluginItem: (model) ->
		@$("#nav-plugin-#{model.get('id')}").remove()

	addPluginItem: (model) ->

		@addItem
			id: 'nav-plugin-' + model.get('id')
			title: model.get('title')
			link: 'plugin/view/' + model.get('id')
			submenus: model.get('submenus')








class Views extends Backbone.Model

	initialize: ->

		@set 'home', new View.Home
		@set 'plugins', new View.Plugins

		for name, view of @attributes
			ref = view.render or null

			view.render = do (ref, view) -> () ->

				app.get('views').trigger 'will-render', view

				app.clearer.add('unset', 'html', '.content')

				ref?.apply view, arguments




class Clearer
	toclear: []
	toflush: []

	add: (action, what, value, options) =>
		# [remove, unset, show], [html, object], [DOMElement, Object]

		@toclear.push
			what: what
			value: value
			action: action
			options: options




	clear: (options) =>
		whachado = 
			html: @removeHTML
			object: @removeObject
			function: @execFunc

		for ob, index in _.clone @toclear

			if options?.ignore?.indexOf(ob.options?.domain) > -1 then continue

			whachado[ob.what].call @, ob.value, ob.action, ob.options, options

			@toflush.push index

		@flush()

	execFunc: (func) ->

		func()


	removeHTML: (element, action) ->
		switch action
			when 'remove' then $(element).remove()
			when 'unset' then $(element).html('')
			when 'show' then $(element).show()


	removeObject: (value, action) ->

		switch action
			when 'remove' then delete value.base[value.key]
			when 'unset' then value.base[value.key] = null



	flush: ->

		for clear_index in @toflush
			@toclear.splice clear_index, 1

			for ol_clrinx, flush_index in @toflush
				@toflush[flush_index] = ol_clrinx - 1



		@toflush = []







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
		'plugins': 'plugins'
		'plugin/:action/:id': 'plugins'
		'home': 'home'
		'*anything': 'gohome'

	'plugins': (action = false, id) ->

		if action is false
			app.get('views').get('plugins').render()

		else if action is 'view'
			app.get('plugin').get(id).trigger('user-request-main')

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
			index: index






new AppView()


$(window).on 'load', ->
	Backbone.history.start()