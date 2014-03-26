# import utils.ColourConversion
# import utils.MathUtils
class SquidNode extends Node

	constructor: (x_ = 0, y_ = 0, z_ = 0) ->
		super 0, 0, z_

		@basePosition = {x:x_, y:y_}

		@color = 0
		@tailColor = 0

		@view = new PIXI.DisplayObjectContainer()

		@graphics = new PIXI.Graphics()
		@view.addChild @graphics

		@head = new PIXI.Sprite window.app.textures[0]
		@head.pivot.x = @head.pivot.y = 16
		@view.addChild @head

		@setColor @color

		@tailWidth = 3
		@tailSpread = 40

		@recordedPositions = 120
		@positions = []
		@firstUpdate = true

		@nodes = []
		for i in [0...5]
			n = new Node()
			n.recordedPositions = @recordedPositions
			n.fillPositions()
			n.sin = Math.random() * 360
			n.inc = 2 + (3 * Math.random())
			@nodes.push n

		###
		make it spin
		around it's position
		###

		@sin = 0
		@speed = 1
		@radSin = 0
		@radSpeed = 5
		@radMin = 200
		@radMax = 240



	setColor: (value) =>
		@color = value
		@hsb = [@color, 100, 100]
		@hex = ColourConversion.hsbToHex @hsb
		@head.tint = @hex
		null

	setTailColor: (value) =>
		@tailColor = value
		null

	update: =>
		@sin += @speed
		@sin %= 360
		@radSin += @radSpeed
		@radSin %= 360

		psin = Math.sin(MathUtils.degToRad @sin)
		pcos = Math.cos(MathUtils.degToRad @sin)
		radius = @radMin + (Math.sin(MathUtils.degToRad @radSin) * (@radMax - @radMin))

		x = -psin * radius
		y = pcos * radius
		@moveTo @basePosition.x + x, @basePosition.y + y

		if @firstUpdate
			@fillPositions()
			@firstUpdate = false

		@head.position.x = @position.x
		@head.position.y = @position.y

		alphaInc = 1 / @recordedPositions
		widthInc = @tailWidth / @recordedPositions

		@graphics.clear()
		for i in [0...@positions.length-1]
			ptA = @positions[i]
			ptB = @positions[i+1]
			@graphics.lineStyle i*widthInc, @hex, i*alphaInc
			@graphics.moveTo ptA.x, ptA.y
			@graphics.lineTo ptB.x, ptB.y

		for node in @nodes
			node.sin += node.inc
			node.sin %= 360
			x = 0
			y = Math.sin(MathUtils.degToRad node.sin) * @tailSpread
			xdif = @positions[@recordedPositions-2].x - @positions[@recordedPositions-1].x
			ydif = @positions[@recordedPositions-2].y - @positions[@recordedPositions-1].y
			ang = Math.atan2 ydif, xdif
			nx = -Math.sin(ang) * y
			ny = Math.cos(ang) * y
			node.moveTo nx, ny
			@drawNodePath node

		null

	drawNodePath: (node) =>
		alphaInc = 1 / @recordedPositions
		widthInc = @tailWidth / @recordedPositions
		scale = 1
		for i in [0...node.positions.length-1]
			ptA = node.positions[i]
			ptB = node.positions[i+1]
			oA = @positions[i]
			oB = @positions[i+1]
			scale = 1 - (i / @recordedPositions)
			@graphics.lineStyle i*widthInc, @hex, i*alphaInc
			@graphics.moveTo oA.x + (ptA.x * scale), oA.y + (ptA.y * scale)
			@graphics.lineTo oB.x + (ptB.x * scale), oB.y + (ptB.y * scale)
		null