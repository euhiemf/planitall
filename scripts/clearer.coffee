define ['backbone', 'jquery', 'underscore'], (Backbone, jQuery, _) ->
	
	class Clearer extends Backbone.Model

		toclear: []
		toflush: []

		clear: (domain) ->


			for ob, index in _.clone @toclear

				if domain is ob.domain then continue


				switch typeof ob.what
					when 'object' then @cleanseObject ob.action, ob.what
					else ob.what = null

				@toflush.push index


			@flush()

		add: (action, what, domain) ->
			# [String remove, String clear], [Boolean, String, Number, Symbol, Null, Undefined, Function, Object], [String]
			@toclear.push
				action: action
				what: what
				domain: domain

		cleanseObject: (action, object) ->

			type = 'object'

			if object instanceof jQuery then type = 'jquery'
			if object instanceof HTMLElement then type = 'html'
			if object.hasOwnProperty 'key' and object.hasOwnProperty 'base' then type = 'keybase'
			if object is null
				# ADD delete to test, if delete x is false then x = null
				type = 'null'

			switch type

				when 'jquery' then @cleaseJquery arguments...
				when 'html' then @cleanseHTML arguments...
				when 'keybase' then @cleaseKeyBase arguments...


		cleaseJquery: (action, object) ->

			switch action
				when 'remove' then object.remove()
				when 'clear' then object.empty()

		cleanseHTML: (action, object) ->

			switch action
				when 'remove' then jQuery(object).remove()
				when 'clear' then jQuery(object).empty()

		cleaseKeyBase: (action, object) ->

			switch action
				when 'delete' then delete base[key]
				when 'remove' then delete base[key]

				
		flush: ->

			for clear_index in @toflush
				@toclear.splice clear_index, 1

				for ol_clrinx, flush_index in @toflush
					@toflush[flush_index] = ol_clrinx - 1



			@toflush = []	
				
			


	new Clearer

