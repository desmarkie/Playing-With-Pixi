# import objects.Node
# import objects.CometSparkParticle
# import utils.ColourConversion
class CometParticle extends Node

	constructor: (x = 0, y = 0, z = 0) ->
		super x, y, z

		@life = 240
		@totalLife = 240

		@maxSpeed = 40
		@minSpeed = 20

		@children = []
		@pool = []
		@maxChildren = 5

		@recordedPositions = 30
		@fillPositions()

		@view = new PIXI.DisplayObjectContainer()
		@view.position.x = @position.x
		@view.position.y = @position.y

		@main = new PIXI.Sprite window.app.textures[0]
		@main.pivot.x = @main.pivot.y = 16

		@color = 240
		@setColor @color

		@sparkColor = 300

		@view.addChild @main

		for i in [0...@maxChildren]
			@fireSpark()

	setColor: (value) =>
		@color = value
		hsb = [@color, 18, 100]
		hex = ColourConversion.hsbToHex hsb
		@main.tint = hex
		null

	setSparkColor: (value) =>
		@sparkColor = value
		for spark in @children
			spark.setColor @sparkColor
		null

	randomiseVelocity: (ranx = true, rany = true) =>
		if ranx then @velocity.x = @minSpeed + (Math.random() * (@maxSpeed - @minSpeed))
		if rany then @velocity.y = -(@maxSpeed*0.1) + (Math.random() * (@maxSpeed*0.2))
		null

	headForMouse: =>
		easing = 25
		xdif = window.app.pointerPosition.x - @position.x
		ydif = window.app.pointerPosition.y - @position.y
		@velocity.x = xdif / easing
		@velocity.y = ydif / easing
		null

	update: =>
		if @life is 0 then return
		@moveTo @position.x + @velocity.x, @position.y + @velocity.y, @position.z + @velocity.z
		@velocity.x *= 0.98
		@velocity.y *= 0.98
		@velocity.z *= 0.98
		@life--
		@main.scale.x = @main.scale.y = 0.7 + (Math.random() * 2)
		@view.alpha = @life / @totalLife
		@view.position.x = @position.x
		@view.position.y = @position.y

		@updateSparks()
		while @children.length < @maxChildren
			@fireSpark()

		null

	updateSparks: =>
		for i in [@children.length-1..0] by -1
			spark = @children[i]
			spark.update()
			if spark.life is 0
				@children.splice i, 1
				@pool.push spark
				@view.removeChild spark.view
		null

	fireSpark: =>
		spark = @newSpark()
		@children.push spark
		@view.addChild spark.view
		null

	newSpark: =>
		if @pool.length > 0
			spark = @pool[0]
			@pool.splice 0, 1
		else
			spark = new CometSparkParticle()
			spark.setColor @sparkColor

		spark.position.x = 0
		spark.position.y = 0
		spark.positions = []
		spark.fillPositions()
		spark.newLife()

		return spark