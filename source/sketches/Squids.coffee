
class Squids extends Sketch

	constructor: (@renderer) ->
		super @renderer

	load: =>

		if not @loaded
			@stage = new PIXI.Stage window.app.stageColor

			@view = document.createElement 'div'

			@gui = @makeGui()
			@view.appendChild @gui.domElement

			@squids = []
			for i in [0...3]
				squid = new SquidNode window.innerWidth * ((1 / 4) * (i+1)), window.innerHeight * 0.5
				squid.speed = 1 + (Math.random() * 5)
				squid.radSpeed = 1 + (Math.random() * 36)
				col = Math.random()*360
				squid.setColor col
				squid.setTailColor col
				@stage.addChild squid.view
				@squids.push squid

			@gui.add @, 'random0'
			@gui.add @, 'random1'
			@gui.add @, 'random2'

		@view.appendChild @renderer.view

		super()

		null

	random0: =>
		squid = @squids[0]
		squid.speed = 1 + (Math.random() * 5)
		squid.radSpeed = 1 + (Math.random() * 36)
		col = Math.random()*360
		squid.setColor col
		squid.setTailColor col
		null

	random1: =>
		squid = @squids[1]
		squid.speed = 1 + (Math.random() * 5)
		squid.radSpeed = 1 + (Math.random() * 36)
		col = Math.random()*360
		squid.setColor col
		squid.setTailColor col
		null

	random2: =>
		squid = @squids[2]
		squid.speed = 1 + (Math.random() * 5)
		squid.radSpeed = 1 + (Math.random() * 36)
		col = Math.random()*360
		squid.setColor col
		squid.setTailColor col
		null

	unload: =>

		super()
		null

	update: =>
		super()
		if @cancelled then return

		for squid in @squids
			squid.update()

		@renderer.render @stage

		null

	resize: =>

		null