#import sketches.Sketch
#import utils.MathUtils
class Spirals extends Sketch

	@id: 'Spirals'

	midPoint: null

	nodes: []
	deadNodes: []

	newNodeCount: 1
	newNodeLimit: 10

	changeCount: 720
	changeLimit: 720

	rotateSpeed: 11
	moveSpeed: 0.6

	sqDist: 100


	constructor: (@renderer) ->
		super(@renderer)

	load: =>
		if not @loaded
			@stage = new PIXI.Stage(window.app.stageColor)

			@view = document.createElement('div')
			@view.appendChild @renderer.view

			@gui = new dat.GUI({autoPlace:false})
			@gui.domElement.style.zIndex = 100
			@gui.domElement.style.position = 'absolute'
			@gui.domElement.style.top = 0
			@gui.domElement.style.left = 0
			@gui.domElement.style.height = 'auto'
			@view.appendChild @gui.domElement
			@gui.add(@, 'rotateSpeed', -50, 50).listen().onChange(=>
				@changeCount = @changeLimit
			)
			@gui.add(@, 'moveSpeed', 0.1, 10).listen().onChange(=>
				@changeCount = @changeLimit
			)
			@gui.close()

		@midPoint = {x:window.innerWidth * 0.5, y:window.innerHeight * 0.5}

		@sqDist = (window.innerWidth*0.5)*(window.innerWidth*0.5)

		@view.appendChild @renderer.view

		@randomisePattern()

		super()
		null

	unload: =>
		super()
		null

	update: =>
		super()
		if @cancelled then return

		if window.app.spacePressed
			@changeCount = @changeLimit
			window.app.spacePressed = false
			@randomisePattern()


		@newNodeCount--
		if @newNodeCount == 0
			@newNodeCount = @newNodeLimit
			newNode = @createNode()
			@nodes.push newNode
			@stage.addChild newNode.sprite

		@changeCount--
		if @changeCount == 0
			@randomisePattern()
			@changeCount = @changeLimit

		@updateNodes()

		@renderer.render @stage
		null

	resize: =>
		@midPoint.x = window.innerWidth * 0.5
		@midPoint.y = window.innerHeight * 0.5
		@sqDist = (window.innerWidth*0.5)*(window.innerWidth*0.5)
		# console.log 'RESIZED '+@midPoint
		null

	randomisePattern: =>
		TweenMax.to @, 0.5, {rotateSpeed:-50+(Math.random()*100), ease:Power4.easeOut}
		TweenMax.to @, 0.5, {moveSpeed:Math.random()*3, ease:Power4.easeOut}
		null

	updateNodes: =>
		for i in [@nodes.length-1..0] by -1
			node = @nodes[i]
			node.y += @moveSpeed
			angle = MathUtils.degToRad node.phase
			newx = -node.y * Math.sin angle
			newy = node.y * Math.cos angle
			node.sprite.position.x = @midPoint.x + newx
			node.sprite.position.y = @midPoint.y + newy
			node.phase += @rotateSpeed
			node.phase %= 360
			node.sprite.scale.x = node.sprite.scale.y = 0.25 + ((@distToMidpoint(node)/@sqDist)*4)
			if (newx - (16*5) + @midPoint.x) > window.innerWidth
				@stage.removeChild node.sprite
				@nodes.splice i, 1
				@deadNodes.push node
		null

	distToMidpoint: (node) =>
		xDif = @midPoint.x - node.sprite.position.x
		yDif = @midPoint.y - node.sprite.position.y
		return (xDif * xDif) + (yDif * yDif)

	createNode: =>
		if @deadNodes.length is 0
			node = {y:0, x:0, sprite:@createSprite(), phase:0}
		else
			node = @deadNodes[0]
			@deadNodes.splice 0, 1
			node.y = 0
			node.x = 0
			node.phase = 0
		return node

	createSprite: =>
		sp = new PIXI.Sprite(window.app.textures[0])
		sp.pivot.x = 16
		sp.pivot.y = 16
		return sp