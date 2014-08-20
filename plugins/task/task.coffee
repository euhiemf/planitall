
define ['backbone', 'jquery'], (Backbone, $) -> 

	class taskview extends Backbone.View

		el: '.plugin'

		rendermain: =>
			@$el.html('<h2>task main</h2>')

		renderlist: ->
			@$el.html('<h2>task list</h2>')

		rendernew: ->

			@$el.html('<h2>task new</h2>')

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




