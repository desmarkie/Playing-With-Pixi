class Timer

	constructor: (@startDate = null, @precision = 100, autoStart = false) ->
		@reset()
		if autoStart then @start()

	elapsed: =>
		@time = new Date().valueOf()
		return @time - @start

	reset: =>
		@start = @time = new Date(@startDate).valueOf()
		null

	start: =>
		@reset()
		setInterval =>
			@time += @precision
		, @precision
		null