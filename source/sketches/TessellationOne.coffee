class TessellationOne extends Sketch

	constructor: (@renderer, @name) ->
		super @renderer, @name

	load: =>

		if not @loaded
			#creates a dat.GUI folder, access via @gui
			@makeGui()

			@unitSize = 10

			@tiles = {}
			@tileLayers = []

			@curLayer = 0

			g = new PIXI.Graphics()
			@drawTile g

			@tileTex = g.generateTexture()

			@spriteHolder = new PIXI.DisplayObjectContainer()
			@spriteHolder.position.x = window.innerWidth * 0.5
			@spriteHolder.position.y = window.innerHeight * 0.5
			@view.addChild @spriteHolder

		while @spriteHolder.children.length > 0
			@spriteHolder.removeChild @spriteHolder.children[0]

		@tiles = {}
		@tileLayers = []
		@curLayer = 0

		sp = new PIXI.Sprite @tileTex
		sp.anchor.x = sp.anchor.y = 0.5
		@spriteHolder.addChild sp

		@tileLayers.push [sp]
		@tiles['0_0'] = sp



		# @waiting = false
		

		super()

		null

	drawTile: (canvas) ->
		canvas.beginFill 0xFFFFFF
		@drawVert canvas, -1, -3
		canvas.endFill()
		canvas.beginFill 0xFFFFFF
		@drawVert canvas, -2, 0
		canvas.endFill()
		canvas.beginFill 0x777777
		@drawHori canvas, -3, -2
		canvas.endFill()
		canvas.beginFill 0x777777
		@drawHori canvas, 0, -1
		canvas.endFill()
		null

	drawVert: (canvas, xOff, yOff) ->
		canvas.moveTo xOff * @unitSize, yOff * @unitSize
		canvas.lineTo (xOff+2) * @unitSize, yOff * @unitSize
		canvas.lineTo (xOff+2) * @unitSize, (yOff+2) * @unitSize
		canvas.lineTo (xOff+3) * @unitSize, (yOff+2) * @unitSize
		canvas.lineTo (xOff+3) * @unitSize, (yOff+3) * @unitSize
		canvas.lineTo (xOff+1) * @unitSize, (yOff+3) * @unitSize
		canvas.lineTo (xOff+1) * @unitSize, (yOff+1) * @unitSize
		canvas.lineTo xOff * @unitSize, (yOff+1) * @unitSize
		canvas.lineTo xOff * @unitSize, yOff * @unitSize
		null

	drawHori: (canvas, xOff, yOff) ->
		canvas.moveTo xOff * @unitSize, (yOff+1) * @unitSize
		canvas.lineTo (xOff+2) * @unitSize, (yOff+1) * @unitSize
		canvas.lineTo (xOff+2) * @unitSize, yOff * @unitSize
		canvas.lineTo (xOff+3) * @unitSize, yOff * @unitSize
		canvas.lineTo (xOff+3) * @unitSize, (yOff+2) * @unitSize
		canvas.lineTo (xOff+1) * @unitSize, (yOff+2) * @unitSize
		canvas.lineTo (xOff+1) * @unitSize, (yOff+3) * @unitSize
		canvas.lineTo xOff * @unitSize, (yOff+3) * @unitSize
		canvas.lineTo xOff * @unitSize, (yOff+1) * @unitSize
		null

	addLayer: ->
		layer = []
		for tile in @tileLayers[@curLayer]
			x = tile.position.x / @unitSize
			y = tile.position.y / @unitSize
			a = (x + 2)+'_'+(y + 4)
			b = (x - 4)+'_'+(y + 2)
			c = (x - 2)+'_'+(y - 4)
			d = (x + 4)+'_'+(y - 2)
			if @tiles[a] is undefined
				@tiles[a] = @addTile(x+2, y+4)
				layer.push @tiles[a]
			if @tiles[b] is undefined
				@tiles[b] = @addTile(x-4, y+2)
				layer.push @tiles[b]
			if @tiles[c] is undefined
				@tiles[c] = @addTile(x-2, y-4)
				layer.push @tiles[c]
			if @tiles[d] is undefined
				@tiles[d] = @addTile(x+4, y-2)
				layer.push @tiles[d]
		@tileLayers.push layer
		@curLayer++
		null

	addTile: (x, y) ->
		sp = new PIXI.Sprite @tileTex
		sp.anchor.x = sp.anchor.y = 0.5
		sp.position.x = x * @unitSize
		sp.position.y = y * @unitSize
		sp.alpha = 1 - (@curLayer / 20)
		@spriteHolder.addChild sp
		return sp

	unload: =>

		super()
		null

	update: =>
		super()
		if @cancelled then return

		# if window.app.mousePressed and !@waiting
		# 	@waiting = true
		# else if !window.app.mousePressed and @waiting
		# 	@waiting = false
		# 	@addLayer()

		if @curLayer < 20
			@addLayer()

		null

	resize: =>

		null