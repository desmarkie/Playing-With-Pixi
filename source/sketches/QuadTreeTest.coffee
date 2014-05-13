# import objects.Point
# import objects.AABB
# import objects.QuadTree
# import utils.MathUtils
# import utils.ColourConversion
class QuadTreeTest extends Sketch

	constructor: (@renderer, @name) ->
		super @renderer, @name
		@numPoints = 20
		@points = []
		@pointSprites = []
		@deadSprites = []

	load: =>

		if not @loaded
			#creates a dat.GUI folder, access via @gui
			@makeGui()

			@moving = true
			@render = false
			@circles = false
			@childless = false

			# generate circle texture from graphics
			circle = new PIXI.Graphics()
			circle.beginFill 0xf3f3f3
			circle.drawCircle 0, 0, 5
			circle.endFill()
			@circleTex = circle.generateTexture()

			@canvasHolder = new PIXI.DisplayObjectContainer()
			@view.addChild @canvasHolder

			@canvas = new PIXI.Graphics()
			@canvasHolder.addChild @canvas

			@pointHolder = new PIXI.DisplayObjectContainer()
			@pointHolder.alpha = 0
			@view.addChild @pointHolder

			size = Math.min(window.innerWidth-50, window.innerHeight-50)
			@bounds = new AABB(new Point(window.innerWidth*0.5, window.innerHeight*0.5), new Point(size, size))
			@tree = new QuadTree(@bounds, 1, 10, 0)

			@gui.add(@, 'moving').name('Motion On').listen()
			@gui.add(@, 'render').name('Colour Fill').listen()
			@gui.add(@, 'circles').name('Circles').listen()
			@gui.add(@, 'childless').name('Only Smallest').listen()
			@gui.add(@, 'numPoints', 2, 1000, 1).name('Points').onChange(=>
				if @numPoints > 225 and @moving then @moving = false
			)
			@gui.add(@, 'generateNewMap').name('Generate')
			@gui.add(@pointHolder, 'alpha', 0, 1).name('Points Alpha')

			@renderSprite = new PIXI.Sprite @canvasHolder.generateTexture()
			@canvasHolder.addChild @renderSprite
			@renderSprite.alpha = 0
			@canvasHolder.addChild @canvas

		@waiting = false

		@generateNewMap()

		super()

		null

	unload: =>

		super()
		null

	update: =>
		super()
		if @cancelled then return

		if window.app.mousePressed and !@waiting
			@waiting = true
		else if !window.app.mousePressed and @waiting
			@waiting = false
			@generateNewMap()

		# @testSprite.position.x = window.app.pointerPosition.x
		# @testSprite.position.y = window.app.pointerPosition.y

		if @moving
			i = 0
			@tree.clear()
			for pt in @points
				nx = pt.center.x + pt.velocity.x
				ny = pt.center.y + pt.velocity.y
				if nx > @bounds.xMax then nx -= @bounds.dimensions.x
				else if nx < @bounds.xMin then nx += @bounds.dimensions.x
				if ny > @bounds.yMax then ny -= @bounds.dimensions.y
				else if ny < @bounds.yMin then ny += @bounds.dimensions.y
				pt.setCenter new Point(nx, ny)
				@pointSprites[i].position.x = nx
				@pointSprites[i].position.y = ny
				i++
				@tree.insert pt

			@canvas.clear()
			if @circles
				@renderSprite.alpha = 0
				@renderSprite.setTexture @canvasHolder.generateTexture()
				@renderSprite.alpha = 1
				@circleFill @tree
				# @circles = false
			else
				@renderSprite.alpha = 0
				@drawTree @tree

		if @render
			@renderSprite.alpha = 0
			@canvas.lineStyle null
			@colourTree @tree
			@render = false

		if @circles and !@moving
			@canvas.clear()
			@renderSprite.alpha = 1
			@renderSprite.setTexture @canvasHolder.generateTexture()
			@circleFill @tree
			@circles = false

		null

	resize: =>

		null

	generateNewMap: =>
		if @pointSprites.length > 0
			for i in [@pointSprites.length-1..0]
				sp = @pointSprites[i]
				@pointSprites.splice i, 1
				@deadSprites.push sp
				@pointHolder.removeChild sp

		@tree.clear()

		@generatePoints()
		@addPointSprites()

		for pt in @points
			@tree.insert pt

		@renderSprite.alpha = 0
		@canvas.clear()
		@drawTree @tree
		null

	drawTree: (tree) =>
		@canvas.lineStyle 1, 0xF3F3F3
		@canvas.drawRect tree.boundsAABB.xMin, tree.boundsAABB.yMin, tree.boundsAABB.dimensions.x, tree.boundsAABB.dimensions.y
		for child in tree.children
			@drawTree child
		null

	colourTree: (tree) =>
		if tree.children.length is 0 or !@childless
			hex = @getColour tree
			@canvas.beginFill hex
			@canvas.drawRect tree.boundsAABB.xMin, tree.boundsAABB.yMin, tree.boundsAABB.dimensions.x, tree.boundsAABB.dimensions.y
			@canvas.endFill()

		for child in tree.children
			@colourTree child
		null

	circleFill: (tree) =>
		hex = @getColour tree

		if tree.children.length is 0 or !@childless
			@canvas.clear()
			@canvas.lineStyle 1, hex
			@canvas.drawCircle tree.boundsAABB.center.x, tree.boundsAABB.center.y, tree.boundsAABB.dimensions.x*0.5
			@renderSprite.setTexture @canvasHolder.generateTexture()

		for child in tree.children
			@circleFill child

		null

	getColour: (tree) =>
		xd = tree.boundsAABB.center.x - @bounds.center.x
		yd = tree.boundsAABB.center.y - @bounds.center.y
		dist = Math.sqrt((xd*xd)+(yd*yd))
		angRad = Math.atan2(yd,xd)
		angDeg = MathUtils.radToDeg(angRad)
		if angDeg < 0 then angDeg += 360
		sat = 10 + (90 * (dist / @bounds.dimensions.x))
		br = 100 - (70 * (tree.boundsAABB.dimensions.x / @bounds.dimensions.x))
		return ColourConversion.hsbToHex [angDeg, sat, br]

	generatePoints: ->
		@points = []
		for i in [0...@numPoints]
			tx = @bounds.xMin + (Math.random() * @bounds.dimensions.x)
			ty = @bounds.yMin + (Math.random() * @bounds.dimensions.y)
			p = new AABB(new Point(tx, ty), new Point(10, 10))
			@points.push p
			p.velocity = {x:-2+(Math.random()*4), y:-2+(Math.random()*4)}
		null

	addPointSprites: ->
		@pointSprites = []
		for p in @points
			if @deadSprites.length is 0
				sp = new PIXI.Sprite @circleTex
				sp.anchor.x = sp.anchor.y = 0.5
			else
				sp = @deadSprites[0]
				@deadSprites.splice 0, 1
			sp.position.x = p.center.x
			sp.position.y = p.center.y
			@pointHolder.addChild sp
			@pointSprites.push sp