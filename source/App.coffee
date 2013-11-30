# import sketches.*

class App

	sketches: null

	currentSketch: 0
	numSketches: null

	liveSketch: null

	textures: null

	menuPanel: null
	infoButton: null
	menuButton: null
	menuOpen: false
	infoOpen: false

	stageColor: 0x0e0e0e

	spacePressed: false

	constructor: ->
		@renderer = PIXI.autoDetectRenderer window.innerWidth, window.innerHeight

		window.onresize = =>
			@renderer.resize window.innerWidth, window.innerHeight
			for sketch in @sketches
				sketch.sketch.resize()

		toDo = [Smoky, Trails, Dots, Spirals]

		@textures = [PIXI.Texture.fromImage('img/node.png')]

		@sketches = []
		for i in toDo
			@sketches.push {sketch:new i(@renderer), id:i.id}

		@numSketches = @sketches.length
		@currentSketch = @sketches.length - 1

		@interface = document.getElementById('interface')

		@infoButton = document.getElementById('info-button')
		@infoButton.onmouseover = @handleInterfaceOver
		@infoButton.onmouseout = @handleInterfaceOut
		@infoButton.onclick = @handleInfoClick

		@menuButton = document.getElementById('menu-button')
		@menuButton.onmouseover = @handleInterfaceOver
		@menuButton.onmouseout = @handleInterfaceOut
		@menuButton.onclick = @handleMenuClick

		@menuPanel = document.getElementById('menu-panel')
		@nextButton = document.getElementById('next-sketch')
		@prevButton = document.getElementById('previous-sketch')
		@currentButton = document.getElementById('current-sketch')

		@nextButton.onclick = @next
		@prevButton.onclick = @prev
		@currentButton.onclick = @handleMenuClick
		@nextButton.onmouseover = @prevButton.onmouseover = @currentButton.onmouseover = @handleDivOver
		@nextButton.onmouseout = @prevButton.onmouseout = @currentButton.onmouseout = @handleDivOut

		@init()

	init: =>
		
		# @loadCurrentSketch()

		window.onkeyup = @handleKeyPress

		null

	handleDivOver: (e) =>
		if e.target is @nextButton or e.target is @prevButton or e.target is @currentButton
			# TweenMax.to e.target, 0.3, {css:{color:'rgb(255, 0, 61)', backgroundColor:'rgba(213,214,219, 1)'}, ease:Power4.easeOut}
			TweenMax.to e.target, 0.3, {css:{color:'rgb(255, 0, 61)'}, ease:Power4.easeOut}
		# if e.target is @currentButton
		# 	TweenMax.to document.getElementById('line-a'), 0.3, {css:{backgroundColor:'#0e0e0e'}, ease:Power4.easeOut}
		# 	TweenMax.to document.getElementById('line-b'), 0.3, {css:{backgroundColor:'#0e0e0e'}, ease:Power4.easeOut}
		null

	handleDivOut: (e) =>
		if e.target is @nextButton or e.target is @prevButton or e.target is @currentButton
			# TweenMax.to e.target, 2, {css:{color:'#dedede', backgroundColor:'rgba(0,0,0,0.85)'}, ease:Power4.easeOut}
			TweenMax.to e.target, 2, {css:{color:'#dedede'}, ease:Power4.easeOut}
		# if e.target is @currentButton
		# 	TweenMax.to document.getElementById('line-a'), 2, {css:{backgroundColor:'#dedede'}, ease:Power4.easeOut}
		# 	TweenMax.to document.getElementById('line-b'), 2, {css:{backgroundColor:'#dedede'}, ease:Power4.easeOut}
		null

	handleInfoClick: =>

		null

	handleMenuClick: =>
		@menuOpen = !@menuOpen
		if @menuOpen
			$(@menuPanel).css 'z-index', '1200'
			TweenMax.to @menuPanel, 0.5, {css:{opacity:1}, ease:Power4.easeOut}
			# TweenMax.to @menuButton, 0.5, {css:{color:'#e3e3e3'}, ease:Power4.easeOut}
			TweenMax.to @infoButton, 0.5, {css:{color:'#e3e3e3'}, ease:Power4.easeOut}
			# TweenMax.to @interface, 0.5, {css:{opacity:0}, ease:Power4.easeOut}
		else
			TweenMax.to @menuPanel, 0.5, {css:{opacity:0}, ease:Power4.easeOut, onComplete:=>
				$(@menuPanel).css 'z-index','1'
			}
			TweenMax.to @menuButton, 0.5, {css:{color:'#e3e3e3'}, ease:Power4.easeOut}
			TweenMax.to @infoButton, 0.5, {css:{color:'#e3e3e3'}, ease:Power4.easeOut}
			# TweenMax.to @interface, 0.5, {css:{opacity:1}, ease:Power4.easeOut}
		null

	handleInterfaceOut: (e) =>
		# if @menuOpen and e.target != @menuButton
		# 	TweenMax.to e.target, 2, {css:{color:'#e3e3e3'}, ease:Power4.easeOut}
		# else if @infoOpen and e.target != @infoButton
			# TweenMax.to e.target, 2, {css:{color:'#e3e3e3'}, ease:Power4.easeOut}
		# else
		# 	TweenMax.to e.target, 2, {css:{color:'#0e0e0e'}, ease:Power4.easeOut}
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
		@updateInfoContent()
		null

	prev: =>
		lastSketch = @sketches[@currentSketch]
		@changeSketch('prev')
		@unloadSketch(lastSketch.sketch)
		@updateInfoContent()
		null

	updateInfoContent: ->
		prevId = @currentSketch-1
		if prevId < 0 then prevId = @sketches.length-1
		nextId = @currentSketch+1
		if nextId == @sketches.length then nextId = 0

		@currentButton.innerHTML = '<p class="title-copy">'+@sketches[@currentSketch].id+'</p>'+@generateIpsum(@sketches[@currentSketch].id)
		@prevButton.innerHTML = '<p class="title-copy">'+@sketches[prevId].id+'</p>'
		@nextButton.innerHTML = '<p class="title-copy">'+@sketches[nextId].id+'</p>'
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

	generateIpsum: (label) ->
		str = "<p class='body-copy'>Well, the way they make shows is, they make one show. That show's called a pilot. Then they show that show to the people who make shows, and on the strength of that one show they decide if they're going to make more shows. Some pilots get picked and become television programs. Some don't, become nothing. She starred in one of the ones that became nothing.<!-- please do not remove this line --><div style='display:none;'><a href='http://slipsum.com'>lorem ipsum</a></div></p>"
		return str.replace(/show/g, label)

	

