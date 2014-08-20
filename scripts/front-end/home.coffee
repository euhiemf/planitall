define ['backbone', 'cs!app/clearer'], (Backbone, clearer) ->


	class View extends Backbone.View

		el: '.content'

		render: ->

			@$el.html('welcome to planitall!')

			clearer.add 'clear', @$el, 'plugins'


	new View