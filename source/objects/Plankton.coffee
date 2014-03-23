# import objects.Node
class Plankton extends Node

	constructor: ->
		super Math.random() * window.innerWidth, Math.random() * window.innerHeight, 0
		console.log 'NEW Plankton : '+@position.x+', '+@position.y
		@view = new PIXI.DisplayObjectContainer()

		@graphics = new PIXI.Graphics()
		@view.addChild @graphics

		@degToRad = Math.PI / 180

		@gut = new PIXI.Sprite window.app.textures[0]
		@gut.pivot.x = @gut.pivot.y = 16
		@gut.tint = Math.random() * 0xFFFFFF
		@view.addChild @gut

		@angle = 0
		@newDirection()

		@tailProps = {min:18, max:32, dir:-1, dist:0}
		@tailProps.dist = @tailProps.min + (Math.random() * (@tailProps.max - @tailProps.min))
		@tailProps.inSpeed = 0.95 + (Math.random() * 0.04)
		@tailProps.outSpeed = 1.05 + (Math.random() * 0.14)
		@tailProps.accel = 0.7 + (Math.random() * 1)
		@tailProps.decel = 0.85 + (Math.random() * 0.1)
		@view.scale.x = @view.scale.y = @tailProps.decel

		@tail = new PIXI.Sprite window.app.textures[0]
		@tail.pivot.x = @tail.pivot.y = 16
		@tail.scale.x = @tail.scale.y = 0.5
		@tail.position.y = @tailProps.dist
		@view.addChild @tail

		@tailRight = new PIXI.Sprite window.app.textures[0]
		@tailRight.pivot.x = @tailRight.pivot.y = 16
		@tailRight.scale.x = @tailRight.scale.y = 0.25
		@tailRight.position.y = @tailProps.dist
		@tailRight.position.x = @tailProps.dist
		@view.addChild @tailRight

		@tailLeft = new PIXI.Sprite window.app.textures[0]
		@tailLeft.pivot.x = @tailLeft.pivot.y = 16
		@tailLeft.scale.x = @tailLeft.scale.y = 0.25
		@tailLeft.position.y = @tailProps.dist
		@tailLeft.position.x = -@tailProps.dist
		@view.addChild @tailLeft


	update: =>
		@graphics.clear()

		@updateTail()

		@drawLimbs()

		if @tailProps.dir is 1
			sin = Math.sin(@angle*@degToRad)
			cos = Math.cos(@angle*@degToRad)
			vx = (-sin * 1) * @tailProps.accel
			vy = (cos * 1) * @tailProps.accel
			@velocity.x += vx
			@velocity.y += vy
		else
			@velocity.x *= @tailProps.decel
			@velocity.y *= @tailProps.decel

		@position.x += @velocity.x
		@position.y += @velocity.y

		if @position.y < -100 then @position.y += window.innerHeight + 200
		else if @position.y > window.innerHeight + 100 then @position.y -= window.innerHeight + 200

		if @position.x < -100 then @position.x += window.innerWidth + 200
		else if @position.x > window.innerWidth + 100 then @position.x -= window.innerWidth + 200

		@view.position.x = @position.x
		@view.position.y = @position.y
		@view.rotation = (@angle+180) * @degToRad
		null

	updateTail: =>
		if @tailProps.dir is -1
			@tailProps.dist *= @tailProps.inSpeed
			if @tailProps.dist < @tailProps.min
				# @newDirection()
				@tailProps.dir *= -1
		else
			@tailProps.dist *= @tailProps.outSpeed
			if @tailProps.dist > @tailProps.max then @tailProps.dir *= -1

		@tail.position.y = @tailProps.dist
		sin = Math.sin(30 * @degToRad)
		cos = Math.cos(30 * @degToRad)
		nx = -sin * @tailProps.dist
		ny = cos * @tailProps.dist
		@tailLeft.position.x = nx
		@tailLeft.position.y = ny

		sin = Math.sin(-30 * @degToRad)
		cos = Math.cos(-30 * @degToRad)
		nx = -sin * @tailProps.dist
		ny = cos * @tailProps.dist
		@tailRight.position.x = nx
		@tailRight.position.y = ny
		null

	newDirection: =>
		TweenMax.killTweensOf @
		newAngle = Math.random() * 360
		time = 0.5 + (3 * Math.random())
		TweenMax.to @, time, {angle:newAngle, onComplete:=>
			@newDirection()
		}
		null

	drawLimbs: =>
		@graphics.lineStyle 1, 0xFFd0d0, 0.9

		@graphics.moveTo @gut.position.x, @gut.position.y
		@graphics.lineTo @tail.position.x, @tail.position.y

		@graphics.moveTo @gut.position.x, @gut.position.y
		@graphics.lineTo @tailRight.position.x, @tailRight.position.y

		@graphics.moveTo @gut.position.x, @gut.position.y
		@graphics.lineTo @tailLeft.position.x, @tailLeft.position.y
		null