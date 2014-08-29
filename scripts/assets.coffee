

### /Syntax/

assets = new Assets { css: 'plugins/calendar/calendar' }, 'plugins/task/new'

assets.onload =>
	
	// Render the html...


assets.load()



###


define ['jquery', 'cs!app/clearer'], ($, clearer) ->

	class Assets

		callbacks: []

		constructor: (@items, @domain, @prepath)->
			@
		onload: (callback) ->

			@callbacks.push(callback)



		callback: =>

			for cb in @callbacks
				cb()


		load: ->

			@length = 0
			@loaded = 0

			for type, paths of @items
				switch type
					when 'css' then @loop @loadCss, paths




			setTimeout @callback, 500
			# @callback()

		loop: (fn, paths) ->

			cb = do (fn) -> (path) =>
				@length++
				fn path, =>
					@loaded++

					if @loaded is @length then @callback()



			if Array.isArray(paths) then cb(path) for path in paths else cb(paths)




		loadCss: (path, callback) =>

			console.log path

			if typeof @prepath is 'undefined' then address = "text!#{path}.css" else address = "text!#{@prepath}/#{path}.css"

			requirejs [address], do (callback) => (content) =>

				blob = new Blob [content], 
					type: 'text/css'


				url = URL.createObjectURL(blob)

				element = $ "<link rel='stylesheet' href='#{url}' class='plugin-stylesheet' id='#{@domain}|#{path}.css'>"

				$.ajaxSetup({ cache: true })
				$('head').append element
				$.ajaxSetup({ cache: false })

				clearer.add('remove', element, @domain)


				callback()




