Plugin = app.get('plugin')

class Task extends Plugin.Blueprint.get('model')

	defaults:
		id: 'task'
		title: 'Tasks'
		navigatable: true


class TaskView extends Plugin.Blueprint.get('view')

	render: ->
		@$el.html('This is a <h2>task</h2> list')




Plugin.new(Task).view(TaskView)