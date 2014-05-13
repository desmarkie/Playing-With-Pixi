# import utils.MathUtils
class Penrose extends Sketch

	constructor: (@renderer, @name) ->
		super @renderer, @name

	load: =>

		if not @loaded
			#creates a dat.GUI folder, access via @gui
			@makeGui()

			@canvas = new PIXI.Graphics()
			@view.addChild @canvas
			@canvas.position.x = window.innerWidth * 0.5
			@canvas.position.y = window.innerHeight * 0.5

			@colA = 3223857
			@colB = 10944261

			@gui.addColor(@, 'colA').name('Colour A').onChange(=>
				if typeof(@colA) is 'string'
					@colA = @colA.replace('#', '0x')
					@colA = parseInt(@colA)
				@drawTriangles @triangles, @iterations+1
			)
			@gui.addColor(@, 'colB').name('Colour B').onChange(=>
				if typeof(@colB) is 'string'
					@colB = @colB.replace('#', '0x')
					@colB = parseInt(@colB)
				@drawTriangles @triangles, @iterations+1
			)

		@triangles = []

		for i in [0...10]
			angA = i*36
			angB = (i+1) * 36
			angB %= 360
			tri = {
				colour: 0
				a: [0, 0]
				b: [Math.cos(MathUtils.degToRad(angA)) * 50, Math.sin(MathUtils.degToRad(angA)) * 50]
				c: [Math.cos(MathUtils.degToRad(angB)) * 50, Math.sin(MathUtils.degToRad(angB)) * 50]
			}
			if i % 2 is 0
				t = tri.b
				tri.b = tri.c
				tri.c = t
			@triangles.push tri


		@iterations = 0
		@waiting = false

		@drawTriangles @triangles, 1+@iterations
		

		super()

		null

	unload: =>

		super()
		null

	update: =>
		super()
		if @cancelled then return

		if window.app.mousePressed and !@waiting
			@waiting = true
		else if !window.app.mousePressed and @waiting
			@waiting = false
			if @iterations < 7
				@triangles = @subdivideTriangles @triangles
				@iterations++
				@drawTriangles @triangles, 1+@iterations

		null

	resize: =>

		null

	drawTriangles: (triangles, scale = 10) ->
		@canvas.clear()
		@canvas.lineStyle 1, 0x000000

		for tri in triangles
			if tri.colour is 1 then @canvas.beginFill @getColour(tri.a, @colB)
			else @canvas.beginFill @getColour(tri.a, @colA)
			@canvas.moveTo tri.b[0] * scale, tri.b[1] * scale
			@canvas.lineTo tri.a[0] * scale, tri.a[1] * scale
			@canvas.lineTo tri.c[0] * scale, tri.c[1] * scale
			@canvas.endFill()

		@canvas.lineStyle null
		

	getColour: (pt, col) =>
		xd = pt[0] * (@iterations+1)# - (window.innerWidth*0.5)
		yd = pt[1] * (@iterations+1)# - (window.innerHeight*0.5)
		hsb = ColourConversion.hexToHsb col
		dist = Math.sqrt((xd*xd)+(yd*yd))
		hsb[0] += 120 * (dist / window.innerHeight)
		return ColourConversion.hsbToHex hsb

	findMidpoint: (a, b) ->
		val = []
		val.push( a[0] + (b[0]-a[0]) / MathUtils.goldenRatio)
		val.push( a[1] + (b[1]-a[1]) / MathUtils.goldenRatio)
		return val

	subdivideTriangles: (triangles) ->
		arr = []

		for tri in triangles
			if tri.colour is 0
				p = @findMidpoint tri.a, tri.b
				arr.push {colour:0, a:tri.c, b:p, c:tri.b}
				arr.push {colour:1, a:p, b:tri.c, c:tri.a}
			else
				q = @findMidpoint tri.b, tri.a
				r = @findMidpoint tri.b, tri.c
				arr.push {colour:1, a:r, b:tri.c, c:tri.a}
				arr.push {colour:1, a:q, b:r, c:tri.b}
				arr.push {colour:0, a:r, b:q, c:tri.a}

		return arr