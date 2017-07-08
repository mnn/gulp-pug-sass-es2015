require! {
  gulp
  del
}
$ = (require \gulp-load-plugins)!

do ->
  c = $.util.colors
  $.util.log 'Basic', c.yellow('Pug + Sass + ES6'), 'buildfile by', c.magenta(\monnef)

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
    .pipe $.sass()
    .pipe gulp.dest destDir

gulp.task \babel, ->
  gulp.src babelGlob
    .pipe $.babel({presets:[\es2015]})
    .pipe gulp.dest destDir

gulp.task \pug, ->
  gulp.src pugGlob
    .pipe $.pug({})
    .pipe gulp.dest destDir

gulp.task \assets, ->
  gulp.src assetsGlob
    .pipe gulp.dest destDir

gulp.task \build, [\sass \babel \pug \assets]

gulp.task \watch, [\build], !->
  gulp.watch sassGlob, [\sass]
  gulp.watch babelGlob, [\babel]
  gulp.watch pugGlob, [\pug]
  gulp.watch assetsGlob, [\assets]

gulp.task \serve, [\watch], ->
  gulp.src destDir
    .pipe $.serverLivereload({
      +livereload
      +open
      port: 3000
    })

gulp.task \clean, ->
  del(destDir)
