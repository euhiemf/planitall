
Plugin = app.get('plugin')

class Calendar extends Plugin.Blueprint.get('model')

	defaults:
		id: 'calendar'
		title: 'Calendar'
		navigatable: true
		assets:
			'stylesheet': 'calendar.css'
			'template': 'calendar.template.html'
			'js':
				path: 'calendar-buffer.js'
				preload: true




class CalendarView extends Plugin.Blueprint.get('view')

	initialize: ->
		@render.on('user-request-main', @renderMain, @)

	renderMain: -> @render.blit ->

		buffer = new Plugin.global.Calendar {el: @el}
		# buffer.print()




	printCalendar: ->

		rows = []

		mominst = moment().startOf('month')

		first_date = mominst.clone().startOf('month')
		last_date = mominst.clone().endOf('month')


		mominst.day(0)
		while true

			row =
				title: mominst.format('w')
				cols: []

			for i in [0..6]

				row.cols.push
					value: mominst.format('D')
					attributes: {
						stamp: mominst.format('X')
						month: mominst.month()
					}

				mominst.add(1, 'day')



			rows.push(row)

			if mominst.isAfter(last_date) then break


		content = @template
			rows: rows
			title: first_date.format('MMMM')
			month: first_date.month()


		@$el.html content




Plugin.new(Calendar).view(CalendarView)

