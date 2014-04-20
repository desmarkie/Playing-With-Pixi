class TessellationOne extends Sketch

	constructor: (@renderer, @name) ->
		super @renderer, @name

	load: =>

		if not @loaded
			#creates a dat.GUI folder, access via @gui
			@makeGui()

			@unitSize = 10

			g = new PIXI.Graphics()
			@drawTile g

			@tileTex = g.generateTexture()

			@spriteHolder = new PIXI.DisplayObjectContainer()
			@view.addChild @spriteHolder

			x = y = l = 0
			y = -3
			while (y*@unitSize) < window.innerWidth
				sp = new PIXI.Sprite @tileTex
				tx = ((x * 10)-l) * @unitSize
				ty = y * @unitSize
				sp.position.x = tx
				sp.position.y = ty
				@spriteHolder.addChild sp
				x++
				if tx >= window.innerWidth
					l++
					x = 0
					y += 3

			@spriteHolder.position.y = -20

			copyTex = @spriteHolder.generateTexture()
			copyOne = new PIXI.Sprite copyTex
			@view.addChild copyOne
			copyOne.position.x = (-2*@unitSize) - 510
			copyOne.position.y = (1*@unitSize) - 50

			copyTwo = new PIXI.Sprite copyTex
			@view.addChild copyTwo
			copyTwo.position.x = (1 * @unitSize) - 510
			copyTwo.position.y = (2 * @unitSize) - 50
			
		

		super()

		null

	drawTile: (canvas) ->
		canvas.beginFill 0xFFFFFF
		canvas.moveTo 0, 0
		canvas.lineTo 2*@unitSize, 0
		canvas.lineTo 2*@unitSize, 2*@unitSize
		canvas.lineTo 3*@unitSize, 2*@unitSize
		canvas.lineTo 3*@unitSize, 3*@unitSize
		canvas.lineTo 1*@unitSize, 3*@unitSize
		canvas.lineTo 1*@unitSize, 1*@unitSize
		canvas.lineTo 0, 1*@unitSize
		canvas.lineTo 0, 0
		canvas.endFill()

		canvas.beginFill 0x777777
		canvas.moveTo 1*@unitSize, 3*@unitSize
		canvas.lineTo 3*@unitSize, 3*@unitSize
		canvas.lineTo 3*@unitSize, 2*@unitSize
		canvas.lineTo 4*@unitSize, 2*@unitSize
		canvas.lineTo 4*@unitSize, 4*@unitSize
		canvas.lineTo 2*@unitSize, 4*@unitSize
		canvas.lineTo 2*@unitSize, 5*@unitSize
		canvas.lineTo 1*@unitSize, 5*@unitSize
		canvas.lineTo 1*@unitSize, 3*@unitSize
		canvas.endFill()
		null

	unload: =>

		super()
		null

	update: =>
		super()
		if @cancelled then return

		null

	resize: =>

		null