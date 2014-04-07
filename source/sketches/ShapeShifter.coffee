# import objects.Node
# import utils.MathUtils
class ShapeShifter extends Sketch

	constructor: (@renderer, @name) ->
		super @renderer, @name

	load: =>

		if not @loaded
			@holder = new PIXI.DisplayObjectContainer()
			@holder.position.x = window.innerWidth * 0.5
			@holder.position.y = window.innerHeight * 0.5
			@view.addChild @holder

			@shapes = ['cube', 'cylinder', 'torus', 'sphere', 'sphere2', 'cone']
			@curShape = 0

			@size = 10
			@spacing = 32
			@xOffset = 0
			@yOffset = 0
			@isometricScale = 1
			@focalLength = 70
			@cameraPosition = 1000
			@depthOn = false
			@perspectiveOn = true
			@numNodes = @size * @size * @size

			@nodes = @createNodes()
			@sprites = @createSprites()
			@placeSprites()

			@makeGui()
			
			@gui.add(@, 'depthOn').listen().onFinishChange(=>
				if @depthOn and @perspectiveOn
					@perspectiveOn = false
			).name('Isometric')
			f = @gui.addFolder 'Isometric Controls'
			f.add(@, 'isometricScale', 1, 3).name('Zoom')
			@gui.add(@, 'perspectiveOn').listen().onFinishChange(=>
				if @depthOn and @perspectiveOn
					@depthOn = false
			).name('Perspective')
			f = @gui.addFolder 'Perspective Controls'
			f.add(@, 'focalLength', 1, 300).name('Focal Length')
			f.add(@, 'cameraPosition', 0, 2000).name('Z position')

		for key,node of @nodes
			node.position.x = node.position.y = node.position.z = 0

		

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
						radius = halfSpace * (z / @size)
						_x = Math.cos(angle) * radius
						_y = (y*@spacing)-halfSpace
						_z = Math.sin(angle) * radius
					else if @shapes[@curShape] is 'torus'
						ct = (@size*x)+y
						outerAngle = MathUtils.degToRad(ct * incInc)
						tubeAngle = MathUtils.degToRad(z * inc)
						outerRadius = 128
						tubeRadius = 64
						_x = (outerRadius + (tubeRadius * Math.cos(tubeAngle))) * Math.cos(outerAngle)
						_z = (outerRadius + (tubeRadius * Math.cos(tubeAngle))) * Math.sin(outerAngle)
						_y = Math.sin(tubeAngle) * tubeRadius
					else if @shapes[@curShape] is 'sphere'
						ct = (@size*x)+y
						angle = MathUtils.degToRad(ct * incInc)
						angle2 = MathUtils.degToRad(z * inc) * 0.5
						radius = 128
						_z = radius * Math.cos(angle) * Math.sin(angle2)
						_y = radius * Math.sin(angle) * Math.sin(angle2)
						_x = radius * Math.cos(angle2)
					else if @shapes[@curShape] is 'sphere2'
						angle = MathUtils.degToRad(y * inc)
						angle2 = MathUtils.degToRad(z * inc) * 0.5
						radius = (128 / @size) * x
						_x = radius * Math.cos(angle) * Math.sin(angle2)
						_z = radius * Math.sin(angle) * Math.sin(angle2)
						_y = radius * Math.cos(angle2)
					else if @shapes[@curShape] is 'cone'
						ct = (@size*x)+z
						angle = MathUtils.degToRad(ct * incInc)
						height = 128
						curHeight = (y / @size) * height
						radius = halfSpace
						_x = (radius * Math.cos(angle)) * ((height - curHeight) / height)
						_y = -(curHeight-(height*0.5))
						_z = (radius * Math.sin(angle)) * ((height - curHeight) / height)


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

					scalar = 0
					if @depthOn
						scalar = (node.position.z / (@spacing*@size))
						sp.scale.x = sp.scale.y = (1 + Math.exp(min + scalar)) * @isometricScale
						sp.position.x = ((node.position.x * sp.scale.x) + (scalar * @xOffset))# * @isometricScale
						sp.position.y = ((node.position.y * sp.scale.y) + (scalar * @yOffset))# * @isometricScale
					else if @perspectiveOn
						div = (@focalLength + (node.position.z-@cameraPosition))
						if div != 0
							scalar = @focalLength / div
						else
							scalar = 0
						sp.scale.x = sp.scale.y = 10 * scalar
						sp.position.x = (node.position.x - @xOffset) * (scalar * 10)
						sp.position.y = -(node.position.y - @yOffset) * (scalar * 10)
					else
						sp.scale.x = sp.scale.y = 1
						sp.position.x = node.position.x
						sp.position.y = node.position.y

					
					
					sp.alpha = 0.4
					i++
		null