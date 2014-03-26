# import sketches.Sketch
# import utils.ColourConversion
# import objects.SpirographNode
class Spirograph extends Sketch

	constructor: (@renderer) ->
		super @renderer

	load: =>

		if not @loaded
			@stage = new PIXI.Stage window.app.stageColor

			@view = document.createElement 'div'

			@gui = @makeGui()
			@view.appendChild @gui.domElement

			@nodes = []

			@addNode()
			@addNode()
			@addNode()

		@view.appendChild @renderer.view

		super()

		null

	unload: =>

		super()
		null

	update: =>
		super()
		if @cancelled then return

		for node in @nodes
			node.update()

		@renderer.render @stage

		null

	resize: =>

		null

	addNode: =>
		node = new SpirographNode()
		@nodes.push node
		node.color = Math.random()*360
		node.updateTint()
		@stage.addChild node.view

		# node.randomise()

		if @nodes.length is 1
			node.speed = 59.9
			node.radSpeed = 122
		else if @nodes.length is 2
			node.speed = 60
			node.radSpeed = 61
		else if @nodes.length is 3
			node.speed = 60
			node.radSpeed = 119
		node.colorSpeed = Math.random()

		folder = @gui.addFolder 'Spirograph '+@nodes.length
		folder.add(node, 'speed', 0.1, 359.9).listen()
		folder.add(node, 'radSpeed', 0.1, 359.9).listen()
		folder.add(node, 'radMin', 0.1, 500).listen()
		folder.add(node, 'radMax', 0.1, 500).listen()
		folder.add node, 'tailWidth', 1, 30
		folder.add node, 'color', 0, 360.0
		folder.add(node, 'colorSpeed', 0, 1).listen()
		folder.add node, 'recordedPositions', 1, 360
		folder.add node, 'randomise'
		null