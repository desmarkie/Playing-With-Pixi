class Sketch

	view: null
	cancelled: false
	loaded: false
	renderer: null
	stage: null

	constructor: (@renderer) ->

	load: ->
		# override me
		@cancelled = false
		if !@loaded then requestAnimationFrame @update
		@loaded = true
		@stage.visible = true
		null

	unload: ->
		@cancelled = true
		@stage.visible = false
		null

	update: ->
		requestAnimationFrame @update

		if @cancelled 
			return
		
		null

	resize: ->
		# override me
		null
