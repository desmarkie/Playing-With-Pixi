class Fractals extends Sketch

	minSize: 32
	startSize: 400
	divisor: 2.5

	sprites: []
	deadSprites: []

	constructor: (@renderer, @name) ->
		super @renderer, @name

	load: =>

		if not @loaded
			@makeGui()

			@renderTex = new PIXI.RenderTexture(window.innerWidth, window.innerHeight)
			@renderView = new PIXI.Sprite(@renderTex)
			@view.addChild @renderView

			@sprite = new PIXI.Sprite(window.app.textures[0])
			@sprite.pivot.x = @sprite.pivot.y = 16

			@canvas = new PIXI.DisplayObjectContainer()

			@gui.add(@, 'minSize', 1, 1000).listen().onChange(=>
				if @startSize < @minSize then @minSize = @startSize
			).onFinishChange(=>
				@redraw()
			)
			@gui.add(@, 'startSize', 10, 1000).listen().onChange(=>
				if @startSize < @minSize then @minSize = @startSize
			).onFinishChange(=>
				@redraw()
			)
			@gui.add(@, 'divisor', 2, 6).onFinishChange(=>
				@redraw()
			)

		@createSprites()

		

		super()
		null

	unload: =>

		super()
		null

	update: =>
		super()
		if @cancelled then return


		
		null

	resize: =>
		@redraw()
		null

	redraw: =>
		if @renderView
			@renderTex.destroy()
			@renderTex = new PIXI.RenderTexture(window.innerWidth, window.innerHeight)
			@renderView.setTexture @renderTex

			@sprites = []

			@createSprites()
		null

	createSprites: ->
		@addSprite window.innerWidth*0.5, window.innerHeight*0.5, @startSize
		null

	addSprite: (x, y, size) =>
		@sprite.position.x = x
		@sprite.position.y = y
		@sprite.scale.x = @sprite.scale.y = size / 32

		@canvas.addChild @sprite
		@renderTex.render @canvas
		@canvas.removeChild @sprite

		if size > @minSize
			setTimeout(=>
				@addSprite x + size / @divisor, y, size / @divisor
				@addSprite x - size / @divisor, y, size / @divisor
				@addSprite x, y + size / @divisor, size / @divisor
				@addSprite x, y - size / @divisor, size / @divisor
			, 500)

	getSprite: =>
		if @deadSprites.length == 0
			return new PIXI.Sprite(window.app.textures[0])
		else
			return @deadSprites.splice(0, 1)[0]

