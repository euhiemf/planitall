Plugin = app.get('plugin')

class Task extends Plugin.Blueprint.get('model')

	defaults:
		id: 'task'
		title: 'Tasks'
		navigatable: true
		assets:
			template: 'new.template.html'

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

	initialize: ->

		@render.on('user-request-main', @renderMain, @)

	renderMain: -> @render.blit ->
		@$el.html('<h2>Task main</h2>')

	renderList: -> @render.blit ->
		@$el.html('<h2>Task list</h2>')

	renderNew: -> @render.blit ->
		template = Plugin.getAsset('template', 'new.template.html')
		@$el.html template()


class TaskRouter extends Plugin.Blueprint.get('router')

	routes:
		'list': 'render-list'
		'new': 'render-new'

	'render-list': ->
		Plugin.get('task').view.renderList()

	'render-new': ->
		Plugin.get('task').view.renderNew()





Plugin.new(Task).view(TaskView).router(TaskRouter)