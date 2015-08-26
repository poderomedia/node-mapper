gulp = require 'gulp'
gutil = require 'gulp-util'

browserify = require 'gulp-browserify'
sass = require 'gulp-sass'
rename = require 'gulp-rename'
coffeelint = require 'gulp-coffeelint'
coffee = require 'gulp-coffee'
autoprefixer = require 'gulp-autoprefixer'
concat = require 'gulp-concat'
uglify = require 'gulp-uglify'
rimraf = require 'gulp-rimraf'
runSequence = require 'run-sequence'

# CONFIG ---------------------------------------------------------

isProd = gutil.env.type is 'prod'

sources =
  html: 'app/**/*.html'
  sass: 'app/styles/styles.scss'
  coffee: 'app/scripts/*.coffee'
  lib: 'app/scripts/lib/*.js'

destinations =
  html: 'dist/'
  css: 'dist/'
  js: 'dist/'
  lib: 'dist/lib/'

# Modules for webserver and livereload
express = require('express')
refresh = require('gulp-livereload')
liveReload = require('connect-livereload')
liveReloadPort = 35739
serverPort = 8000

server = express()
server.use liveReload(port: liveReloadPort)  # Add live reload
server.use express.static('dist') # Use our 'dist' folder as rootfolder
server.all '/*', (req, res) ->  # Because I like HTML5 pushstate .. this redirects everything back to our index.html
  res.sendFile 'index.html', root: 'dist'
  return

# Compile and concatenate scripts
gulp.task('coffee', ->
  gulp.src('app/scripts/main.coffee', read: false)
    .pipe(browserify(
      transform: ['coffeeify']
      extensions: ['.coffee']
      insertGlobals: true,
      debug: !isProd
      ))
    .pipe(rename('app.js'))
    .pipe(gulp.dest(destinations.js))
)

# Compile stylesheets
gulp.task('sass', ->
  gulp.src(sources.sass)
    .pipe(sass(onError: (e) -> console.log(e)))
    .pipe(autoprefixer('last 2 versions', '> 1%', 'ie 8'))
    .pipe(gulp.dest(destinations.css))
)

# Lint coffeescript
# TODO Fix this
gulp.task('lint', ->
  # gulp.src(sources.coffee)
  # .pipe(coffeelint())
  # .pipe(coffeelint.reporter())
)

gulp.task('html', ->
  gulp.src(sources.html).pipe(gulp.dest(destinations.html))
)

gulp.task('lib', ->
  gulp.src(sources.lib).pipe(gulp.dest(destinations.lib))
)

gulp.task('server', ->
  gutil.log 'Express Server Running on Port:', gutil.colors.cyan(serverPort)
  gutil.log 'LiveReload Server Running on Port:', gutil.colors.cyan(liveReloadPort)
  server.listen(serverPort)
  refresh.listen(liveReloadPort)
  return
)

changedFile = (file) -> refresh.changed file.path

# Watched tasks
gulp.task('watch', ->
  gulp.watch(sources.lib, ['lib']).on('change', changedFile)
  gulp.watch(sources.sass, ['sass']).on('change', changedFile)
  gulp.watch(sources.html, ['html']).on('change', changedFile)
  gulp.watch(sources.coffee, ['coffee', 'lint']).on('change', changedFile)
  return
)

# Remove /dist directory
gulp.task('clean', ->
  gulp.src(['dist/'], read: false)
  .pipe(rimraf(force: true))
)

# Build sequence
gulp.task('build', ->
  runSequence('clean', ['coffee', 'lint', 'sass', 'html', 'lib'])
)

gulp.task('default', [
  'build'
  'server'
  'watch'
])
