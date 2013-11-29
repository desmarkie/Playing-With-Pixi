class MathUtils

	@degToRadValue: Math.PI / 180
	@radToDegValue: 180 / Math.PI
	@twoPI: 2 * Math.PI

	@degToRad: (val) ->
		return val * MathUtils.degToRadValue

	@radToDeg: (val) ->
		return val * MathUtils.radToDegValue