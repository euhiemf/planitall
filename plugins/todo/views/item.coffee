class ItemView extends Backbone.View

	tagName: 'li'

	initialize: ->

	render: ->

		@$el.append "<p>#{@model.get('title')}</p>"
		@$el.append '<button class="delete">Delete</button>'

	events:
		'click': 'edit'
		'blur p': 'save'
		'keydown p': (ev) ->
			if ev.keyCode is 13
				ev.preventDefault()
				@save()
		'click button': 'remove'

	edit: ->
		@$('p').attr('contenteditable', true).focus()

	save: ->
		@model.set 'title', @$('p').attr('contenteditable', false).text()
		
		if not @model.hasChanged() then @model.save()

	remove: ->
		@model.destroy()
		@$el.remove()


window.itemviewshit = 123


app.get('plugin').get('todo').get('imports').set('views/item.js', [

	{
		local: true
		global: false
		import: ItemView
	}


])



