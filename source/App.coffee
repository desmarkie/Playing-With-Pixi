# import sketches.*
# import views.*
# import PWPData
# import utils.Timer
class App

	sketches: null

	data: null

	currentSketch: 0
	numSketches: null

	liveSketch: null

	textures: null

	infoButton: null
	menuButton: null
	menuOpen: false
	infoOpen: true

	infoPanel: null
	menuPanel: null

	stageColor: 0x0a0a0a

	spacePressed: false

	degToRad: Math.PI / 180
	radToDeg: 180 / Math.PI

	constructor: ->
		@data = new PWPData().data;

		@renderer = PIXI.autoDetectRenderer window.innerWidth, window.innerHeight
		@stage = new PIXI.Stage @stageColor

		document.body.appendChild @renderer.view

		@textures = [PIXI.Texture.fromImage('img/node.png')]

		@sketches = []
		for i in @data
			@sketches.push {sketch:new i.className(@renderer, i.classId), id:i.classId}

		@numSketches = @sketches.length
		@currentSketch = @sketches.length - 1

		@sketchHolder = new PIXI.DisplayObjectContainer()
		@bg = new PIXI.Graphics()
		@bg.beginFill @stageColor
		@bg.drawRect 0, 0, window.innerWidth, window.innerHeight
		@bg.endFill()
		@sketchHolder.addChild @bg

		@menuPanel = new Menu(this, @data)

		@stage.addChild @sketchHolder
		@sketchHolder.addChild @menuPanel.view

		@tab = PIXI.Sprite.fromImage 'img/menu.png'
		@tab.pivot.y = 64
		@tab.position.x = -64
		@tab.position.y = window.innerHeight
		@stage.addChild @tab
		@tab.mouseup = @menuPanel.show
		@tab.interactive = true

		@pointerPosition = {x:window.innerWidth*0.5, y:window.innerHeight*0.5}
		@mousePressed = false

		@enableObject @sketchHolder
		@sketchHolder.hitArea = new PIXI.Rectangle 0, 0, window.innerWidth, window.innerHeight

		if Modernizr.touch
			@tab.tap = =>
				TweenMax.killTweensOf @tab.position
				TweenMax.to @tab.position, 0.3, {x:-64, ease:Power4.easeOut, onComplete: =>
					@menuPanel.show()
				}
				null
		else
			@tab.mouseup = =>
				TweenMax.killTweensOf @tab.position
				TweenMax.to @tab.position, 0.3, {x:-64, ease:Power4.easeOut, onComplete: =>
					@menuPanel.show()
				}
				null

		window.onresize = =>
			@menuPanel.resize()
			@renderer.resize window.innerWidth, window.innerHeight
			@bg.clear()
			@bg.beginFill @stageColor
			@bg.drawRect 0, 0, window.innerWidth, window.innerHeight
			@bg.endFill()
			@sketchHolder.hitArea = new PIXI.Rectangle 0, 0, window.innerWidth, window.innerHeight
			for sketch in @sketches
				sketch.sketch.resize()
			null

		@init()

		requestAnimationFrame @update

		# @touchTimer = new Timer()


	enableObject: (target) ->
		target.interactive = true

		if !Modernizr.touch
			target.mousemove = @handleMove
			target.mousedown = @handleStart
			target.mouseup = @handleEnd
			target.mouseupoutside = @handleEnd
		else
			target.touchstart = @handleStart
			target.touchend = @handleEnd
			target.touchmove = @handleMove
		null

	handleStart: (e) =>
		# @touchTimer.reset()
		@mousePressed = true
		@pointerPosition.x = e.global.x
		@pointerPosition.y = e.global.y
		null

	handleEnd: (e) =>
		# console.log 'handleEnd', @menuPanel.isOpen, e.target is @sketchHolder
		@mousePressed = false
		if @menuPanel.isOpen
			@selectSketch @menuPanel.currentButton.id
			@menuPanel.hide()
			TweenMax.to @tab.position, 0.3, {x:0, ease:Power4.easeOut, delay:0.3}
		null

	handleMove: (e) =>
		@pointerPosition.x = e.global.x
		@pointerPosition.y = e.global.y
		null

	init: =>
		window.onkeyup = @handleKeyPress
		null


	handleInfoClick: =>
		if @menuOpen then @handleMenuClick()
		@infoOpen = !@infoOpen
		if @infoOpen
			@infoPanel.show()
		else
			@infoPanel.hide()
		null

	handleMenuClick: =>
		if @infoOpen then @handleInfoClick()
		@menuOpen = !@menuOpen
		if @menuOpen
			@menuPanel.show()
			TweenMax.to @infoButton, 0.5, {css:{color:'#e3e3e3'}, ease:Power4.easeOut}
		else
			@menuPanel.hide()
			TweenMax.to @menuButton, 0.5, {css:{color:'#e3e3e3'}, ease:Power4.easeOut}
			TweenMax.to @infoButton, 0.5, {css:{color:'#e3e3e3'}, ease:Power4.easeOut}
		null

	handleInterfaceOut: (e) =>
		TweenMax.to e.target, 2, {css:{color:'#e3e3e3'}, ease:Power4.easeOut}
		null

	handleInterfaceOver: (e) =>
		TweenMax.to e.target, 0.15, {css:{color:'rgb(255, 0, 61)'}, ease:Power4.easeOut}
		null

	handleKeyPress: (e) =>
		e.preventDefault()

		unicode = if e.keyCode then e.keyCode else e.charCode

		if unicode is 37
			@prev()
		else if unicode is 39
			@next()
		else if unicode is 32
			@spacePressed = true

		null

	next: =>
		lastSketch = @sketches[@currentSketch]
		@changeSketch('next')
		@unloadSketch(lastSketch.sketch)
		@menuPanel.updateInfoContent()
		null

	prev: =>
		lastSketch = @sketches[@currentSketch]
		@changeSketch('prev')
		@unloadSketch(lastSketch.sketch)
		@menuPanel.updateInfoContent()
		null

	selectSketch: (id) =>
		return if id is @currentSketch
		lastSketch = @sketches[@currentSketch]
		@currentSketch = id
		@unloadSketch(lastSketch.sketch)
		null


	unloadSketch: (sketch) ->
		if sketch.gui != null
			TweenMax.to sketch.gui.domElement, 0.3, {css:{opacity:0}, ease:Power4.easeOut}
		TweenMax.to sketch.view, 1, { alpha:0, ease:Power4.easeOut, onComplete:@removeGui, onCompleteParams:[sketch]}
		null

	removeGui: (sketch) =>
			sketch.unload()
			@sketchHolder.removeChild sketch.view
			if sketch.gui != null
				document.body.removeChild sketch.gui.domElement

			@loadCurrentSketch()
		null

	changeSketch: (dir) ->
		if dir is 'next' then @currentSketch++
		else if dir is 'prev' then @currentSketch--

		if @currentSketch == @sketches.length then @currentSketch = 0
		else if @currentSketch < 0 then @currentSketch = @sketches.length - 1

		null

	loadCurrentSketch: ->
		@sketches[@currentSketch].sketch.load()
		@sketches[@currentSketch].sketch.view.alpha = 0
		@sketchHolder.addChildAt @sketches[@currentSketch].sketch.view, 1
		if @sketches[@currentSketch].sketch.gui != null
			@sketches[@currentSketch].sketch.gui.domElement.style.opacity = 0
			document.body.appendChild @sketches[@currentSketch].sketch.gui.domElement
			TweenMax.to @sketches[@currentSketch].sketch.gui.domElement, 0.3, {css:{opacity:1}, ease:Power4.easeOut, delay:0.5}
		TweenMax.to @sketches[@currentSketch].sketch.view, 1, { alpha:1, ease:Power4.easeOut }
		# console.log 'LOADING SKETCH '+@sketches[@currentSketch].sketch
		null

	update: =>
		requestAnimationFrame @update

		@menuPanel.update()

		if @sketches[@currentSketch].sketch.loaded
			@sketches[@currentSketch].sketch.update()

		@renderer.render @stage

		null

	

