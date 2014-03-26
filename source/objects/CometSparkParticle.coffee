# import objects.Node
# import utils.ColourConversion
class CometSparkParticle extends Node

	constructor: (x = 0, y = 0, z = 0) ->
		super x, y, z

		@life = 0
		@totalLife = 0

		@minLife = 10
		@maxLife = 30

		@minSpeed = 0.4
		@maxSpeed = 1.5

		@recordedPositions = 30
		@fillPositions()

		@newLife()

		@hsb = [300, 66, 100]
		@hex = ColourConversion.hsbToHex @hsb

		@view = new PIXI.Sprite window.app.textures[0]
		@view.pivot.x = @view.pivot.y = 16
		@view.tint = @hex

	newLife: =>
		@totalLife = Math.round(@minLife + (Math.random() * (@maxLife - @minLife)))
		@life = @totalLife
		@velocity.x = @minSpeed + (Math.random() * (@maxSpeed - @minSpeed))
		@velocity.y = @minSpeed + (Math.random() * (@maxSpeed - @minSpeed))
		if Math.random() < 0.5 then @velocity.x *= -1
		if Math.random() < 0.5 then @velocity.y *= -1
		null

	setColor: (value) =>
		@hsb[0] = value
		@hex = ColourConversion.hsbToHex @hsb
		@view.tint = @hex
		null

	update: =>
		if @life is 0 then return
		@moveTo @position.x + @velocity.x, @position.y + @velocity.y, @position.z + @velocity.z
		@life--
		@view.scale.x = @view.scale.y = 0.1 + (Math.random() * 0.3)
		@view.alpha = 0.2 + (Math.random()*1.2)
		@view.position.x = @position.x
		@view.position.y = @position.y
		null
