
(($)->

	$.fn.loading = (enable = true) ->

		if enable

			@css('visibility', 'hidden')

			offset = @offset()

			styleJSON =
				'position': 'absolute'
				'top': "#{offset.top}px"
				'left': "#{offset.left}px"
				'width': "#{@outerWidth()}px"
				'height': "#{@outerHeight()}px"
				'text-align': 'center'
				'display': 'table'



			style = ""

			for key, val of styleJSON
				style += "#{key}: #{val}; "


			$(document.body).append """

				<div style="#{style}" class='loading-overlay'>
					<p style='display: table-cell'>
						Loading...
					</p>
				</div>

			"""
		else

			$('.loading-overlay').remove()
			@css('visibility', 'visible')


		return @

)(jQuery)
