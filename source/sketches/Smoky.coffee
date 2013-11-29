# import sketches.Sketch
# import objects.Node
class Smoky extends Sketch

	@id: 'Smoky'

	numNodes: 200

	checkDist: 100
	checkDistSq: 0

	nodes: []
	sprites: []

	constructor: (@renderer) ->
		@checkDistSq = @checkDist * @checkDist
		super(@renderer)

	load: =>
		if @loaded 
			window.onmousemove = @mouseMove
			@windowWidth = window.innerWidth;
			@windowHeight = window.innerHeight;

			@areaWidth = @windowWidth + 400
			@areaHeight = @windowHeight + 400

			@view.appendChild @renderer.view
			super()
			return

		@windowWidth = window.innerWidth;
		@windowHeight = window.innerHeight;

		@areaWidth = @windowWidth + 400
		@areaHeight = @windowHeight + 400

		@stage = new PIXI.Stage(window.app.stageColor)

		@view = document.createElement('div')
		@view.appendChild @renderer.view

		@createNodes()

		@createSprites()

		window.onmousemove = @mouseMove

		super()
		console.log 'LOAD DONE :: '+Smoky.id

	unload: =>
		window.onmousemove = null
		###
		for sp in @sprites
			@stage.removeChild sp
			sp = null

		for node in @nodes
			node = null

		@windowWidth = @windowHeight = null
		@areaWidth = @areaHeight = null
		@renderer = null
		@stage = null
		@view = null
		@nodes = []
		@sprites = []
		###
		super()

		# @tex.destroy true

		console.log 'DESTROYED IT '+@cancelled

		null

	resize: =>
		null

	createNodes: ->
		console.log 'CREATING NODES'
		for i in [0..@numNodes] by 1
			@nodes.push new Node(Math.random()*@windowWidth, Math.random()*@windowHeight)
		null

	createSprites: ->
		console.log 'CREATING SPRITES'
		# @tex = PIXI.Texture.fromImage('/img/node.png?cb='+new Date().getTime())
		@tex = window.app.textures[0]
		for i in [0..@numNodes] by 1
			sp = new PIXI.Sprite @tex
			sp.pivot.x = 16
			sp.pivot.y = 16
			sp.blendMode = PIXI.blendModes.SCREEN
			sp.alpha = 0.1 + (Math.random() * 0.2)
			@sprites.push sp
			@stage.addChild sp
		null

	updateSprites: ->
		for i in [0..@numNodes] by 1
			@nodes[i].x += @nodes[i].xVel
			@nodes[i].y += @nodes[i].yVel

			@nodes[i].sinPos += @nodes[i].sinIncrement
			@nodes[i].sinPos %= 360
			@nodes[i].scale = 10 + (Math.sin(@nodes[i].sinPos*(Math.PI/180)) * @nodes[i].scaleAmount)

			if @nodes[i].x > @windowWidth + 200 then @nodes[i].x -= @areaWidth
			else if @nodes[i].x < -200 then @nodes[i].x += @areaWidth

			if @nodes[i].y > @windowHeight + 200 then @nodes[i].y -= @areaHeight
			else if @nodes[i].y < -200 then @nodes[i].y += @areaHeight

			distTo = @distanceTo(@nodes[i], {x:@curX, y:@curY})
			if distTo.dist < @checkDistSq
				@nodes[i].xVel = ((distTo.xDif*-1) / @checkDist) * 5
				@nodes[i].yVel = ((distTo.yDif*-1) / @checkDist) * 5

			@sprites[i].position.x = @nodes[i].x
			@sprites[i].position.y = @nodes[i].y
			@sprites[i].scale.x = @sprites[i].scale.y = @nodes[i].scale
		null

	distanceTo: (object, target) ->
		xDif = target.x - object.x
		yDif = target.y - object.y
		return {xDif:xDif, yDif:yDif, dist:(xDif*xDif)+(yDif*yDif)}

	update: =>
		super()
		if @cancelled then return
		@updateSprites()
		@renderer.render @stage
		null

	mouseMove: (e) =>
		@curX = e.pageX
		@curY = e.pageY
		null