class AABB

	constructor: (@center, @dimensions) ->
		@calculatePoints()

	containsPoint: (point) ->
		if point.x >= @xMin and point.x <= @xMax and point.y >= @yMin and point.y <= @yMax
			return true
		else
			return false

	intersectsAABB: (box) ->
		if box.center.x < @center.x
			return box.xMin <= @xMax and box.yMin <= @yMax and box.xMax >= @xMin and box.yMax >= @yMin
		else
			return @xMin <= box.xMax and @yMin <= box.yMax and @xMax >= box.xMin and @yMax >= box.yMin

	setCenter: (center) ->
		@center = center
		@calculatePoints()

	setDimensions: (dimensions) ->
		@dimensions = dimensions
		@calculatePoints()

	calculatePoints: ->
		@xMin = @center.x - (@dimensions.x * 0.5)
		@xMax = @center.x + (@dimensions.x * 0.5)
		@yMin = @center.y - (@dimensions.y * 0.5)
		@yMax = @center.y + (@dimensions.y * 0.5)
		@points = []
		@points.push new Point(@xMin, @yMin)
		@points.push new Point(@xMax, @yMin)
		@points.push new Point(@xMax, @yMax)
		@points.push new Point(@xMin, @yMax)
		null