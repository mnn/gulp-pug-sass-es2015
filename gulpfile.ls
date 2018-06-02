require! {
  gulp
  del
  'node-notifier': notifier
  beeper
}
$ = (require \gulp-load-plugins)!
sync = (require \browser-sync).create!

do ->
  c = $.util.colors
  $.util.log 'Basic', c.yellow('Pug + Sass + ES2015 + LiveScript'), 'buildfile by', c.magenta(\monnef)

notifyError = (msg) ->
  notifier.notify({
    title: 'Error'
    message: msg
  })
  beeper!

gulp.task \default, [\help]

gulp.task \help, $.taskListing

srcDir = \src
destDir = \dist

sassGlob = srcDir + '/sass/**/*.sass'
babelGlob = srcDir + '/js/**/*.js'
livescriptGlob = srcDir + '/js/**/*.ls'
pugGlob = srcDir + '/pug/**/*.pug'
assetsGlob = srcDir + '/assets/**/*.*'

gulp.task \sass, ->
  gulp.src sassGlob
    .pipe $.sass().on('error', (err) ->
      $.util.log(err)
      notifyError('Sass compilation failed.')
      @emit('end')
    )
    .pipe gulp.dest destDir
    .pipe sync.stream!

gulp.task \babel, ->
  gulp.src babelGlob
    .pipe $.babel({presets:[\es2015]}).on('error', (err) ->
      $.util.log(err)
      notifyError('JavaScript compilation failed.')
      @emit('end')
    )
    .pipe gulp.dest destDir
    .pipe sync.stream!

gulp.task \livescript, ->
  gulp.src livescriptGlob
    .pipe $.livescript({bare: true}).on('error', (err) ->
      $.util.log(err)
      notifyError('LiveScript compilation failed.')
      @emit('end')
    )
    .pipe gulp.dest destDir
    .pipe sync.stream!

gulp.task \pug, ->
  gulp.src pugGlob
    .pipe $.pug({}).on('error', (err) ->
      $.util.log(err)
      notifyError('Pug compilation failed.')
      @emit('end')
    )
    .pipe gulp.dest destDir
    .pipe sync.stream!

gulp.task \assets, ->
  gulp.src assetsGlob
    .pipe gulp.dest destDir
    .pipe sync.stream!

gulp.task \build, [\sass \babel \livescript \pug \assets]

gulp.task \watch, [\build], !->
  gulp.watch sassGlob, [\sass]
  gulp.watch babelGlob, [\babel]
  gulp.watch livescriptGlob, [\livescript]
  gulp.watch pugGlob, [\pug]
  gulp.watch assetsGlob, [\assets]

gulp.task \serve, [\watch], !->
  sync.init(
    server:
      baseDir: './dist'
  )

gulp.task \clean, ->
  del(destDir)

gulp.task \test-error, ->
  notifyError('Some text...')
