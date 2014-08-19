define ['backbone', 'moment', 'dot!plugins/calendar/calendar'], (Backbone, moment, template) ->

	class Calendar extends Backbone.View

		initialize: ->
			# console.log @$el.html

		print: =>

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


			content = template
				rows: rows
				title: first_date.format('MMMM')
				month: first_date.month()
				moment: moment


			@$el.html content



