Plugin = app.get('plugin')

class Task extends Plugin.Blueprint.get('model')

	defaults:
		id: 'task'
		title: 'Tasks'
		navigatable: true
		submenus: [
			{
				link: 'list'
				title: 'Show a list of tasks'
			}
			{
				link: 'new'
				title: 'Create a new'
			}
		]


class TaskView extends Plugin.Blueprint.get('view')

	render: ->
		@$el.html('<h2>Task main</h2>')

	renderList: (what) -> Plugin.Blueprint.render(@) ->
		@$el.html("<h2>Task #{what}</h2>")

	renderNew: -> Plugin.Blueprint.render(@) ->
		@$el.html('<h2>Task new</h2>')


class TaskRouter extends Plugin.Blueprint.get('router')

	routes:
		'list': 'render-list'
		'new': 'render-new'

	'render-list': ->
		Plugin.get('task').view.renderList('list!!!')

	'render-new': ->
		Plugin.get('task').view.renderNew()





Plugin.new(Task).view(TaskView).router(TaskRouter)