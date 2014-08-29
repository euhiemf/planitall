
define ['backbone', 'jquery', 'dot!plugins/task/new.template', 'cs!app/assets', 'cs!app/loading', 'cs!app/clearer'], (Backbone, $, template, Assets, Loading, clearer) -> 
	
	class NewView extends Backbone.View

		events:
			'select .combo-box': (ev, value) ->
				if value is 'Add more...' then router.navigate('plugins/event-type/')

		render: ->


			loading = new Loading()
			loading.render()

			@$el.hide()

			assets = new Assets { css: 'plugins/calendar/calendar' }, 'plugins/task/new'

			assets.onload =>

				@$el.html template()

				@$('.combo-box').combobox()
				@$('.dateselect').dateselect()


				loading.remove()

				@$el.show()

			assets.load()


	class taskview extends Backbone.View

		el: '.plugin'


		pluginClear: ->
			clearer.clear()
			clearer.add 'clear', $('.plugin'), 'plugins/task'

		cacheEl: (cls) ->

			if @$('.' + cls).length
				el = @$('.' + cls)
			else
				el = $('<div class="' + cls + '"></div>')
				@$el.append el

			clearer.add 'clear', el, location.hash.substr(1)

			return el


		rendermain: =>
			# clearer.clear()
			el = @cacheEl('main')
			el.html('this is the main')

		renderlist: ->
			@pluginClear()
			el = @cacheEl('list')
			el.html('this is the list')


		rendernew: ->

			@pluginClear()

			el = @cacheEl('new')


			newView = new NewView { el: el }

			newView.render()






			# tn = new plugin.local.new
			# 	el: @el

			# tn.template = plugin.getasset('template', 'new.template.html')
			# tn.render()






	view = new taskview

	class taskrouter extends Backbone.Router

		routes:
			'plugins/task/list': 'render-list'
			'plugins/task/new': 'render-new'

		'render-list': ->
			view.renderlist()

		'render-new': ->
			view.rendernew()


	new taskrouter


	element: $('.plugin')

	render: view.rendermain




