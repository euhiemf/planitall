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

	renderList: -> Plugin.Blueprint.render(@) ->
		@$el.html('<h2>Task new</h2>')

	renderNew: -> Plugin.Blueprint.render(@) ->
		@$el.html """

		<h2>Add a new task</h2>

		<form>

			<div class="input-box">
				<label class='input-title before'>Start from</label>
				<input class='text' type='text'>
				<button class='button dateselect after'></button>
			</div>

			<div class="input-box">
				<label class='input-title before'>End at</label>
				<input class='text' type='text'>
				<button class='button dateselect after'></button>
			</div>


			<div class="combo-box">
				<label class='input-title before'>Type</label>
				<input class='text' type='text'>
				<button class='button dateselect after'></button>
				<ul class='options'>
					<li class='option'>Read</li>
					<li class='option'>Study</li>
					<li class='option'>Do</li>
					<li class='separator'></li>
					<li class='option'>Add more...</li>
				</ul>
			</div>


		</form>

		"""


class TaskRouter extends Plugin.Blueprint.get('router')

	routes:
		'list': 'render-list'
		'new': 'render-new'

	'render-list': ->
		Plugin.get('task').view.renderList()

	'render-new': ->
		Plugin.get('task').view.renderNew()





Plugin.new(Task).view(TaskView).router(TaskRouter)