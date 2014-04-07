class Stacks extends Sketch

	yCount: 30
	xCount: 40
	minSpeed: -40
	maxSpeed: 40

	tgtScale: 1

	nodes: []
	deadNodes: []

	constructor: (@renderer, @name) ->
		super @renderer, @name

	load: =>
		if not @loaded
			@makeGui()

			@createSprites()

			@gui.add(@, 'minSpeed', -40, 40).listen().onChange(=>
				if @maxSpeed < @minSpeed then @minSpeed = @maxSpeed
				@randomiseSpeeds()
			)
			@gui.add(@, 'maxSpeed', -40, 40).listen().onChange(=>
				if @maxSpeed < @minSpeed then @minSpeed = @maxSpeed
				@randomiseSpeeds()
			)


		

		super()
		null

	unload: =>

		super()
		null

	update: =>
		super()
		if @cancelled then return

		@updateNodes()



		null

	resize: =>

		null


	updateNodes: ->
		winWidth = window.innerWidth
		for i in [0..@xCount-1]
			for j in [0..@yCount-1]
				node = @nodes[i][j]
				node.sprite.position.x += node.speed
				if node.sprite.position.x <= 0
					node.sprite.position.x = 0.1
					node.speed *= -1
				else if node.sprite.position.x >= winWidth
					node.sprite.position.x = winWidth-0.1
					node.speed *= -1

				if @nodes[i+1]
					if node.sprite.position.x >= @nodes[i+1][j].sprite.position.x - (16*@tgtScale)
						xdif = Math.abs(node.sprite.position.x - @nodes[i+1][j].sprite.position.x) - (16.2*@tgtScale)
						if xdif < 0 then xdif *= -1
						newSpeed = @nodes[i+1][j].speed
						totSpeed = newSpeed + node.speed
						@nodes[i+1][j].speed = node.speed
						node.speed = newSpeed
						node.sprite.position.x -= xdif*0.5
						@nodes[i+1][j].sprite.position.x += xdif*0.5
						###
						ms 4
						os 2
						os / (ms + os)
						2 / (4 + 2)
						###

		null

	createSprites: ->

		@tgtScale = (window.innerHeight / (@yCount-1)) / 30

		@nodes = []
		for i in [0..@xCount-1]
			@nodes[i] = []
			for j in [0..@yCount-1]
				@nodes[i][j] = {sprite:@addSprite(i, j), speed:0}

		@randomiseSpeeds()

		null

	addSprite: (x, y) ->
		sp = new PIXI.Sprite(window.app.textures[0])
		sp.pivot.x = sp.pivot.y = 16
		sp.position.x = x * (window.innerWidth / @xCount)#(32 * @tgtScale)
		sp.position.y = y * (30 * @tgtScale)
		sp.scale.x = sp.scale.y = @tgtScale
		@view.addChild(sp)
		return sp

	randomiseSpeeds: =>
		speedDif = @maxSpeed - @minSpeed

		for i in [0..@xCount-1]
			for j in [0..@yCount-1]
				@nodes[i][j].speed = @minSpeed + (Math.random() * speedDif)
		null