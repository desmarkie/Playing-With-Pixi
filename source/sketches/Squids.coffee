
class Squids extends Sketch

	constructor: (@renderer, @name) ->
		super @renderer, @name

	load: =>

		if not @loaded
			@makeGui()

			@squids = []
			for i in [0...3]
				squid = new SquidNode window.innerWidth * ((1 / 4) * (i+1)), window.innerHeight * 0.5
				squid.speed = 1 + (Math.random() * 5)
				squid.radSpeed = 1 + (Math.random() * 36)
				col = Math.random()*360
				squid.setColor col
				squid.setTailColor col
				@view.addChild squid.view
				@squids.push squid

			@gui.add @, 'random0'
			@gui.add @, 'random1'
			@gui.add @, 'random2'

		

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



		null

	resize: =>

		null