# import views.MenuButton
class Menu

	buttons: []

	constructor: (@app, @data) ->
		@menuPanel = document.getElementById('menu-panel')
		@menuButtons = document.getElementById('menu-buttons')
		@currentButton = document.getElementById('current-sketch')

		@createButtons()

		@buttons[@app.currentSketch].select()

	show: ->
		$(@menuPanel).css 'z-index', '1200'
		TweenMax.to @menuPanel, 1, {css:{opacity:1}, ease:Power4.easeOut}
		null

	hide: ->
		TweenMax.to @menuPanel, 1, {css:{opacity:0}, ease:Power4.easeOut, onComplete:=>
			$(@menuPanel).css 'z-index','1'
		}
		null

	enable: =>
		for but in @buttons
			but.enable()
		null

	disable: =>
		for but in @buttons
			but.disable()
		null

	updateInfoContent: ->
		prevId = @app.currentSketch-1
		if prevId < 0 then prevId = @app.sketches.length-1
		nextId = @app.currentSketch+1
		if nextId == @app.sketches.length then nextId = 0

		@currentButton.innerHTML = '<h1>'+@data[@app.currentSketch].classId+'</h1><div id="current-sketch-content">'+@getSketchCopy()+'</div>'

		for but in @buttons
			if but.id != @app.currentSketch and but.isActive then but.deselect()
			else if but.id == @app.currentSketch and !but.isActive then but.select()
		null

	getSketchCopy: ->
		str = "<p class='information-panel-copy'>"+@data[@app.currentSketch].instructions+"</p>"
		str += "<p class='information-panel-copy'>"+@data[@app.currentSketch].description+"</p>"
		return str;

	handleDivOver: (e) =>
		if e.target is @nextButton or e.target is @menuButtons or e.target is @currentButton
			TweenMax.to e.target, 0.3, {css:{color:'rgb(255, 0, 61)'}, ease:Power4.easeOut}
		null

	handleDivOut: (e) =>
		if e.target is @nextButton or e.target is @menuButtons or e.target is @currentButton
			TweenMax.to e.target, 2, {css:{color:'#dedede'}, ease:Power4.easeOut}
		null

	createButtons: ->
		for i in [0..@data.length-1]
			but = new MenuButton @data[i].classId, i
			@buttons.push but
			@menuButtons.appendChild but.view
		null

