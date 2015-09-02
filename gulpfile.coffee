### global require ###

gulp = require('gulp')

coffee = require('gulp-coffee')
concat = require('gulp-concat')
gutil = require('gulp-util')
minifyHtml = require('gulp-minify-html')
ngannotate = require('gulp-ng-annotate')
plumber = require('gulp-plumber')
rename = require('gulp-rename')
streamqueue = require('streamqueue')
templateCache = require('gulp-angular-templatecache')
uglify = require('gulp-uglify')

gulp.task 'dist', ->

  html = gulp.src './src/*.html'
    .pipe minifyHtml
      empty: true
      spare: true
      quotes: true
    .pipe templateCache
      module: 'schemaForm'
      root: 'directives/decorators/bootstrap/iban/'

  js = gulp.src './src/*.coffee'
    .pipe(coffee().on('error', gutil.log))
    .pipe(ngannotate())

  stream = streamqueue
    objectMode: true

  stream.queue(html)
  stream.queue(js)

  stream.done()
    .pipe(concat('angular-schema-form-remote-validator.js'))
    .pipe(gulp.dest('./dist/'))
    .pipe(uglify())
    .pipe(rename('angular-schema-form-remote-validator.min.js'))
    .pipe(gulp.dest('./dist/'))

  return

gulp.task 'watch', ->
  gulp.watch './src/**/*', [ 'default' ]
  return

gulp.task 'default', [
  'dist'
  'watch'
]
