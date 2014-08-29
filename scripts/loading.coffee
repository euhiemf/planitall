define ['jquery'], ($) ->

	class Loading

		render: ->


			@element = $('<p>Loading...</p>').css
				'position': 'absolute'
				'top': '50%'
				'left': '50%'
				'width': '200px'
				'margin-left': '-100px'
				'text-align: center'

			$('body').append @element



		remove: =>

			@element.remove()


	return Loading
