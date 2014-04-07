class Orbits extends Sketch

	constructor: (@renderer, @name) ->
		super @renderer, @name

	load: =>

		if not @loaded
			@makeGui()

			@midx = window.innerWidth * 0.5
			@midy = window.innerHeight * 0.5

			@baseNode = new Node @midx, @midy
			@baseNode.xSin = 0
			@baseNode.ySin = 0
			@baseNode.xIncrement = 19.6
			@baseNode.yIncrement = 35.2
			@baseNode.xOffset = 726
			@baseNode.yOffset = 217

			@numSattelites = 10
			@easing = 50
			@tailLength = 60
			@tailWidth = 6.2
			@initialSpacing = 60
			@nodes = []

			@maxSpeed = 175
			@tailColour = 0x8CF1FF

			for i in [0..@numSattelites-1]
				tx = @midx + (Math.cos(Math.random() * Math.PI) * @initialSpacing)
				ty = @midy + (Math.sin(Math.random() * Math.PI) * @initialSpacing)
				n = new Node tx, ty
				n.recordedPositions = @tailLength
				n.fillPositions()
				@nodes.push n

			@graphics = new PIXI.Graphics()
			@view.addChild @graphics

			@gui.addColor @, 'tailColour'
			@gui.add @, 'tailWidth', 2, 100
			@gui.add @, 'maxSpeed', 2, 1000
			@gui.add @, 'easing', 2, 100
			@gui.add @baseNode, 'xOffset', 0, 1000
			@gui.add @baseNode, 'yOffset', 0, 1000
			@gui.add @baseNode, 'xIncrement', 0.1, 359.9
			@gui.add @baseNode, 'yIncrement', 0.1, 359.9

		

		super()

		null

	unload: =>

		super()
		null

	update: =>
		super()
		if @cancelled then return

		@graphics.clear()

		@baseNode.xSin += @baseNode.xIncrement
		@baseNode.xSin %= 360
		@baseNode.ySin += @baseNode.yIncrement
		@baseNode.ySin %= 360

		@baseNode.position.x = @midx + (Math.cos(@baseNode.xSin*window.app.degToRad) * @baseNode.xOffset)
		@baseNode.position.y = @midy + (Math.cos(@baseNode.ySin*window.app.degToRad) * @baseNode.yOffset)

		for i in [0..@numSattelites-1]
			n = @nodes[i]
			xdif = @baseNode.position.x - n.position.x
			ydif = @baseNode.position.y - n.position.y
			n.velocity.x += xdif / @easing
			n.velocity.y += ydif / @easing
			if n.velocity.x > @maxSpeed then n.velocity.x = @maxSpeed
			else if n.velocity.x < -@maxSpeed then n.velocity.x = -@maxSpeed
			if n.velocity.y > @maxSpeed then n.velocity.y = @maxSpeed
			else if n.velocity.y < -@maxSpeed then n.velocity.y = -@maxSpeed
			newx = n.position.x + n.velocity.x
			newy = n.position.y + n.velocity.y
			n.moveTo newx, newy
			@drawTail n



		null

	resize: =>

		null

	drawTail: (node) =>
		inc = 1 / @tailLength
		tailInc = @tailWidth / @tailLength
		for i in [0..@tailLength-2]
			if @tailWidth > 1
				@graphics.lineStyle tailInc*i, @tailColour, i*inc
			else
				@graphics.lineStyle @tailWidth, @tailColour, i*inc
			pt1 = node.positions[i]
			pt2 = node.positions[i+1]
			@graphics.moveTo pt1.x, pt1.y
			@graphics.lineTo pt2.x, pt2.y
		null