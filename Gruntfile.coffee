module.exports = (grunt)->
    grunt.loadNpmTasks 'grunt-contrib-coffee'
    grunt.loadNpmTasks 'grunt-contrib-watch'
    grunt.loadNpmTasks 'grunt-jasmine-node'
    grunt.loadNpmTasks 'grunt-contrib-jade'

    grunt.initConfig 
        coffee:
            compile:
                files: [
                    expand: true
                    cwd: 'coffee'
                    src: ['**/*.coffee']
                    dest: 'js'
                    ext: '.js'
                ]

        jasmine_node:
            specNameMatcher: "spec"
            projectRoot: ".",
            requirejs: false,
            forceExit: true,
            useCoffee: true,
            extensions: 'coffee'

        jade:
            compile:
                files:
                    "build/index.html": "jade/template.jade"
                options:
                    pretty: true

        watch:
            coffee:
                files: ['coffee/**/*.coffee']
                tasks: ['coffee:compile']

            jade:
                files: ['jade/*.jade']
                tasks: ['jade:compile']


    grunt.registerTask 'default', 'watch'
            