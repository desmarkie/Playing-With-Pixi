module.exports = (grunt) ->

	grunt.initConfig
		pkg: grunt.file.readJSON('package.json')

		connect:
			server:
				options:
					port: 9000
					base: 'deploy/static/'
					hostname: ''

		folder: 
			src:	'source/'
			deploy: 'deploy/'
			css:	'source/css/'

		path:
			source:
				coffee:		'<%= folder.src %>'

			output:
				app:		'<%= folder.deploy %>static/js/app.js'

			min:
				app:		'<%= folder.deploy %>static/js/app.min.js'

		banners:
			credits: 	"/**\n * cor media <%= grunt.template.today('yyyy') %>\n * @author: Mark Dooney (Desmarkie) \n **/\n"
			strict:		"'use strict';\n\n"

		 #watch for changes in files
		watch:
			files: [
				'<%= folder.deploy %>static/index.html'
				'Gruntfile.coffee'
				'source/*.coffee'
				'source/**/*.coffee'
				'source/css/*.css'
			]
			tasks: ['onwatch']

		percolator:
			main:
				source: '<%= path.source.coffee %>'
				output: '<%= path.output.app %>'
				main: "App.coffee"
				compile: true
				opts: "--bare"
			app:
				source: '<%= path.source.coffee %>'
				output: '<%= path.output.app %>'
				main: "App.coffee"
				compile: true
				opts: "--bare"

		#uglify javascript
		#read for full options:
		#https://github.com/mishoo/UglifyJS2
		uglify:
			options:
				banner: "<%= banners.credits %>"
				mangle: true
				compress:{
					global_defs: {
						"DEBUG": false
					},
					sequences: true
					properties: false
					dead_code: true
					drop_debugger: true
					unused: true
					warnings: true
				}
			my_target:
				files: [
					'<%= path.min.app %>': ['<%= path.output.app %>']
				]

		cssmin:
			minify:
				src: 'source/css/style.css'
				dest: 'deploy/static/css/pwpcss.min.css'

	grunt.loadNpmTasks 'grunt-contrib-connect'
	grunt.loadNpmTasks 'grunt-contrib-watch'
	grunt.loadNpmTasks 'grunt-coffee-percolator'
	grunt.loadNpmTasks 'grunt-contrib-uglify'
	grunt.loadNpmTasks 'grunt-contrib-cssmin'

	grunt.registerTask 'default', =>
		grunt.task.run ['connect']
		grunt.task.run ['watch']

	grunt.registerTask 'onwatch', [
		'percolator:main'
		'percolator:app'
		'uglify'
		'cssmin'
	]

