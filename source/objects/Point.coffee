class Point

	constructor: (@x = 0, @y = 0, @z = 0) ->

	clone: =>
		return new Point @x, @y, @z

	toString: =>
		return 'Point [x:'+@x+', y:'+@y+', z:'+@z+']'
