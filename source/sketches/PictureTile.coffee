# import utils.ColourConversion
# import sketches.Sketch
class PictureTile extends Sketch

	constructor: (@renderer) ->
		super @renderer

	load: =>

		if not @loaded
			@stage = new PIXI.Stage window.app.stageColor

			@view = document.createElement 'div'

			@isConnected = false

			@camWidth = 40
			@camHeight = 30
			@size = 20

			@video = document.createElement 'video'
			@video.setAttribute 'autoplay', 'true'
			@video.setAttribute 'width', @camWidth
			@video.setAttribute 'height', @camHeight
			@video.id = 'videoElement'
			@video.style.position = 'absolute'
			@video.style.top = 0
			@video.style.left = 0
			@video.style.zIndex = 10
			@video.style.width = @camWidth + 'px'
			@video.style.height = @camHeight + 'px'

			@canvas = document.createElement 'canvas'
			@canvas.setAttribute 'width', @camWidth
			@canvas.setAttribute 'height', @camHeight
			@canvas.style.width = @camWidth + 'px'
			@canvas.style.height = @camHeight + 'px'
			@canvas.style.position = 'absolute'
			@canvas.style.top = 0
			@canvas.style.left = @camWidth + 'px'
			@canvas.style.zIndex = 10

			sx = ((window.innerWidth - (@camWidth*@size)) * 0.5) + 16
			sy = ((window.innerHeight - (@camHeight*@size)) * 0.5) + 16
			@sprites = []
			for i in [0...@camWidth]
				@sprites[i] = []
				for j in [0...@camHeight]
					p = new PIXI.Sprite window.app.textures[0]
					p.pivot.x = p.pivot.y = 16
					p.position.x = sx + (i*@size)
					p.position.y = sy + (j*@size)
					p.scale.x = p.scale.y = (@size / 32)
					@stage.addChild p
					@sprites[i][j] = p


		navigator.getUserMedia = navigator.getUserMedia || navigator.webkitGetUserMedia || navigator.mozGetUserMedia || navigator.msGetUserMedia || navigator.oGetUserMedia
		if navigator.getUserMedia
			navigator.getUserMedia {video:true}, @handleVideo, @handleVideoError


		@view.appendChild @renderer.view

		super()

		null

	handleVideo: (stream) =>
		@isConnected = true
		@localStream = stream
		@video.src = window.URL.createObjectURL @localStream

		null

	handleVideoError: (error) =>
		if console
			console.log 'ERROR :: \n'+error
		null

	unload: =>
		if @localStream
			@isConnected = false
			@localStream.stop()
		super()
		null

	update: =>
		super()
		if @cancelled then return

		if @isConnected
			@canvas.getContext('2d').drawImage @video, 0, 0, @camWidth, @camHeight
			@drawPixels()

		@renderer.render @stage

		null

	resize: =>

		null

	drawPixels: =>
		data = @canvas.getContext('2d').getImageData(0, 0, @camWidth, @camHeight).data
		x = 0
		y = 0
		for i in [0...data.length] by 4
			sprite = @sprites[x][y]
			rgb = [data[i], data[i+1], data[i+2]]
			hex = ColourConversion.rgbToHex rgb
			sprite.tint = hex
			hsb = ColourConversion.hexToHsb hex
			offset = hsb[2]*0.01
			sprite.scale.x = sprite.scale.y = ((@size / 32)*1.5) * offset
			
			x++
			if x is @camWidth
				x = 0
				y++
		null