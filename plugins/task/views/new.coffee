class New extends Backbone.View

	events:
		'submit form': (ev) -> ev.preventDefault()
		'click .button.dateselect': 'dateselect'

	render: ->

		@$el.html @template()

	dateselect: (ev) ->

		console.log 'will open dateselect'




app.get('plugin').get('task').get('imports').set 'views/new.js',
	local: true
	import: New