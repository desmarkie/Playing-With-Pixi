#import sketches.Sketch
#import objects.Grid
class BasicGrid extends Sketch

	constructor: (@renderer, @name) ->
		super @renderer, @name

	load: =>

		if not @loaded
			#creates a dat.GUI folder, access via @gui
			@makeGui()

			@sprites = []
			@pool = []

			@spriteSize = 32

			@curTile = null

			@gridWidth = 25
			@gridHeight = 25
			@viewSize = Math.min(window.innerWidth, window.innerHeight) * 0.75
			@gridSize = @viewSize / Math.max(@gridWidth, @gridHeight)

			@gridHolder = new PIXI.DisplayObjectContainer()
			@view.addChild @gridHolder

			@drawGrid()

			@xpos = -1
			@ypos = -1

			@gui.add @, 'gridWidth', 1, 200, 1
			@gui.add @, 'gridHeight', 1, 200, 1
			@gui.add @, 'drawGrid'
			@gui.add(@, 'xpos').listen()
			@gui.add(@, 'ypos').listen()


		

		super()

		null

	unload: =>

		super()
		null

	update: =>
		super()
		if @cancelled then return

		@xpos = Math.round((window.app.pointerPosition.x - @gridHolder.position.x) / @gridSize) - 1
		@ypos = Math.round((window.app.pointerPosition.y - @gridHolder.position.y) / @gridSize) - 1

		ref = @xpos + '_' + @ypos

		if @xpos >= 0 and @xpos < @gridWidth and @ypos >= 0 and @ypos < @gridHeight and @grid.tiles[ref].sprite != @curTile
			if @curTile != null
				TweenMax.to @curTile, 5, {alpha:0, ease:Power4.easeOut}
				TweenMax.to @curTile.scale, 5, {x:0, y:0, ease:Power4.easeOut}
			@curTile = @grid.tiles[ref].sprite
			TweenMax.to @curTile, 0.3, {alpha:1, ease:Power4.easeOut}
			TweenMax.to @curTile.scale, 0.3, {x:1, y:1, ease:Power4.easeOut}

		null

	resize: =>

		null

	drawGrid: =>
		@grid = new Grid @gridWidth, @gridHeight
		@gridSize = @viewSize / Math.max(@gridWidth, @gridHeight)

		@tileSprite = @createTileSprite()

		while @sprites.length > 0
			@pool.push @sprites.splice(0, 1)[0]
		
		for ref, cell of @grid.tiles
			t = @getTile cell.x*@gridSize, cell.y*@gridSize
			t.alpha = t.scale.x = t.scale.y = 0
			cell.sprite = t
			@sprites.push t
			@gridHolder.addChild t

		@gridHolder.position.x = (window.innerWidth - (@gridWidth*@gridSize)) * 0.5
		@gridHolder.position.y = (window.innerHeight - (@gridHeight*@gridSize)) * 0.5
		null

	getTile: (x, y) ->
		tile = null
		if @pool.length > 0
			tile = @pool.splice(0, 1)[0]
			tile.setTexture @tileSprite
		else
			tile = new PIXI.Sprite @tileSprite
		tile.anchor.x = tile.anchor.y = 0.5
		tile.position.x = x + @gridSize
		tile.position.y = y + @gridSize
		return tile

	createTileSprite: ->
		g = new PIXI.Graphics()
		g.beginFill 0xffffff
		g.drawRect 0, 0, @gridSize, @gridSize
		g.endFill()
		return g.generateTexture()