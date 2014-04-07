# import sketches.Sketch
# import utils.MathUtils
class Trails extends Sketch

	@id: 'Trails'

	trailLength: 70

	sprites: []
	positions: []

	sinOffset: 0
	sinIncrement: 0

	maxScale: 4
	minScale: 1

	wobbleAngle: 17

	constructor: (@renderer, @name) ->
		super @renderer, @name
		@toAdd = 0.00000000001
		@sinIncrement = MathUtils.twoPI / 18

	load: =>
		if @loaded
			@gui.domElement.style.display = 'block'
			@gui.close()
			
			super()
		else
			@curX = @mouseX = window.innerWidth * 0.5
			@curY = @mouseY = window.innerHeight * 0.5
			
			for i in [0..@trailLength-1] by 1
				sp = new PIXI.Sprite(window.app.textures[0])
				sp.alpha = 0
				sp.pivot.x = 16
				sp.pivot.y = 16
				@view.addChild sp
				@sprites.push sp
			
			@makeGui()
			@gui.add(@, 'sinIncrement', 0, MathUtils.twoPI / 5)
			@gui.add(@, 'wobbleAngle', 0, 90)
			@gui.add(@, 'maxScale', 0, 10).listen().onChange(=>
				if @maxScale < @minScale then @minScale = @maxScale
			)
			@gui.add(@, 'minScale', 0, 10).listen().onChange(=>
				if @minScale > @maxScale then @maxScale = @minScale
			)
			@gui.close()
			super()

		null

	unload: =>
		super()
		null

	update: =>
		super()
		if @cancelled then return

		angle = MathUtils.degToRad(Math.sin(@sinOffset) * @wobbleAngle)

		vecX = window.app.pointerPosition.x - @curX
		vecY = window.app.pointerPosition.y - @curY

		newX = (vecX * Math.cos(angle)) - (vecY * Math.sin(angle))
		newY = (vecX * Math.sin(angle)) + (vecY * Math.cos(angle))

		@curX += newX/100
		@curY += newY/100

		@positions.push {x:@curX, y:@curY}
		if @positions.length > @trailLength
			@positions.splice 0, 1

		for pos, p in @positions
			@sprites[p].scale.x = @minScale + ((p / @trailLength) * @maxScale)
			@sprites[p].scale.y = @minScale + ((p / @trailLength) * @maxScale)
			@sprites[p].position.x = pos.x
			@sprites[p].position.y = pos.y
			@sprites[p].alpha = p / @trailLength



		dist = Math.sqrt((vecX*vecX) + (vecY*vecY))
		if dist == 0 then dist = 1
		@toAdd = MathUtils.degToRad(30 / dist)

		@sinOffset += @sinIncrement + @toAdd
		@sinOffset %= MathUtils.twoPI

		null
