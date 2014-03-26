# import sketches.Sketch
class PlanktonTank extends Sketch

	constructor: (@renderer) ->
		super @renderer

	load: =>

		if not @loaded
			@stage = new PIXI.Stage window.app.stageColor

			@view = document.createElement 'div'

			# @gui = @makeGui()
			# @view.appendChild @gui.domElement

			@numPlankton = 30

			@plankton = []

			@addPlankton()

		@view.appendChild @renderer.view

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

		@renderer.render @stage

		null

	addPlankton: =>
		for i in [0...@numPlankton]
			p = new Plankton()
			@plankton.push p
			@stage.addChild p.view
		null

	resize: =>

		null