# import sketches.Sketch
# import utils.ColourConversion
# import objects.CometParticle
class Comets extends Sketch

	particles: []
	pool: []

	constructor: (@renderer) ->
		super @renderer

	load: =>

		if not @loaded
			@stage = new PIXI.Stage window.app.stageColor

			@view = document.createElement 'div'

			@gui = @makeGui()
			@view.appendChild @gui.domElement

			@maxComets = 40

			@minFrames = 5
			@maxFrames = 10

			@timeLimit = 0

			@cometColor = 240

			@sparkColor = 300

			@trailColor = 240
			@trailHsb = [0, 18, 100]
			@setTrailColor @trailColor

			@newTimeLimit()

			@gui.add @, 'maxComets', 1, 100
			@gui.add @, 'minFrames', 1, 100
			@gui.add @, 'maxFrames', 1, 100
			@gui.add(@, 'cometColor', 0, 360).onFinishChange(=>
				@setCometColors()
			)
			@gui.add(@, 'trailColor', 0, 360).onChange(=>
				@setTrailColor @trailColor
			)
			@gui.add(@, 'sparkColor', 0, 360).onChange(=>
				@setSparkColor @sparkColor
			)


			@graphics = new PIXI.Graphics()
			@stage.addChild @graphics

		@view.appendChild @renderer.view

		@timeout = 1


		super()

		null

	unload: =>

		super()
		null

	update: =>
		super()
		if @cancelled then return

		@timeout--

		if @timeout is 0
			if @particles.length < @maxComets
				@newTimeLimit()
				@timeout = @timeLimit
				@fireComet()
			else
				@timeout++

		for i in [@particles.length-1..0] by -1
			comet = @particles[i]
			comet.randomiseVelocity false
			if window.app.mousePressed then comet.headForMouse()
			comet.update()
			if comet.life is 0 or comet.position.x > window.innerWidth
				@particles.splice i, 1
				@pool.push comet
				@stage.removeChild comet.view

		@drawPaths()

		@renderer.render @stage

		null

	setTrailColor: (value) =>
		@trailColor = value
		@trailHsb[0] = @trailColor
		@trailHex = ColourConversion.hsbToHex @trailHsb
		null

	setSparkColor: (value) =>
		@sparkColor = value
		for comet in @particles
			comet.setSparkColor @sparkColor
		null

	drawPaths: =>
		@graphics.clear()

		for comet in @particles
			inc = 1 / comet.positions.length
			for i in [0..comet.positions.length-2]
				@graphics.lineStyle 1, @trailHex, (i*inc) * (comet.life / comet.totalLife)
				@graphics.moveTo comet.positions[i].x, comet.positions[i].y
				@graphics.lineTo comet.positions[i+1].x, comet.positions[i+1].y


		null

	fireComet: =>
		comet = @newComet()
		@particles.push comet
		@stage.addChild comet.view
		null

	setCometColors: =>
		for comet in @particles
			comet.setColor @cometColor
		null

	newComet: =>
		if @pool.length is 0
			comet = new CometParticle()
		else
			comet = @pool[0]
			@pool.splice 0, 1

		comet.setColor @cometColor
		comet.setSparkColor @sparkColor
		comet.position.x = 0#Math.random() * (window.innerWidth * 0.1)
		comet.position.y = Math.random() * window.innerHeight
		comet.randomiseVelocity()
		comet.positions = []
		comet.fillPositions()
		comet.life = comet.totalLife
		return comet

	newTimeLimit: =>
		@timeLimit = Math.round(@minFrames + (Math.random() * (@maxFrames - @minFrames)))
		null

	resize: =>

		null