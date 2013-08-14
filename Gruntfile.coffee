module.exports = (grunt)->
    grunt.loadNpmTasks 'grunt-contrib-coffee'
    grunt.loadNpmTasks 'grunt-contrib-watch'

    grunt.initConfig 
        coffee:
            compile:
                files:
                    "js/fragistics.js": "coffee/fragistics.coffee"
                    "js/parsers.js":    "coffee/parsers.coffee"
                    "js/games.js":      "coffee/games.coffee"


        watch:
            coffee:
                files: ['coffee/*.coffee']
                tasks: ['coffee:compile']


    grunt.registerTask 'default', 'watch'
            