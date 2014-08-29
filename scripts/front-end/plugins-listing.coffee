define ['backbone', 'cs!app/clearer', 'cs!app/plugin-loader', 'cs!app/assets', 'jquery'], (Backbone, clearer, plugins, Assets, $) ->

	class View extends Backbone.View

		events:
			'click #new': 'showNew'
			'click #add': 'addNew'
			'keyup #name': (ev) -> if ev.keyCode is 13 then @addNew()
			'click .remove': (ev) ->
				parent = $(ev.currentTarget).parent()
				id = parent.find('.name').data('id')
				# console.log id
				# console.log plugins
				plugins.findWhere({ id: id }).destroy()
				parent.remove()

		el: '.content'

		showNew: ->
			@$('#new').hide()
			@$('#name').show().val('').focus()
			@$('#add').show()

		addNew: ->
			name = @$('#name').hide().val()
			@$('#add').hide()
			@$('#new').show()

			plugins.add { id: name }
			model = plugins.last()
			model.save()

			@$el.append @itemHtml(model.toJSON())




		itemHtml: (plugin) -> "<li><span class='name' data-id='#{plugin.id}'>#{plugin.title}</span><button class='disable'>Disable</button><button class='remove'>Remove</button></li>"


		render: =>

			assets = new Assets { css: 'app/front-end/plugins-listing' }, 'plugins'

			assets.onload =>

				@$el.html '<div class="container"><input type="text" id="name" placeholder="id"><button id="new">Add new plugin</button><button id="add">Add</button></div>'


				for plugin in plugins.toJSON()
					@$el.append @itemHtml(plugin)


			assets.load()



			clearer.add 'clear', @$el, 'plugins'


	new View
