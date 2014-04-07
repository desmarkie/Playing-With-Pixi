# import sketches.Sketch
class PlanktonTank extends Sketch

	constructor: (@renderer, @name) ->
		super @renderer, @name

	load: =>

		if not @loaded
			@numPlankton = 30

			@plankton = []

			@addPlankton()

		super()

		null

	unload: =>

		super()
		null

	update: =>
		super()
		if @cancelled then return

		for p in @plankton
			p.update()



		null

	addPlankton: =>
		for i in [0...@numPlankton]
			p = new Plankton()
			@plankton.push p
			@view.addChild p.view
		null

	resize: =>

		null