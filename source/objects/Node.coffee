class Node

	x: 0
	y: 0
	view: null
	xVel: 0
	yVel: 0
	scale: 1
	sinPos: 0
	sinIncrement: 1
	scaleAmount: 0.5

	constructor: (@x, @y, @view) ->
		@xVel = 3 - (6*Math.random())
		@yVel = 3 - (6*Math.random())
		@sinPos = Math.random() * 360
		@sinIncrement = Math.random() * 0.5
		@scaleAmount = (Math.random() * 2)