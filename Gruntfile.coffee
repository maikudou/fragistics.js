module.exports = (grunt)->
    grunt.loadNpmTasks 'grunt-contrib-coffee'
    grunt.loadNpmTasks 'grunt-contrib-watch'

    grunt.initConfig 
        coffee:
            compile:
                files:
                    "js/fragistics.js": "coffee/fragistics.coffee"


        watch:
            coffee:
                files: ['coffee/*.coffee']
                tasks: ['coffee:compile']


    grunt.registerTask 'default', 'watch'
            