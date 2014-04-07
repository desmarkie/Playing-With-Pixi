# import views.MenuButton
# import objects.Node
# import utils.MathUtils
class Menu

	constructor: (@app, @data, @renderer) ->
		@view = new PIXI.DisplayObjectContainer()

		@bgAlpha = 0.9

		@bg = new PIXI.Graphics()
		@view.addChild @bg
		@resize()
		@tabBg = new PIXI.Graphics()
		@view.addChild @tabBg
		@tabText = new PIXI.Text(@data[@app.currentSketch].classId, {font:'300 15px Lato', fill:'#e3e3e3'})
		@tabText.anchor.y = 1
		@tabBg.beginFill 0, @bgAlpha
		@tabBg.drawRect(0, 0, @tabText.width, -@tabText.height)
		@tabBg.endFill()
		@view.addChild @tabText

		@tabText.setInteractive true
		@tabText.mouseup = @show

		@mouseDown = false
		@isOpen = true

		@buttons = []
		@buttonSprites = []

		@buttonSize = 20
		@radius = (Math.min(window.innerWidth, window.innerHeight) * 0.5) - 50

		@createButtons()

		@currentButton = @buttons[@app.currentSketch]

		@menuText = new PIXI.Text(@currentButton.name, {font:'300 27px Lato', fill:'#e3e3e3'})
		@menuText.anchor.x = 0.5
		@menuText.anchor.y = 0.5
		@menuText.position.x = Math.round(window.innerWidth * 0.5)
		@menuText.position.y = Math.round(window.innerHeight * 0.5)
		@view.addChild @menuText

	show: =>
		console.log 'OPEN SESAME', @view
		TweenMax.killTweensOf @view.position
		TweenMax.to @view.position, 0.3, {y:0, ease:Power4.easeOut}
		@isOpen = true
		null

	hide: =>
		@isOpen = false
		TweenMax.killTweensOf @view.position
		TweenMax.to @view.position, 0.3, {y:window.innerHeight, ease:Power4.easeOut}
		null

	resize: =>
		@bg.clear()
		@bg.beginFill 0, @bgAlpha
		@bg.drawRect 0, 0, window.innerWidth, window.innerHeight
		@bg.endFill()
		null

	enable: =>
		
		null

	disable: =>
		
		null


	update: =>
		if @app.mousePressed and !@mouseDown
			@mouseDown = true
		else if !@app.mousePressed and @mouseDown and @isOpen
			@mouseDown = false
			@app.selectSketch @currentButton.id
			@hide()
			return

		if @view.position.y is window.innerHeight then return

		yd = (window.innerHeight*0.5) - @app.pointerPosition.y
		xd = (window.innerWidth*0.5) - @app.pointerPosition.x
		curAngle = MathUtils.radToDeg Math.atan2(yd, xd)
		curAngle += 180
		# console.log 'curAngle', curAngle
		minDist = 180
		for i in [0...@buttons.length]
			@buttonSprites[i].position.x = (window.innerWidth * 0.5) + @buttons[i].position.x
			@buttonSprites[i].position.y = (window.innerHeight * 0.5) + @buttons[i].position.y
			dist = @checkAngleDistance curAngle, @buttons[i].angle
			if dist < minDist
				minDist = dist
				@currentButton = @buttons[i]

		for but in @buttons
			if but is @currentButton and !but.active
				but.active = true
				TweenMax.killTweensOf @buttonSprites[but.id].scale
				TweenMax.killTweensOf but
				TweenMax.to @buttonSprites[but.id].scale, 1.2, {x:2, y:2, ease:Elastic.easeOut}
				TweenMax.to but, 0.3, {s:100, onUpdate:@updateButtonTint, onUpdateParams:[but], ease:Power4.easeOut}
				@menuText.setText but.name
				@tabText.setText but.name
				@tabBg.beginFill 0, @bgAlpha
				@tabBg.drawRect(0, 0, @tabText.width, -@tabText.height)
				@tabBg.endFill()
			else if but.active and but != @currentButton
				but.active = false
				TweenMax.killTweensOf @buttonSprites[but.id].scale
				TweenMax.killTweensOf but
				TweenMax.to @buttonSprites[but.id].scale, 1.2, {x:1, y:1, ease:Elastic.easeOut}
				TweenMax.to but, 1.2, {s:0, onUpdate:@updateButtonTint, onUpdateParams:[but], ease:Power4.easeOut}
		null

	updateButtonTint: (but) =>
		@buttonSprites[but.id].tint = ColourConversion.hsbToHex [but.angle, but.s, but.b]
		null

	checkAngleDistance: (current, target) =>
		dif = Math.abs(current - target)
		if dif > 180 then dif = 360 - dif
		return dif

	createButtons: ->
		inc = 360 / @data.length
		for i in [0...@data.length]
			x = Math.cos(MathUtils.degToRad(inc * i)) * @radius
			y = Math.sin(MathUtils.degToRad(inc * i)) * @radius
			but = new Node x, y
			but.angle = inc * i
			but.id = i
			but.name = @data[i].classId
			but.active = false
			but.s = 0
			but.b = 100
			@buttons.push but
			@createButtonSprite x, y	
		null

	createButtonSprite: (x, y) ->
		sp = new PIXI.Graphics()
		sp.beginFill 0xe3e3e3
		sp.drawCircle 0, 0, @buttonSize
		sp.endFill()
		sp.position.x = x
		sp.position.y = y
		@buttonSprites.push sp
		@view.addChild sp
		null

