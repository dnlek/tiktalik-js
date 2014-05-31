'use strict'

module.exports = (grunt) ->

  # load all grunt tasks
  (require 'matchdep').filterDev('grunt-*').forEach(grunt.loadNpmTasks)

  grunt.initConfig
    pkg: grunt.file.readJSON('package.json')
    coffee:
      default:
        expand: true,
        flatten: true,
        cwd: 'lib/',
        src: ['*.coffee'],
        dest: 'dist/',
        ext: '.js'
        # 'dist/tiktalik.js': ['lib/*.coffee']
    watch:
        coffeescript:
            files: 'lib/**/*.coffee'
            tasks: ["newer:coffee"]

    clean: ['node_modules', 'dist']

    mochaTest:
      test:
        options:
          reporter: 'spec'

      src: ['test/**/*.coffee']

  grunt.registerTask('default', ['coffee'])
  grunt.registerTask('test', ['mochaTest'])
