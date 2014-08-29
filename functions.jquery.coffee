define ['jquery'], ($) ->

	$.fn.combobox = ->

		container = @

		options = @find('.options').hide()

		text = @find('.text')

		text.on 'click', =>
			options.show()
			options.width text.outerWidth()
			options.css text.offset()

			$(document).on 'click', (ev) =>
				if not $.contains(@[0], ev.target) then options.hide()


		options.find('.option').on 'click', ->
			val = $(@).text()
			text.val val

			container.trigger('select', val)


			options.hide()







	return $

