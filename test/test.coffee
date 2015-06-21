coffee      = require 'coffee-script/register'
moment      = require 'moment'
mocha       = require 'mocha'
rimraf      = require 'rimraf'
should      = require('chai').should()
join        = require('path').join
each        = require('lodash').each
_           = require('lodash')

Metalsmith  = require 'metalsmith'
plugin     = require '..'

describe 'metalsmith-copy-assets', () ->

   beforeEach (done) ->
      rimraf __dirname + '/build', done
      
   describe 'with folder', ()->
      
      it 'should copy folder contents into build', (done)->
         
         Metalsmith(__dirname)
            .source('fixtures/src')
            .use plugin
               src: 'fixtures/folder/'
               dest: 'output'
            .build (err, files) ->
               should.not.exist(err)
               should.exist(files)
               should.exist files['output/file1.txt']
               should.exist files['output/file2.txt']
               done()

      describe 'if destination not supplied', () ->
         it 'should copy folder contents into build directory', (done)->
            
            Metalsmith(__dirname)
               .source('fixtures/src')
               .use plugin
                  src: 'fixtures/folder/'
               .build (err, files) ->
                  should.not.exist(err)
                  should.exist(files)
                  should.exist files['file1.txt']
                  should.exist files['file2.txt']
                  done()
   
      it 'should error if source is not supplied', (done)->
         
         Metalsmith(__dirname)
            .source('fixtures/src')
            .use plugin
               dest: 'output'
            .build (err, files) ->
               should.exist(err)
               done()

      it 'should error if source directory does not exist', (done)->
         
         Metalsmith(__dirname)
            .source('fixtures/src')
            .use plugin
               src: 'fixtures/nonexistent/'
               dest: 'output'
            .build (err, files) ->
               should.exist(err)
               done()

   describe 'with files', ()->
      
      it 'should copy individual files into output directory', (done)->
         
         Metalsmith(__dirname)
            .source('fixtures/src')
            .use plugin
               src: ['fixtures/folder/file1.txt', 'fixtures/file3.txt', 'fixtures/path/to/another/file4.txt']
               dest: 'output'
            .build (err, files) ->
               should.not.exist(err)
               should.exist(files)
               should.exist files['output/file1.txt']
               should.exist files['output/file3.txt']
               should.exist files['output/file4.txt']
               done()

      describe 'if destination not supplied', () ->
         it 'should copy individual files into build directory', (done)->
            
            Metalsmith(__dirname)
               .source('fixtures/src')
               .use plugin
                  src: ['fixtures/folder/file1.txt', 'fixtures/file3.txt', 'fixtures/path/to/another/file4.txt']
               .build (err, files) ->
                  should.not.exist(err)
                  should.exist(files)
                  should.exist files['file1.txt']
                  should.exist files['file3.txt']
                  should.exist files['file4.txt']
                  done()

      it 'should error if source file is not found', (done)->
         
         Metalsmith(__dirname)
            .source('fixtures/src')
            .use plugin
               src: ['fixtures/folder/filedoesnotexist.txt', 'fixtures/file3.txt', 'fixtures/path/to/another/file4.txt']
               dest: 'output'
            .build (err, files) ->
               should.exist(err)
               done()


   afterEach (done) ->
      rimraf __dirname + '/build', done
      
