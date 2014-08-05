define ['backbone', 'localstorage', 'cs!app/plugin'], (Backbone, LocalStorage, Plugin) ->

	class PluginLoader extends Backbone.Collection

		model: Plugin

		localStorage: new LocalStorage('plugins')


