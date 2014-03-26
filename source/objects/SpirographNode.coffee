# import utils.MathUtils
# import utils.ColourConversion
class SpirographNode extends Node

	constructor: (x = 0, y = 0, z = 0) ->
		super x, y, z

		@midX = window.innerWidth * 0.5
		@midY = window.innerHeight * 0.5

		@sin = 0
		@speed = 1
		@radSin = 0
		@radSpeed = 10
		@radMin = 180
		@radMax = 260

		@tailWidth = 3

		@color = 120
		@colorSpeed = 0
		@hsb = [@color, 100, 100]
		@hex = ColourConversion.hsbToHex @hsb

		@recordedPositions = 90
		@positions = []
		@fillPositions()

		@view = new PIXI.DisplayObjectContainer

		# @main = new PIXI.Sprite window.app.textures[0]
		# @main.pivot.x = @main.pivot.y = 16
		# @main.tint = @hex

		@graphics = new PIXI.Graphics()
		@view.addChild @graphics
		# @view.addChild @main

		@randomSpeeds = [0.1, 1.1, 59.9, 60.4, 120.1, 180.6, 240.2, 300.1, 75.5, 25.2]
		@randomSmallRads = [0, 30, 60, 180, 90, 45, 40, 75, 130, 140, 150, 160]
		@randomBigRads = [227, 240, 300, 248, 200, 187, 210, 195, 320, 305, 310]

		# @randomise()

	randomise: =>
		s1 = @randomSpeeds[Math.floor(Math.random()*@randomSpeeds.length)]
		s2 = @randomSpeeds[Math.floor(Math.random()*@randomSpeeds.length)]
		r1 = @randomSmallRads[Math.floor(Math.random()*@randomSmallRads.length)]
		r2 = @randomBigRads[Math.floor(Math.random()*@randomBigRads.length)]
		TweenMax.to @, 1.5, {radMin:r1, radMax:r2, speed:s1, radSpeed:s2, colorSpeed:Math.random()}
		null

	update: =>
		@radSin += @radSpeed
		@radSin %= 360
		radius = @radMin + (Math.sin(MathUtils.degToRad @radSin) * (@radMax - @radMin))
		@sin += @speed
		@sin %= 360
		x = -Math.sin(MathUtils.degToRad @sin) * radius
		y = Math.cos(MathUtils.degToRad @sin) * radius
		@moveTo x+@midX, y+@midY, 0
		# @main.position.x = @position.x
		# @main.position.y = @position.y
		@color += @colorSpeed
		@color %= 360
		@drawTrails()
		null

	updateTint: =>
		@hsb = [@color, 100, 100]
		@hex = ColourConversion.hsbToHex @hsb
		# @main.tint = @hex
		null

	drawTrails: =>
		@graphics.clear()
		inc = 1 / @recordedPositions
		tInc = @tailWidth / @recordedPositions
		ptA = @positions[0]
		ptB = null
		for i in [0...@positions.length-1]
			ptA = @positions[i]
			ptB = @positions[i+1]
			@hsb = [@color, 100, 100]
			@hex = ColourConversion.hsbToHex @hsb
			@graphics.lineStyle i*tInc, @hex, i*inc
			@graphics.moveTo ptA.x, ptA.y
			@graphics.lineTo ptB.x, ptB.y
		null