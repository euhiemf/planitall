define ['backbone', 'cs!plugins/calendar/calendar-buffer', 'jquery', 'moment'], (Backbone, Buffer, $, moment) ->

	# calendar = new Calendar

	# create a jquery plguin here also!

	$.fn.dateselect = do (Buffer) -> ->

		@one 'click', ->

			container = $('<div class="calendar-imported"></div>')

			button = @
			input = $(@).parent().find('.text')

			offset = $(@).offset()

			$(document.body).append container.css
				top: offset.top

			addonBuffer = (new Buffer { el: container }).print()


			offset = $(@).offset()
			container.css 'left', offset.left

			if offset.left + container.outerWidth() > window.innerWidth
				container.css 'margin-left', - container.width() + 1
			

			container.css 'visibility', 'visible'

			listenToClick = ->
				$(window.document).one 'click', hide

			addonBuffer.on 'dateselect', (time, day, month) ->
				dobj = moment time.toString(), 'X'
				input.val dobj.format('Do MMMM YYYY')
				container.hide()



			hide = (ev) ->
				if not $.contains(container[0], ev.target) and not $(button).is(ev.target)
					container.hide()
				else
					listenToClick()


			$(@).on 'click', do (container) -> ->
				container.show()
				listenToClick()
			

			listenToClick()





	element = $('.plugin')

	buffer = new Buffer { el: element }



	element: element
	render: buffer.print

	loading: true

	before: (done) ->

		element.hide()

		done()


	assets:
		css: 'calendar'


