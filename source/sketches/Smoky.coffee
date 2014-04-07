# import sketches.Sketch
# import objects.*
class Smoky extends Sketch

	@id: 'Smoky'

	numNodes: 200

	checkDist: 100
	checkDistSq: 0

	nodes: []
	sprites: []

	constructor: (@renderer, @name) ->
		@checkDistSq = @checkDist * @checkDist
		super @renderer, @name

	load: =>
		if @loaded 
			# window.onmousemove = @mouseMove
			@windowWidth = window.innerWidth;
			@windowHeight = window.innerHeight;

			@areaWidth = @windowWidth + 400
			@areaHeight = @windowHeight + 400

			
			super()
			return

		@windowWidth = window.innerWidth;
		@windowHeight = window.innerHeight;

		@areaWidth = @windowWidth + 400
		@areaHeight = @windowHeight + 400

		@createNodes()

		@createSprites()

		super()

	unload: =>
		super()
		null

	resize: =>
		null

	createNodes: ->
		for i in [0..@numNodes] by 1
			n = new Node(Math.random()*@windowWidth, Math.random()*@windowHeight)
			n.velocity.x = 3 - (6*Math.random())
			n.velocity.y = 3 - (6*Math.random())
			n.sinPos = Math.random() * 360
			n.sinIncrement = Math.random() * 0.5
			n.scaleAmount = (Math.random() * 2)
			@nodes.push n
		null

	createSprites: ->
		@tex = window.app.textures[0]
		for i in [0..@numNodes] by 1
			sp = new PIXI.Sprite @tex
			sp.pivot.x = 16
			sp.pivot.y = 16
			sp.blendMode = PIXI.blendModes.SCREEN
			sp.alpha = 0.1 + (Math.random() * 0.2)
			@sprites.push sp
			@view.addChild sp
		null

	updateSprites: ->
		for i in [0..@numNodes] by 1
			node = @nodes[i]
			node.position.x += node.velocity.x
			node.position.y += node.velocity.y

			node.sinPos += node.sinIncrement
			node.sinPos %= 360
			node.scale = 10 + (Math.sin(node.sinPos*(Math.PI/180)) * node.scaleAmount)

			if node.position.x > @windowWidth + 200 then node.position.x -= @areaWidth
			else if node.position.x < -200 then node.position.x += @areaWidth

			if node.position.y > @windowHeight + 200 then node.position.y -= @areaHeight
			else if node.position.y < -200 then node.position.y += @areaHeight

			distTo = @distanceTo({x:node.position.x, y:node.position.y}, {x:@curX, y:@curY})
			if distTo.dist < @checkDistSq
				node.velocity.x = ((distTo.xDif*-1) / @checkDist) * 5
				node.velocity.y = ((distTo.yDif*-1) / @checkDist) * 5

			sp = @sprites[i]
			sp.position.x = node.position.x
			sp.position.y = node.position.y
			sp.scale.x = sp.scale.y = node.scale
		null

	distanceTo: (object, target) ->
		xDif = target.x - object.x
		yDif = target.y - object.y
		return {xDif:xDif, yDif:yDif, dist:(xDif*xDif)+(yDif*yDif)}

	update: =>
		super()
		if @cancelled then return
		@curX = window.app.pointerPosition.x
		@curY = window.app.pointerPosition.y
		@updateSprites()

		null

	mouseMove: (e) =>
		@curX = e.pageX
		@curY = e.pageY
		null