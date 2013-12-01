# import sketches.Sketch
# import utils.MathUtils
class SineWave extends Sketch

	@id: 'Sine Wave'

	phase: 0
	limit: 360
	waveLength: 203
	amplitude: 260
	frequency: 10

	rotateAngle: 0
	rotateSpeed: 351.16

	numSprites: 100

	midY: 0

	sprites: []

	constructor: (@renderer) ->
		super(@renderer)

	load: =>
		@midY = window.innerHeight * 0.5
		@midX = window.innerWidth * 0.5
		if not @loaded
			@stage = new PIXI.Stage(window.app.stageColor)
			@createSprites()

			@view = document.createElement('div')
			@view.appendChild @renderer.view

			@gui = new dat.GUI({autoPlace:false})
			@gui.domElement.style.zIndex = 100
			@gui.domElement.style.position = 'absolute'
			@gui.domElement.style.top = 0
			@gui.domElement.style.left = 0
			@gui.domElement.style.height = 'auto'
			@view.appendChild @gui.domElement

			@gui.add @, 'waveLength', 10, 1000
			@gui.add @, 'amplitude', 10, 500
			@gui.add @, 'frequency', 1, 100
			@gui.add @, 'limit', 1, 360
			@gui.add @, 'rotateSpeed', 0, 720

			@gui.close()

		@view.appendChild @renderer.view

		super()
		null

	unload: =>
		super()
		null

	update: =>
		super()
		if @cancelled then return

		console.log 'amplitude = '+@amplitude

		spacing = window.innerWidth / @numSprites

		for i in [0..@numSprites] by 1
			sp = @sprites[i]
			xPos = (i*spacing) + ((@phase/360)*@waveLength)
			xSin = ((xPos % @waveLength)/@waveLength) * 360
			yPos = @midY + (Math.sin(MathUtils.degToRad(xSin)) * @amplitude)
			
			xCalc = xPos - @midX
			yCalc = yPos - @midY

			angle = MathUtils.degToRad(@rotateAngle)
			newx = (xCalc * Math.cos angle) - (yCalc * Math.sin angle)
			newy = (xCalc * Math.sin angle) + (yCalc * Math.cos angle)

			sp.position.x = @midX + newx
			sp.position.y = @midY + newy


		@phase += @frequency
		@phase %= @limit

		@rotateAngle += @rotateSpeed
		@rotateAngle %= 360

		@renderer.render @stage
		null

	createSprites: =>
		spacing = window.innerWidth / @numSprites
		for i in [0..@numSprites] by 1
			sp = new PIXI.Sprite(window.app.textures[0])
			sp.pivot.x = sp.pivot.y = 16
			sp.position.x = i * spacing
			sp.position.y = @midY
			@sprites.push sp
			@stage.addChild sp

		null
