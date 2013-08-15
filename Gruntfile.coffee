module.exports = (grunt)->
    grunt.loadNpmTasks 'grunt-contrib-coffee'
    grunt.loadNpmTasks 'grunt-contrib-watch'
    grunt.loadNpmTasks 'grunt-contrib-jasmine'

    grunt.initConfig 
        coffee:
            compile:
                files:
                    "js/fragistics.js": "coffee/fragistics.coffee"
                    "js/parsers.js":    "coffee/parsers.coffee"
                    "js/games.js":      "coffee/games.coffee"

        jasmine:
            regress:
                src: 'js/**/*.js',
                options: {
                    specs: 'spec/*Spec.js'

        watch:
            coffee:
                files: ['coffee/*.coffee']
                tasks: ['coffee:compile']


    grunt.registerTask 'default', 'watch'
            