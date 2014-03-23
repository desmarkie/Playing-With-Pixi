# import sketches.Sketch
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

			@newTimeLimit()

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

	drawPaths: =>
		@graphics.clear()

		for comet in @particles
			inc = 1 / comet.positions.length
			for i in [0..comet.positions.length-2]
				@graphics.lineStyle 1, 0xd0d0ff, (i*inc) * (comet.life / comet.totalLife)
				@graphics.moveTo comet.positions[i].x, comet.positions[i].y
				@graphics.lineTo comet.positions[i+1].x, comet.positions[i+1].y


		null

	fireComet: =>
		comet = @newComet()
		@particles.push comet
		@stage.addChild comet.view
		null

	newComet: =>
		if @pool.length is 0
			comet = new CometParticle()
		else
			comet = @pool[0]
			@pool.splice 0, 1

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