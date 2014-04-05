# import objects.Node
# import utils.MathUtils
class ShapeShifter extends Sketch

	constructor: (@renderer) ->
		super @renderer

	load: =>

		if not @loaded
			@stage = new PIXI.Stage window.app.stageColor

			@view = document.createElement 'div'

			@holder = new PIXI.DisplayObjectContainer()
			@holder.position.x = window.innerWidth * 0.5
			@holder.position.y = window.innerHeight * 0.5
			@stage.addChild @holder

			@shapes = ['cube', 'cylinder', 'torus']
			@curShape = 0

			@size = 10
			@spacing = 32
			@xOffset = 0
			@yOffset = 0
			@depthOn = true
			@numNodes = @size * @size * @size

			@nodes = @createNodes()
			@sprites = @createSprites()
			@placeSprites()

			@gui = @makeGui()
			@view.appendChild @gui.domElement
			@gui.add @, 'depthOn'

		for key,node of @nodes
			node.position.x = node.position.y = node.position.z = 0

		@view.appendChild @renderer.view

		# @placeNodes()
		TweenMax.to @, 0.75, {onComplete:@placeNodes}

		super()

		null

	unload: =>

		super()
		null

	update: =>
		super()
		if @cancelled then return

		if window.app.mousePressed
			window.app.mousePressed = false
			@placeNodes()

		w = window.innerWidth
		h = window.innerHeight
		hw = window.innerWidth * 0.5
		hh = window.innerHeight * 0.5

		@xOffset = ((window.app.pointerPosition.x - hw) / w) * 360
		@yOffset = ((window.app.pointerPosition.y - hh) / h) * 360

		@placeSprites()

		@renderer.render @stage

		null

	resize: =>

		null

	createNodes: ->
		nodes = {}
		x = y = z = 0
		halfSpace = (@spacing * @size) * 0.5
		for i in [0...@numNodes]
			n = new Node()
			nodes[x+'_'+y+'_'+z] = n
			x++
			if x is @size
				x = 0
				y++
				if y is @size
					y = 0
					z++

		return nodes

	placeNodes: =>
		halfSpace = (@spacing * @size) * 0.5
		i = 0
		inc = 360 / @size
		incInc = 360 / (@size * @size)
		for x in [0...@size]
			for y in [0...@size]
				for z in [0...@size]
					node = @nodes[x+'_'+y+'_'+z]

					if @shapes[@curShape] is 'cube'
						_x = (x*@spacing)-halfSpace
						_y = (y*@spacing)-halfSpace
						_z = (z*@spacing)-halfSpace
					else if @shapes[@curShape] is 'cylinder'
						ct = (@size*x)+y
						angle = MathUtils.degToRad(ct * incInc)
						# angle = MathUtils.degToRad(z * inc) + MathUtils.degToRad(x * inc)
						radius = halfSpace * (z / @size)
						_x = Math.cos(angle) * radius
						_y = (y*@spacing)-halfSpace
						_z = Math.sin(angle) * radius
					else if @shapes[@curShape] is 'torus'
						ct = (@size*x)+y
						outerAngle = MathUtils.degToRad(ct * incInc)
						if x is @size-1 then console.log MathUtils.radToDeg(outerAngle)
						tubeAngle = MathUtils.degToRad(z * inc)
						outerRadius = 128
						tubeRadius = 64
						_x = (outerRadius + (tubeRadius * Math.cos(tubeAngle))) * Math.cos(outerAngle)
						_z = (outerRadius + (tubeRadius * Math.cos(tubeAngle))) * Math.sin(outerAngle)
						_y = Math.sin(tubeAngle) * tubeRadius


					TweenMax.killTweensOf node.position
					TweenMax.to node.position, 1.5, {x:_x, y:_y, z:_z, ease:Elastic.easeOut, delay:Math.random() * 0.2}
					i++
		@curShape++
		if @curShape is @shapes.length then @curShape = 0
		null

	createSprites: ->
		sprites = []
		for i in [0...@numNodes]
			sp = new PIXI.Sprite window.app.textures[0]
			sp.pivot.x = sp.pivot.y = 16
			@holder.addChild sp
			sprites.push sp
		return sprites

	placeSprites: ->
		i = 0
		min = Math.log 0.1
		max = Math.log 1

		for x in [0...@size]
			for y in [0...@size]
				for z in [0...@size]
					sp = @sprites[i]
					node = @nodes[x+'_'+y+'_'+z]

					scalar = if @depthOn then (node.position.z / (@spacing*@size)) else 0

					sp.scale.x = sp.scale.y = 1 + Math.exp(min + scalar)
					# sp.scale.x = sp.scale.y = 1 + scalar
					sp.position.x = (node.position.x * sp.scale.x) + (scalar * @xOffset)
					sp.position.y = (node.position.y * sp.scale.y) + (scalar * @yOffset)
					sp.alpha = 0.4
					i++
		null