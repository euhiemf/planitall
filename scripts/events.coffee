

define ['backbone'], (Backbone, clearer) ->

	class Eventer extends Backbone.Model

		initialize: ->

			@on 'all', (ev) ->

				if ev.indexOf(':') < 0 then return

				split = ev.split(':')


				if split[0] is 'render' then @trigger 'render', split[1]

			@on 'render', (file) ->

				requirejs [file, 'cs!app/clearer'], (view, clearer) ->

					clearer.clear location.hash.substr(1)

					view.render()


	new Eventer