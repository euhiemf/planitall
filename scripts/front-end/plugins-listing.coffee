define ['backbone', 'cs!app/clearer'], (Backbone, clearer) ->

	class View extends Backbone.View

		el: '.content'

		initialize: ->
			@


		render: =>

			@$el.html('here are the plugins listed!')

			clearer.add 'clear', @$el, 'plugins'


	new View
