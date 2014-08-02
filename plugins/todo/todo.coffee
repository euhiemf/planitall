
Plugin = app.get('plugin')
# Plugin.local will get cleared on navigation
# Plugin.global will stay the same all the time


class Todo extends Plugin.Blueprint.get('model')

	defaults: 
		id: 'todo'
		title: "Todo list"
		navigatable: true
		assets: 
			'stylesheet': 'todo.css'
			'js': ['views/item.js']





class TodoView extends Plugin.Blueprint.get('view')

	events:
		'click .add': 'addone'

	initialize: ->
		@render.on 'user-request-main', @renderMain, @


	addone: ->

		items.push({})



	renderMain: -> @render.blit ->

		@$el.html """
		
			<div class="new"><button class="add">Add New</button></div>
			<ol class="items"></ol>

		"""

		itemsView.render()



Plugin.new(Todo).view(TodoView)







	

class Item extends Backbone.Model

	initialize: ->
		@on 'change', =>
			@save()



	defaults:
		title: ''


class Items extends Backbone.Collection

	localStorage: new Store('items')

	model: Item

	initialize: ->

		@fetch()


class ItemsView extends Backbone.View

	initialize: ->


		@collection.on 'add', (model) =>
			@renderOne model, true


	render: ->
		@setElement $('.plugin .items')

		@collection.each (model) =>

			@renderOne model


	renderOne: (model, focus = false) ->


		ItemView = Plugin.local.ItemView


		view = new ItemView
			model: model


		@$el.prepend view.render()

		if focus then view.edit()







items = new Items
itemsView = new ItemsView
	collection: items


