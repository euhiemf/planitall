
(($)->

	$.fn.loading = (enable = true) ->

		if enable

			@css('visibility', 'hidden')

			offset = @offset()

			additional = {}

			if offset.top is 0 then offset.top = window.innerHeight / 2
			if offset.left is 0
				offset.left = window.innerWidth / 2
				additional['margin-left'] = "-45px"
				additional['margin-top'] = "0"


			styleJSON =
				'position': 'absolute'
				'top': "#{offset.top}px"
				'left': "#{offset.left}px"
				'width': "#{@outerWidth()}px"
				'height': "#{@outerHeight()}px"
				'text-align': 'center'
				'display': 'table'

			_.extend styleJSON, additional

			style = ""


			for key, val of styleJSON
				style += "#{key}: #{val}; "

			element = $ """

				<div style="#{style}" class='loading-overlay'>
					<p style='display: table-cell'>
						Loading...
					</p>
				</div>

			"""
			$(document.body).append element

			app.clearer.add('remove', 'html', element)

		else

			$('.loading-overlay').remove()
			@css('visibility', 'visible')


		return @

)(jQuery)
