class MenuButton

	isActive: false

	constructor: (@title, @id) ->
		@view = document.createElement('div')
		$(@view).attr 'class', 'menu-button-holder'
		@view.innerHTML = "<p class='menu-button'>"+@title+"</p>"

	enable: =>
		@view.onmouseover = @mouseover
		@view.onmouseout = @mouseout
		@view.onclick = @click
		null

	disable: =>
		@view.onmouseover = null
		@view.onmouseout = null
		@view.onclick = null
		null

	select: =>
		@mouseover()
		@isActive = true
		null

	deselect: =>
		@isActive = false
		@mouseout()
		null

	mouseover: =>
		if @isActive then return
		TweenMax.to @view, 0.3, {css:{color:'rgb(255, 0, 61)', background:'rgba(0,0,0,0.55)'}}
		null

	mouseout: =>
		if @isActive then return
		TweenMax.to @view, 2, {css:{color:'#dedede', background:'rgba(0,0,0,0)'}}
		null

	click: =>
		window.app.selectSketch(@id)
		null

