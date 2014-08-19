define ['jquery', 'cs!app/clearer'], ($, clearer) ->

	class Assets

		constructor: (@items, @domain)->
			@
		onload: (@callback) ->
			@




		load: ->

			@length = 0
			@loaded = 0

			for type, paths of @items
				switch type
					when 'css' then @loop @loadCss, paths




			@callback()

		loop: (fn, paths) ->

			cb = do (fn) -> (path) =>
				@length++
				fn path, =>
					@loaded++

					if @loaded is @length then @callback()



			if Array.isArray(paths) then cb(path) for path in paths else cb(paths)




		loadCss: (path, callback) =>


			requirejs ["text!#{@domain}/#{path}.css"], do (callback) => (content) =>

				blob = new Blob [content], 
					type: 'text/css'


				url = URL.createObjectURL(blob)

				element = $ "<link rel='stylesheet' href='#{url}' class='plugin-stylesheet' id='#{@domain}|#{path}.css'>"

				$.ajaxSetup({ cache: true })
				$('head').append element
				$.ajaxSetup({ cache: false })

				clearer.add('remove', element, @domain)


				callback()




