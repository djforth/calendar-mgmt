
var browserify   = require('browserify');
var coffeeify    = require('coffeeify');
var gulp         = require('gulp');
var gutil        = require('gulp-util');
var source       = require('vinyl-source-stream');
var uglifyify    = require('uglifyify');

var vendor     = require("./config/externals.js")
var destFolder = './lib';
var destFile   = "vendors.js"

// Vendor set up
gulp.task("vendor", function () {
  var b = browserify()
  b.ignore('moment')
  vendor.externals.forEach(function(ext){
    b.require(ext.path, {expose:ext.expose})
  })

  // vendor.shared.forEach(function(ext){
  //   b.require(ext.path, {expose:ext.expose})
  // })

  b.transform(coffeeify)
  b.transform(uglifyify)

  b.on('error', gutil.log);

  return b.bundle()
    .pipe(source(destFile))
    .pipe(gulp.dest(destFolder));
});
