# import views.MenuButton
class Menu

	buttons: []

	constructor: (@app, @data) ->
		@menuPanel = document.getElementById('menu-panel')
		@menuButtons = document.getElementById('menu-buttons')
		@currentButton = document.getElementById('current-sketch')

		@createButtons()

		$(@currentButton).css 'cursor', 'pointer'
		@currentButton.onclick = @app.handleMenuClick

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

		TweenMax.to @currentButton, 0.5, {css:{opacity:0}, ease:Power4.easeOut, onComplete: =>
			@currentButton.innerHTML = '<h1 style="opacity:0">'+@data[@app.currentSketch].classId+'</h1><div id="current-sketch-content">'+@getSketchCopy()+'</div>'
			# TweenMax.to @currentButton, 0.5, {css:{opacity:1}, ease:Power4.easeOut}
			@currentHeader = @currentButton.getElementsByTagName('h1')[0];
			@currentHolder = document.getElementById('current-sketch-content')
			@paras = @currentHolder.getElementsByTagName('p')
			$(@currentButton).css 'opacity', '1'
			TweenMax.to @currentHeader, 0.5, {css:{opacity:1}, ease:Power4.easeOut}
			for i in [0..@paras.length-1] by 1
				if i < @paras.length-1
					TweenMax.to @paras[i], 0.5, {css:{opacity:1}, ease:Power4.easeOut, delay:0.3+(i*0.2)}
				else
					TweenMax.to @paras[i], 0.5, {css:{opacity:1}, ease:Power4.easeOut, delay:0.3+(i*0.2), onComplete:=>
						console.log 'ALL TWEENING DONE'
					}
		}

		for but in @buttons
			if but.id != @app.currentSketch and but.isActive then but.deselect()
			else if but.id == @app.currentSketch and !but.isActive then but.select()
		null

	getSketchCopy: ->
		str = "<p class='information-panel-copy' style='opacity:0'>"+@data[@app.currentSketch].instructions+"</p>"
		str += "<p class='information-panel-copy' style='opacity:0'>"+@data[@app.currentSketch].description+"</p>"
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

