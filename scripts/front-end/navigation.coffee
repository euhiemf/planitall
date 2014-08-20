define ['backbone', 'underscore', 'jquery', 'dot!app/front-end/menu-item'], (Backbone, _, $, menuItemTemplate) ->

	class Navigation extends Backbone.View

		el: '.navigation'

		initialize: ->

			# app.get('plugin').on('new:navigatable', @addPluginItem, @)
			# app.get('plugin').on('new:navigatable:inactive', @removePluginItem, @)

		events:
			'click .submenual': 'liclick'
			'click .nosubmenu': 'liclick'

		liclick: (ev) ->
			if ev.target.tagName is 'LI'
				window.location.hash = $(ev.target).children('a').eq(0).attr('href').substr(1)

			
		select: =>

			@$('ul li.selectable').each ->
				$(@).removeClass('selected')


			url = location.hash.slice(1)

			el = @$("li.selectable[data-selectable-id='#{url}']")

			el.addClass('selected')

		menutemplate: menuItemTemplate

		addItem: (attrs) ->

			attrs.link ?= attrs.id
			attrs.index ?= $('.selectable.nosubmenu, .selectable.submenual').last().data('index') + 1

			attrs.stripLink = (st) ->
				return st.replace(/(^(\.\/))|(^(\/))/, '').replace(/(\/)$/, '')

			attrs.haveSubMenu = attrs.hasOwnProperty('submenus') and attrs.submenus.length > 0

			@$('ul.main-navigation').append @menutemplate(attrs)

		removePluginItem: (model) ->
			@$("#nav-plugin-#{model.get('id')}").remove()

		addPluginItem: (model) ->

			@addItem
				id: 'nav-plugin-' + model.get('id')
				title: model.get('title')
				link: 'plugins/' + model.get('id')
				submenus: model.get('submenus')

	new Navigation()