class View.Home extends Backbone.View

	el: '.content'

	template: _.template($('#home').html())

	render: ->

		content = @template({})


		@$el.html content