# import sketches.Sketch
class Dots extends Sketch

	@id: 'Dots'

	dots: []
	deadDots: []

	xCounter: 0
	xLimit: 0
	xDir: 1

	yCounter: 0
	yLimit: 0
	yDir: 1

	curX: 0
	curY: 0
	mouseX: 0
	mouseY: 0
	easeX: 0
	easeY: 0

	spriteSize: 32

	invert: true
	mouseTrail: true

	xFollow: false
	xBounce: true
	xLeft: false
	xRight: false
	xOff: false
	lastX: 'follow'

	yFollow: false
	yBounce: false
	yUp: false
	yDown: true
	yOff: false
	lastY: 'follow'

	constructor: (@renderer)->
		super(@renderer)

	updateGui: =>
		for c in @gui.__controllers
			c.updateDisplay()
		null

	load: =>
		if not @loaded
			@stage = new PIXI.Stage(window.app.stageColor)
			@createSprites()

			@view = document.createElement('div')
			@view.appendChild @renderer.view

			@gui = new dat.GUI({autoPlace:false})
			@gui.domElement.style.zIndex = 100
			@gui.domElement.style.position = 'absolute'
			@gui.domElement.style.top = 0
			@gui.domElement.style.left = 0
			@gui.domElement.style.height = 'auto'
			@view.appendChild @gui.domElement

			@gui.add(@, 'spriteSize', 16, 128, 8).onFinishChange((val)=>
				@spriteSize = val
				@resize()
			)
			@gui.add(@, 'invert')
			@gui.add(@, 'mouseTrail')
			@gui.add(@, 'xFollow').onChange((val)=>
				@xFollow = val
				if @xFollow = true
					@xBounce = @xLeft = @xRight = @xOff = false
				else
					@lastX = 'follow'
					@xBounce = @xLeft = @xRight = false
					@xOff = true
				@updateGui()
			)
			@gui.add(@, 'xBounce').onChange((val)=>
				@xFollow = val
				if @xBounce = true
					@xFollow = @xLeft = @xRight = @xOff = false
				else
					@lastX = 'bounce'
					@xFollow = @xLeft = @xRight = false
					@xOff = true
				@updateGui()
			)
			@gui.add(@, 'xLeft').onChange((val)=>
				@xFollow = val
				if @xLeft = true
					@xDir = -1
					@xFollow = @xBounce = @xRight = @xOff = false
				else
					@lastX = 'left'
					@xFollow = @xBounce = @xRight = false
					@xOff = true
				@updateGui()
			)
			@gui.add(@, 'xRight').onChange((val)=>
				@xFollow = val
				if @xRight = true
					@xDir = 1
					@xFollow = @xBounce = @xLeft = @xOff = false
				else
					@lastX = 'right'
					@xFollow = @xBounce = @xLeft = false
					@xOff = true
				@updateGui()
			)
			@gui.add(@, 'xOff').onChange((val)=>
				@xOff = val
				if @xOff
					if @xFollow then @lastX = 'follow'
					else if @xBounce then @lastX = 'bounce'
					else if @xLeft then @lastX = 'left'
					else if @xRight then @lastX = 'right'
					@xFollow = @xBounce = @xLeft = @xRight = false
				else 
					if @lastX is 'follow' then @xFollow = true
					else if @lastX is 'bounce' then @xBounce = true
					else if @lastX is 'left' then @xLeft = true
					else if @lastX is 'right' then @xRight = true
				@updateGui()
			)

			@gui.add(@, 'yFollow').onChange((val)=>
				@yFollow = val
				if @yFollow = true
					@yBounce = @yUp = @yDown = @yOff = false
				else
					@lastY = 'follow'
					@yBounce = @yUp = @yDown = false
					@yOff = true
				@updateGui()
			)
			@gui.add(@, 'yBounce').onChange((val)=>
				@yFollow = val
				if @yBounce = true
					@yFollow = @yUp = @yDown = @yOff = false
				else
					@lastY = 'bounce'
					@yFollow = @yUp = @yDown = false
					@yOff = true
				@updateGui()
			)
			@gui.add(@, 'yUp').onChange((val)=>
				@yFollow = val
				if @yUp = true
					@yDir = -1
					@yFollow = @yBounce = @yDown = @yOff = false
				else
					@lastY = 'left'
					@yFollow = @yBounce = @yDown = false
					@yOff = true
				@updateGui()
			)
			@gui.add(@, 'yDown').onChange((val)=>
				@yFollow = val
				if @yDown = true
					@yDir = 1
					@yFollow = @yBounce = @yUp = @yOff = false
				else
					@lastY = 'right'
					@yFollow = @yBounce = @yUp = false
					@yOff = true
				@updateGui()
			)
			@gui.add(@, 'yOff').onChange((val)=>
				@yOff = val
				if @yOff
					if @yFollow then @lastY = 'follow'
					else if @yBounce then @lastY = 'bounce'
					else if @yUp then @lastY = 'up'
					else if @yDown then @lastY = 'down'
					@yFollow = @yBounce = @yUp = @yDown = false
				else 
					if @lastY is 'follow' then @yFollow = true
					else if @lastY is 'bounce' then @yBounce = true
					else if @lastY is 'up' then @yUp = true
					else if @lastY is 'down' then @yDown = true
				@updateGui()
			)
			@gui.close()

		super()
		@view.appendChild @renderer.view

		@xLimit = @dots.length
		@yLimit = @dots[0].length

		null

	unload: =>
		super()
		null



	update: =>
		super()
		if @cancelled then return

		@handleMouseMove()

		if @xFollow
			@xCounter = @curX
		if @yFollow
			@yCounter = @curY

		for i in [0..@xCount] by 1
			for j in [0..@yCount] by 1
				sprite = @dots[i][j]
				tgtAlpha = 1
				if @invert then tgtAlpha = 0
				if !@xOff and i == @xCounter 
					sprite.alpha = tgtAlpha
					sprite.scale.x = sprite.scale.y = tgtAlpha * ( @spriteSize / 32 )
				if !@yOff and j == @yCounter
					sprite.alpha = tgtAlpha
					sprite.scale.x = sprite.scale.y = tgtAlpha * ( @spriteSize / 32 )

				if @invert
					if sprite.alpha < 1
						sprite.alpha += 0.05
						sprite.scale.x += 0.05
						sprite.scale.y += 0.05
						if sprite.alpha > 1 then sprite.alpha = 1
						if sprite.scale.x > 1 then sprite.scale.x = sprite.scale.y = @spriteSize / 32
				else
					if sprite.alpha > 0
						sprite.alpha -= 0.05
						sprite.scale.x -= 0.05
						sprite.scale.y -= 0.05
						if sprite.alpha < 0 then sprite.alpha = 0
						if sprite.scale.x < 0 then sprite.scale.x - sprite.scale.y = 0

		if !@xOff
			@xCounter+=@xDir
			if @xLeft or @xRight
				@xCounter %= @xLimit
				if @xCounter < 0 then @xCounter = @xLimit-1
			else if @xBounce
				if @xCounter == @xLimit
					@xCounter = @xLimit-2
					@xDir *= -1
				else if @xCounter < 0
					@xCounter = 1
					@xDir *= -1
		
		if !@yOff
			@yCounter+=@yDir
			if @yUp or @yDown
				@yCounter %= @yLimit
				if @yCounter < 0 then @yCounter = @yLimit-1
			else if @yBounce
				if @yCounter == @yLimit
					@yCounter = @yLimit-2
					@yDir *= -1
				else if @yCounter < 0
					@yCounter = 1
					@yDir *= -1

		@easeX += (@mouseX - @easeX) / 45
		@easeY += (@mouseY - @easeY) / 45

		@curX = Math.floor(@easeX/@spriteSize)
		@curY = Math.floor(@easeY/@spriteSize)

		@renderer.render @stage
		null

	resize: =>
		if @loaded
			for i in [@dots.length-1..0] by -1
				for j in [@dots[i].length-1..0] by -1
					@stage.removeChild @dots[i][j]
					@dots[i].splice j, 1

			@dots = []

			@createSprites()

			@xLimit = @dots.length
			@yLimit = @dots[0].length

		null


	handleMouseMove: =>
		@mouseX = window.app.pointerPosition.x
		@mouseY = window.app.pointerPosition.y
		if @mouseTrail
			xid = Math.floor(@mouseX / @spriteSize)
			yid = Math.floor(@mouseY / @spriteSize)
			tgtAlpha = 1
			if @invert then tgtAlpha = 0
			@dots[xid][yid].alpha = tgtAlpha
			if @dots[xid] and @dots[xid][yid-1]
				@dots[xid][yid-1].alpha = tgtAlpha
				@dots[xid][yid-1].scale.x = @dots[xid][yid-1].scale.y = tgtAlpha * (@spriteSize / 32)
			if @dots[xid] and @dots[xid][yid+1]
				@dots[xid][yid+1].alpha = tgtAlpha
				@dots[xid][yid+1].scale.x = @dots[xid][yid+1].scale.y = tgtAlpha * (@spriteSize / 32)
			if @dots[xid-1] and @dots[xid-1][yid]
				@dots[xid-1][yid].alpha = tgtAlpha
				@dots[xid-1][yid].scale.x = @dots[xid-1][yid].scale.y = tgtAlpha * (@spriteSize / 32)
			if @dots[xid+1] and @dots[xid+1][yid]
				@dots[xid+1][yid].alpha = tgtAlpha
				@dots[xid+1][yid].scale.x = @dots[xid+1][yid].scale.y = tgtAlpha * (@spriteSize / 32)
		null

	createSprites: ->
		@xCount = Math.round(window.innerWidth / @spriteSize)
		@yCount = Math.round(window.innerHeight / @spriteSize)
		for i in [0..@xCount] by 1
			@dots[i] = []
			for j in [0..@yCount] by 1
				if @deadDots.length is 0
					sp = new PIXI.Sprite(window.app.textures[0])
				else
					sp = @deadDots[0]
					@deadDots.splice 0, 1
				sp.scale.x = sp.scale.y = @spriteSize / 32
				sp.position.x = i * @spriteSize
				sp.position.y = j * @spriteSize
				@dots[i][j] = sp
				sp.alpha = 0
				@stage.addChild sp

		null