define ->

	{
		navigate: (part) ->

			switch part
				when '../' then 'down'
				else 'same'

		join: (paths...) ->

			parts = []
			start = ''
			end = ''

			for path, index in paths
				# only the last is expected to be a file
				if index is paths.length - 1 and (/\/$/).exec(path)
					end = '/'

				direction = (/[\.\/]*(?=[^\.\/])/).exec(path)
				navigate = @navigate direction 

				if index is 0 then start = direction

				if navigate is 'down' and index isnt 0 then parts.pop()
				
				parts.push path.replace(/^(\/|\.\.\/)/, '').replace(/(\/)$/, '')


			return start + parts.join('/') + end

	}
