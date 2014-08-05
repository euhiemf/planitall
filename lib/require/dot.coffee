define
	load: (name, req, callback, config) ->

		req ["text!#{name}.dotjs", 'dotjs'], (content, dot) ->

			callback dot.template(content)
