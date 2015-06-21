_        = require 'lodash'
moment   = require 'moment'
async    = require 'async'
mode     = require 'stat-mode'
path     = require 'path'
fs       = require 'fs-extra'

module.exports = (options) ->
   
   options ?= {}
   
   defaults = 
      src: null
      dest: '.'

   _.defaults options, defaults
   
   identifyFolders = (sources, done) ->
      async.each sources, identifyFolder, (err) ->
         done(err, sources)

   identifyFolder = (source, done) ->
      fs.stat source.path, (err, stats) ->
         console.error "File not found: " + source.path if not stats?
         return done(err) if err?
         source.isDir = stats.isDirectory()
         done()
            
   expandFolders = (sources, done) ->
      async.each sources, (source, processed) -> 
         return processed(null) if not source.isDir

         fs.readdir source.path, (err, filenames) ->
            for filename in filenames
               sources.push 
                  src: source.src
                  dest: source.dest
                  path: path.join(source.path, filename)
                  isDir: false
            processed(null)
      , (err) ->
         done(err, sources)
            
   createSourceObjects = (options, metalsmith, done) ->
      relativeSources = if _.isArray(options.src) then options.src else [options.src]
      sources = _.map relativeSources, (src) -> 
         src: src
         path: metalsmith.path(src)
         dest: options.dest
      done(null, sources)
         
   removeFolders = (sources, done) ->
      source = _.remove sources, { isDir: true }
      done(null, sources)         
      
   readAllFileContents = (sources, done) ->
      async.each sources, readFile, (err) ->
         done(err, sources)         

   readFile = (source, done) ->
      fs.readFile source.path, (err, buffer) ->
         return done(err) if err?
         source.contents = buffer
         done()

   readAllFileModes = (sources, done) ->
      async.each sources, readFileMode, (err) ->
         done(err, sources)         
               
   readFileMode = (source, done) ->
      fs.stat source.path, (err, stats) ->
         return done(err) if err?
         source.mode = mode(stats).toOctal()
         done()
         
   formatForMetalsmith = (sources, done) ->
      result = {}
      for source in sources
         filename = path.join source.dest, path.basename(source.path);
         result[filename] = 
            contents: source.contents
            mode: source.mode

      done(null, result)         
               
               
   (files, metalsmith, next) ->

      if not options.src? 
         return next new Error("copy-assets: must specify source")
      
      async.waterfall [

         (done) -> done(null, options, metalsmith)

         createSourceObjects

         identifyFolders

         expandFolders

         removeFolders

         readAllFileContents

         readAllFileModes

         formatForMetalsmith

      ], (err, result) ->
         return next(err) if err?
         _.assign files, result
         return next()
         
