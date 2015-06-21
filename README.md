metalsmith-copy-assets
======================

A [Metalsmith](http://metalsmith.io) plugin that copies assets into the metalsmith build.  It can be used to copy entire folders or individual files.

Usage
-----

```javascript
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
This would result in the following files in the generated site:

-  `theme/fonts/fontawesome-webfont.ttf`
-  `theme/fonts/fontawesome-webfont.svg`
-  `theme/fonts/fontawesome-webfont.eot`
-  `theme/fonts/fontawesome-webfont.woff`
-  `theme/scripts/lunr.min.js`
-  `theme/scripts/jquery.min.js`
-  `theme/scripts/knockout.js`
-  `theme/scripts/moment.min.js`

You can use the plugin more than once to copy multiple items to different locations.

The `src` option is required, and can take either an array of file names, or a folder name.  If it is a folder name, it will copy all the files in the folder.

Files in `src` should be specified relative to the folder Metalsmith is running from (i.e. `__dirname` in the example above).

The `dest` property should be a directory, and is specified relative to the metalsmith output folder (i.e. the `build` folder).   If no `dest` property is specified, files will be copied into the `build` folder.

The plugin will generate an error if any of the files or folders are not found.  Currently the plugin does not recursively copy folder trees.  If you give it a folder name, it expects to find and copy only files in that folder.