module.exports = (grunt)->
    grunt.loadNpmTasks 'grunt-contrib-coffee'
    grunt.loadNpmTasks 'grunt-contrib-watch'
    grunt.loadNpmTasks 'grunt-jasmine-node'
    grunt.loadNpmTasks 'grunt-contrib-jade'

    grunt.initConfig 
        coffee:
            compile:
                files:
                    "js/fragistics.js": "coffee/fragistics.coffee"
                    "js/parsers.js":    "coffee/parsers.coffee"
                    "js/games.js":      "coffee/games.coffee"

        jasmine_node:
            specNameMatcher: "spec"
            projectRoot: ".",
            requirejs: false,
            forceExit: true,
            useCoffee: true,
            extensions: 'coffee'

        jasmine:
            regress:
                src: 'js/**/*.js'
                options:
                    specs: 'spec/*Spec.js'

            games:
                src: 'js/games.js'
                options:
                    specs: 'spec/gamesSpec.js'


        jade:
            compile:
                files:
                    "build/index.html": "jade/template.jade"
                options:
                    pretty: true

        watch:
            coffee:
                files: ['coffee/*.coffee']
                tasks: ['coffee:compile']

            jade:
                files: ['jade/*.jade']
                tasks: ['jade:compile']


    grunt.registerTask 'default', 'watch'
            