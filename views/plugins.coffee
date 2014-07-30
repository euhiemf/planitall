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



	events:
		'click .toggle-state': (ev) ->
			el = $ ev.currentTarget
			id = el.data 'for'

			settings = app.get('plugin').collection.findWhere({ id: id })
			new_status = !settings.get('active')

			settings.set 'active', new_status

			el.html if new_status then 'Inactivate' else 'Activate'

