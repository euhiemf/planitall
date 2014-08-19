define ['jquery', 'backbone', 'cs!plugins/todo/views/item'], ($, Backbone, ItemView) ->

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


			view = new ItemView
				model: model


			@$el.prepend view.render()

			if focus then view.edit()




			
	items = new Items
	itemsView = new ItemsView
		collection: items




	class TodoView extends Backbone.View

		events:
			'click .add': 'addone'


		addone: ->

			items.push({})

		render: =>

			@$el.show()

			@$el.html """
			
				<div class="new"><button class="add">Add New</button></div>
				<ol class="items"></ol>

			"""

			itemsView.render()
