#import objects.Point
class Grid

	constructor: (@width = 10, @height = 10) ->
		@pool = []
		@tiles = @createTiles()

	createTiles: ->
		obj = {}
		x = y = 0
		for i in [0...@width*@height]
			obj[x+'_'+y] = @getTile x, y
			x++
			if x is @width
				x = 0
				y++
		return obj

	getTile: (x, y) ->
		if @pool.length != 0
			node = @pool.splice(0, 1)[0]
			node.x = x
			node.y = y
			return node
		else
			return new Point(x, y)
