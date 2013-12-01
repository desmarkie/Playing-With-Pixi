class InfoPanel

	view: null
	bg: null
	contentPanel: null

	constructor: ->
		@view = $('#information-panel')
		@bg = $('#information-panel-bg')
		@contentPanel = $('#information-panel-content')
		#@bg.onclick = @bgClick
		document.getElementById('information-panel-bg').onclick = @bgClick
		$(@bg).css 'cursor', 'pointer'
		@resize()

	show: =>
		$(@view).css 'z-index', '2000'
		TweenMax.to @view, 1, {css:{opacity:1}, ease:Power4.easeOut}
		null

	hide: =>
		TweenMax.to @view, 1, {css:{opacity:0}, ease:Power4.easeOut, onComplete:=>
			$(@view).css 'z-index', '2'
		}
		null

	bgClick: =>
		window.app.handleInfoClick()
		null

	resize: =>
		xPos = (window.innerWidth - $(@contentPanel).width()) * 0.5
		yPos = (window.innerHeight - $(@contentPanel).height()) * 0.5
		console.log 'RESIZING :: '+xPos+', '+yPos
		#$(@contentPanel).css 'top', Math.round(yPos)+'px'
		#$(@contentPanel).css 'left', Math.round(xPos)+'px'
		null