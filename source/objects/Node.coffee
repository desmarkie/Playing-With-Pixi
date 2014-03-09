class Node

	constructor: (x = 0, y = 0, z = 0) ->
		@position = new Point x, y, z
		@velocity = new Point()

		@positions = []
		@positions.push @position.clone()

		@recordedPositions = 1

	moveTo: (x = 0, y = 0, z = 0) =>
		@position.x = x
		@position.y = y
		@position.z = z
		@positions.push @position.clone()
		@checkPositionsLength()
		null

	checkPositionsLength: =>
		while @positions.length > @recordedPositions
			@positions.splice 0, 1
		null

	fillPositions: =>
		while @positions.length < @recordedPositions
			@positions.push @position.clone()
		null
