# import sketches.*
# import views.*
# import PWPData
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

		@textures = [PIXI.Texture.fromImage('img/node.png')]

		@sketches = []
		for i in @data
			@sketches.push {sketch:new i.className(@renderer), id:i.classId}

		@numSketches = @sketches.length
		# @currentSketch = @sketches.length - 1

		@interface = document.getElementById('interface')

		@infoButton = document.getElementById('info-button')
		@infoButton.onmouseover = @handleInterfaceOver
		@infoButton.onmouseout = @handleInterfaceOut
		@infoButton.onclick = @handleInfoClick

		@menuButton = document.getElementById('menu-button')
		@menuButton.onmouseover = @handleInterfaceOver
		@menuButton.onmouseout = @handleInterfaceOut
		@menuButton.onclick = @handleMenuClick

		@menuPanel = new Menu(this, @data)
		@infoPanel = new InfoPanel()

		@menuPanel.enable()

		window.onresize = =>
			@infoPanel.resize()
			@renderer.resize window.innerWidth, window.innerHeight
			for sketch in @sketches
				sketch.sketch.resize()

		@init()

	init: =>
		
		# @loadCurrentSketch()

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
		if @infoOpen then @handleInfoClick()
		lastSketch = @sketches[@currentSketch]
		@changeSketch('next')
		@unloadSketch(lastSketch.sketch)
		@menuPanel.updateInfoContent()
		null

	prev: =>
		if @infoOpen then @handleInfoClick()
		lastSketch = @sketches[@currentSketch]
		@changeSketch('prev')
		@unloadSketch(lastSketch.sketch)
		@menuPanel.updateInfoContent()
		null

	selectSketch: (id) =>
		lastSketch = @sketches[@currentSketch]
		@currentSketch = id
		@unloadSketch(lastSketch.sketch)
		@menuPanel.updateInfoContent()
		null


	unloadSketch: (sketch) ->
		TweenMax.to sketch.view, 1, { css:{ opacity:0 }, ease:Power4.easeOut, onComplete: =>
			sketch.unload()
			@loadCurrentSketch()
		}
		null

	changeSketch: (dir) ->
		if dir is 'next' then @currentSketch++
		else if dir is 'prev' then @currentSketch--

		if @currentSketch == @sketches.length then @currentSketch = 0
		else if @currentSketch < 0 then @currentSketch = @sketches.length - 1

		null

	loadCurrentSketch: ->
		@sketches[@currentSketch].sketch.load()
		@sketches[@currentSketch].sketch.view.style.opacity = 0
		document.body.appendChild @sketches[@currentSketch].sketch.view
		TweenMax.to @sketches[@currentSketch].sketch.view, 1, { css:{ opacity:1 }, ease:Power4.easeOut }
		null

	

