require! {
  gulp
  del,
  'node-notifier': notifier
}
$ = (require \gulp-load-plugins)!
sync = (require \browser-sync).create!

do ->
  c = $.util.colors
  $.util.log 'Basic', c.yellow('Pug + Sass + ES6'), 'buildfile by', c.magenta(\monnef)

printError = (msg) ->
  notifier.notify({
    title: 'Error'
    message: msg
  })

gulp.task \default, [\help]

gulp.task \help, $.taskListing

srcDir = \src
destDir = \dist

sassGlob = srcDir + '/sass/**/*.sass'
babelGlob = srcDir + '/js/**/*.js'
pugGlob = srcDir + '/pug/**/*.pug'
assetsGlob = srcDir + '/assets/**/*.*'

gulp.task \sass, ->
  gulp.src sassGlob
    .pipe $.sass().on('error', (err) ->
      $.util.log(err)
      printError('Sass compilation failed.')
      @emit('end')
    )
    .pipe gulp.dest destDir
    .pipe sync.stream!

gulp.task \babel, ->
  gulp.src babelGlob
    .pipe $.babel({presets:[\es2015]})
    .pipe gulp.dest destDir
    .pipe sync.stream!

gulp.task \pug, ->
  gulp.src pugGlob
    .pipe $.pug({}).on('error', (err) -> 
      $.util.log(err)
      printError('Pug compilation failed.')
      @emit('end')
    )
    .pipe gulp.dest destDir
    .pipe sync.stream!

gulp.task \assets, ->
  gulp.src assetsGlob
    .pipe gulp.dest destDir
    .pipe sync.stream!

gulp.task \build, [\sass \babel \pug \assets]

gulp.task \watch, [\build], !->
  gulp.watch sassGlob, [\sass]
  gulp.watch babelGlob, [\babel]
  gulp.watch pugGlob, [\pug]
  gulp.watch assetsGlob, [\assets]

gulp.task \serve, [\watch], !->
  sync.init(
    server: 
      baseDir: './dist'
  )

gulp.task \clean, ->
  del(destDir)
