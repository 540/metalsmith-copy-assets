metalsmith-copy-assets
======================

A [Metalsmith](http://metalsmith.io) plugin that copies assets into the metalsmith build.  It can be used to copy entire folders or individual files.

Usage
-----

```
var copyAssets = require('metalsmith-copy-assets');

   Metalsmith(__dirname)
   
   .use(copyAssets(
      {
        src: 'bower_components/font-awesome/fonts',
        dest: 'theme/fonts'
      }
   ))
   
   .use(copyAssets(
      {
        src: [
           'bower_components/lunr.js/lunr.min.js', 
           'bower_components/jquery/dist/jquery.min.js'
           'bower_components/knockout/dist/knockout.js'
           'bower_components/momentjs/min/moment.min.js'
           ],
        dest: 'theme/scripts'
     }
  ));
```

You can use the plugin more than once to copy multiple items to different locations.

The `src` option is required, and can take either an array of file names, or a folder name.  If it is a folder name, it will recursively copy all the files in the folder.

Files in `src` should be specified relative to the folder Metalsmith is running from (i.e. `__dirname` in the example above).

The `dest` property should be a directory, and is specified relative to the metalsmith output folder (i.e. the `build` folder).   If no `dest` property is specified, files will be copied into the `build` folder.

The plugin will generate an error if any of the files or folders are not found.