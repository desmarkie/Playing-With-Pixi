class QuadTree

	@TOP_LEFT : 0
	@TOP_RIGHT : 1
	@BOTTOM_LEFT : 2
	@BOTTOM_RIGHT : 3

	constructor: (@boundsAABB, @maxCapacity = 1, @maxLevels = 10, @level = 0) ->
		@points = []
		@children = []

	insert: (aabb) ->
		if @children.length > 0
			index = @getIndex aabb
			if index != -1
				@children[index].insert aabb
				return

		@points.push aabb

		if @points.length > @maxCapacity && @level < @maxLevels

			if @children.length is 0
				@subdivide()

			i = 0
			while i < @points.length
				index = @getIndex @points[i]
				if index != -1
					@children[index].insert @points.splice(i, 1)[0]
				else
					i++

		null

	subdivide: ->
		halfWidth = @boundsAABB.dimensions.x * 0.5
		halfHeight = @boundsAABB.dimensions.y * 0.5
		dims = new Point(halfWidth, halfHeight)
		nextLevel = @level + 1

		ct = new Point(@boundsAABB.xMin + (halfWidth*0.5), @boundsAABB.yMin + (halfHeight*0.5))
		@tl = new QuadTree(new AABB(ct, dims), @maxCapacity, @maxLevels, nextLevel)

		ct = new Point((@boundsAABB.xMin+halfWidth) + (halfWidth*0.5), @boundsAABB.yMin + (halfHeight*0.5))
		@tr = new QuadTree(new AABB(ct, dims), @maxCapacity, @maxLevels, nextLevel)

		ct = new Point(@boundsAABB.xMin + (halfWidth*0.5), (@boundsAABB.yMin+halfHeight) + (halfHeight*0.5))
		@bl = new QuadTree(new AABB(ct, dims), @maxCapacity, @maxLevels, nextLevel)

		ct = new Point((@boundsAABB.xMin+halfWidth) + (halfWidth*0.5), (@boundsAABB.yMin+halfHeight) + (halfHeight*0.5))
		@br = new QuadTree(new AABB(ct, dims), @maxCapacity, @maxLevels, nextLevel)

		@children = [@tl, @tr, @bl, @br]
		null

	getIndex: (aabb) ->
		index = -1

		topQuad = aabb.center.y > @boundsAABB.yMin and aabb.center.y <= @boundsAABB.center.y
		botQuad = aabb.center.y > @boundsAABB.center.y and aabb.center.y <= @boundsAABB.yMax

		if aabb.center.x > @boundsAABB.xMin and aabb.center.x <= @boundsAABB.center.x
			if topQuad then index = 0
			else if botQuad then index = 2
		else if aabb.center.x > @boundsAABB.center.x and aabb.center.x <= @boundsAABB.xMax
			if topQuad then index = 1
			else if botQuad then index = 3

		return index

	retrieve: (aabb) ->
		index = @getIndex aabb
		arr = @points

		if @children.length > 0
			if index != -1
				arr = arr.concat(@children[index].retrieve(aabb))
			else
				for child in @children
					arr = arr.concat(child.retrieve(aabb))

		return arr

	clear: ->
		@points = []
		for child in @children
			child.clear()
		@children = []
		null

