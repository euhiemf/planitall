class View.Plugins extends Backbone.View
	el: '.content'

	template: _.template($('#plugins').html())

	render: =>

		if document.readyState is 'loading'
			$(window).on 'load', @render
			return





		content = @template
			list: app.get('plugin').collection.toJSON()

		@$el.html content


	initialize: ->

		app.get('plugin').on 'new', @listplugin


	listplugin: (model) ->

		# console.log(model.get('name'))
