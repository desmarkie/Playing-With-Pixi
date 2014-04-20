# import utils.MathUtils
class Radar extends Sketch

	numSprites: 60
	radarWidth: 579
	minScale: 0.1
	maxScale: 0.3

	rotation: 0
	rotationSpeed: 238

	midX: 400
	midY: 300

	sprites: []

	constructor: (@renderer, @name) ->
		super @renderer, @name
		@midX = window.innerWidth * 0.5
		@midY = window.innerHeight * 0.5

	load: =>

		if not @loaded
			@makeGui()

			@gui.add(@, 'rotationSpeed', 0.1, 359.9)
			@gui.add(@, 'radarWidth', 10, 1000)
			@gui.add(@, 'minScale', 0.1, 10).onFinishChange(=>
				@scaleSprites()
			)
			@gui.add(@, 'maxScale', 0.1, 10).onFinishChange(=>
				@scaleSprites()
			)

			@holder = new PIXI.DisplayObjectContainer()
			
			@renderTexture = new PIXI.RenderTexture window.innerWidth, window.innerHeight
			@renderTexture2 = new PIXI.RenderTexture window.innerWidth, window.innerHeight
			@dummy = new PIXI.Graphics()
			@dummy.beginFill 0x000000, 0.05
			@dummy.drawRect 0, 0, window.innerWidth, window.innerHeight
			@currentTexture = @renderTexture
			@canvas = new PIXI.Sprite @currentTexture

			@holder.addChild @canvas

			@view.addChild @holder

			@createSprites()



		

		super()

		null

	unload: =>

		super()
		null

	update: =>
		super()
		if @cancelled then return

		@rotation += @rotationSpeed
		rot = MathUtils.degToRad @rotation
		for i in [0..@numSprites-1]
			@sprite = @sprites[i]
			@sprite.position.x = @midX + (Math.cos(rot) * ((@radarWidth/@numSprites)*i))
			@sprite.position.y = @midY + (Math.sin(rot) * ((@radarWidth/@numSprites)*i))

		temp = @renderTexture
		@renderTexture = @renderTexture2
		@renderTexture2 = temp

		@canvas.setTexture @renderTexture

		@renderTexture2.render @holder, new PIXI.Point(0, 0), false
		@renderTexture2.render @dummy, new PIXI.Point(0, 0), false



		null

	resize: =>

		null

	scaleSprites: =>
		for i in [0..@numSprites-1]
			tgtScale = @minScale + (Math.random() * (@maxScale - @minScale))
			TweenMax.to @sprites[i].scale, 2, {x:tgtScale, y:tgtScale, ease:Bounce.easeOut}
		null

	createSprites: =>
		rotInc = 360 / @numSprites
		for i in [0..@numSprites-1]
			@sprite = new PIXI.Sprite(window.app.textures[0])
			@sprite.pivot.x = @sprite.pivot.y = 16
			@sprite.scale.x = @sprite.scale.y = @minScale + (Math.random() * (@maxScale - @minScale))
			rot = MathUtils.degToRad(i * rotInc)
			@sprite.position.x = @midX + ((@radarWidth/@numSprites)*i)
			@sprite.position.y = @midY
			@holder.addChild @sprite
			@sprites.push @sprite

		null