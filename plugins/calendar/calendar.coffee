define ['backbone', 'cs!plugins/calendar/calendar-buffer', 'jquery'], (Backbone, Buffer, $) ->

	# calendar = new Calendar

	element = $('.plugin')

	buffer = new Buffer({ el: element })


	element: element
	render: buffer.print
	assets:
		css: 'calendar'


