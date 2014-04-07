class Ribbon extends Sketch

	constructor: (@renderer, @name) ->
		super @renderer, @name

	load: =>

		if not @loaded
			@midx = window.innerWidth * 0.5
			@midy = window.innerHeight * 0.5

			@baseNode = new Node @midx, @midy
			@baseNode.xSin = 0
			@baseNode.ySin = 0
			@baseNode.xIncrement = 2.9
			@baseNode.yIncrement = 3.7
			@baseNode.xOffset = 470
			@baseNode.yOffset = 220

			@ribbonWidth = 200

			@trailLength = 60

			@tailColour = 0xFFFFFF

			@nodeA = new Node @baseNode.position.x, @baseNode.position.y - @ribbonWidth
			@nodeB = new Node @baseNode.position.x, @baseNode.position.y + @ribbonWidth
			@nodeA.recordedPositions = @nodeB.recordedPositions = @trailLength
			@nodeA.fillPositions()
			@nodeB.fillPositions()
			@nodeA.sin = 0
			@nodeB.sin = 0
			@nodeA.inc = 4.6
			@nodeB.inc = 3.2

			@graphics = new PIXI.Graphics()


			@tailA = []
			@tailB = []

			# inc = 1 / @trailLength
			# for i in [0..@trailLength-1]
			# 	sp = new PIXI.Sprite window.app.textures[0]
			# 	sp.pivot.x = sp.pivot.y = 16
			# 	sp.scale.x = sp.scale.y = 0.35
			# 	sp.alpha = i * inc
			# 	sp.position.x = @nodeA.position.x
			# 	sp.position.y = @nodeA.position.y
			# 	@view.addChild sp
			# 	@tailA.push sp

			@view.addChild @graphics

			# for i in [0..@trailLength-1]
			# 	sp = new PIXI.Sprite window.app.textures[0]
			# 	sp.pivot.x = sp.pivot.y = 16
			# 	sp.scale.x = sp.scale.y = 0.35
			# 	sp.alpha = i * inc
			# 	sp.position.x = @nodeB.position.x
			# 	sp.position.y = @nodeB.position.y
			# 	@view.addChild sp
			# 	@tailB.push sp


			# @baseSprite = new PIXI.Sprite window.app.textures[0]
			# @baseSprite.pivot.x = @baseSprite.pivot.y = 16
			# @baseSprite.position.x = @baseNode.position.x
			# @baseSprite.position.y = @baseNode.position.y

			# @view.addChild @baseSprite

			@makeGui()

			@gui.add @, 'ribbonWidth', 1, 200
			@gui.addColor @, 'tailColour'
			@gui.add @baseNode, 'xOffset', 0, 1000
			@gui.add @baseNode, 'yOffset', 0, 1000
			@gui.add @baseNode, 'xIncrement', 0.1, 359.9
			@gui.add @baseNode, 'yIncrement', 0.1, 359.9
			@gui.add @nodeA, 'inc', 0.1, 359.9
			@gui.add @nodeB, 'inc', 0.1, 359.9


		

		super()

		null

	unload: =>

		super()
		null

	update: =>
		super()
		if @cancelled then return

		@baseNode.xSin += @baseNode.xIncrement
		@baseNode.xSin %= 360
		@baseNode.ySin += @baseNode.yIncrement
		@baseNode.ySin %= 360

		@baseNode.position.x = @midx + (Math.cos(@baseNode.xSin*window.app.degToRad) * @baseNode.xOffset)
		@baseNode.position.y = @midy + (Math.cos(@baseNode.ySin*window.app.degToRad) * @baseNode.yOffset)

		# @baseSprite.position.x = @baseNode.position.x
		# @baseSprite.position.y = @baseNode.position.y

		@nodeA.sin += @nodeA.inc
		@nodeA.sin %= 360
		ty = @baseNode.position.y - (Math.sin(@nodeA.sin * window.app.degToRad) * @ribbonWidth)
		@nodeA.moveTo @baseNode.position.x, ty

		@nodeB.sin += @nodeB.inc
		@nodeB.sin %= 360
		ty = @baseNode.position.y + (Math.sin(@nodeB.sin * window.app.degToRad) * @ribbonWidth)
		@nodeB.moveTo @baseNode.position.x, ty

		# @updateTrails()

		@drawRibbon()



		null

	resize: =>

		null

	updateTrails: =>
		for i in [0..@trailLength-1]
			sp = @tailA[i]
			sp.position.x = @nodeA.positions[i].x
			sp.position.y = @nodeA.positions[i].y
			sp = @tailB[i]
			sp.position.x = @nodeB.positions[i].x
			sp.position.y = @nodeB.positions[i].y
		null

	drawRibbon: =>
		@graphics.clear()

		inc = 1 / @trailLength
		for i in [0..@trailLength-2]
			pt1 = @nodeA.positions[i]
			pt2 = @nodeB.positions[i]
			pt3 = @nodeA.positions[i+1]
			pt4 = @nodeB.positions[i+1]
			@graphics.beginFill @tailColour, (i * inc)
			@graphics.moveTo pt1.x, pt1.y
			@graphics.lineTo pt3.x, pt3.y
			@graphics.lineTo pt4.x, pt4.y
			@graphics.lineTo pt2.x, pt2.y
			@graphics.endFill()

		null