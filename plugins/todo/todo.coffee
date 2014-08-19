

define ['jquery', 'backbone', 'cs!plugins/todo/todo-buffer'], ($, Backbone, Buffer) ->


	element = $('.plugin')

	view = new Buffer({ el: element })


	element: element


	render: view.render
	before: do (element) -> ->
		element.hide()
		
	assets:
		css: 'todo'


