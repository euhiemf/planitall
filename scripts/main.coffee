requirejs.config
	
	baseUrl: 'lib'



	paths:
		'backbone': 'backbone/backbone'
		'underscore': 'backbone/underscore'
		'backbone.localstorage': 'backbone/backbone.localStorage'
		'jquery': 'jquery/jquery'

		'jquery-private': 'no-conflict/jquery/nc'
		'backbone-private': 'no-conflict/backbone/nc'
		'underscore-private': 'no-conflict/underscore/nc'

		'scripts': 'scripts'



	map:
		'*':
			'jquery': 'jquery-private'
			'backbone': 'backbone-private'
			'underscore': 'underscore-private'

		'jquery-private':
			'jquery': 'jquery'
		'backbone-private':
			'backbone': 'backbone'
		'underscore-private':
			'underscore': 'underscore'

	shim:

		'backbone':
			deps: ['underscore', 'jquery']
			export: 'Backbone'


		'underscore':
			export: '_'

		'backbone.localstorage': ['backbone']

requirejs ['backbone'], (Backbone) ->
	console.log 'loaded', Backbone