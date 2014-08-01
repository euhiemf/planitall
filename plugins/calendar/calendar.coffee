
Plugin = app.get('plugin')

class Calendar extends Plugin.Blueprint.get('model')

	defaults:
		id: 'calendar'
		title: 'Calendar'
		navigatable: true
		assets:
			'stylesheet': 'calendar.css'
			'template': 'calendar.template.html'




class CalendarView extends Plugin.Blueprint.get('view')

	# template: _.template($('#calendar').html())

	render: ->

		@listenToOnce @model, 'assetsLoaded', =>
			@template = Plugin.getAsset('template', 'calendar.template.html')
			# console.log @template
			@printCalendar()


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