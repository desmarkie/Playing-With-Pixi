class Sketch

	constructor: (@renderer, @name) ->
		@view = new PIXI.DisplayObjectContainer()
		@cancelled = false
		@loaded = false
		@stage = null
		@gui = null

	load: ->
		# override me
		@cancelled = false
		# requestAnimationFrame @update
		@loaded = true
		null

	unload: ->
		@cancelled = true
		null

	update: ->
		if @cancelled 
			return
		null

	resize: ->
		# override me
		null

	makeGui: ->
		@gui = new dat.GUI({autoPlace:false})
		@gui.domElement.style.zIndex = 100
		@gui.domElement.style.position = 'absolute'
		@gui.domElement.style.top = 0
		@gui.domElement.style.left = 0
		@gui.domElement.style.height = 'auto'
		@gui.close()
		null
