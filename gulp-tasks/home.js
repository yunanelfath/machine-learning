var gulp = require('gulp'),
    elixir      = require('laravel-elixir'),
    gutil       = require('gulp-util'),
    webpackStream = require('webpack-stream'),
    environment = require("../environment.config"),
    webpack = require('webpack');
var Task       = elixir.Task;
var assets = {
  output:{
    jsPath: 'dist/js',
    jsDesktop: 'bundle.js',
  },
  input: {
    js: 'resources/assets/genetic/index.cjsx',
  }
}
console.log(environment)
elixir.extend('home', function(message){
  new Task('genetic-algorithm',function(){
    return gulp.src(assets.input.js)
      .pipe(webpackStream({
        output: {
          filename: assets.output.jsDesktop
        },
        module: {
          loaders: [
            {
              test: /\.s?css$/,
              exclude: /node_modules/,
              use: [
                { loader: "style-loader" },
                {
                  loader: "css-loader",
                  options: {
                    modules: true,
                    localIdentName:'[local]'
                  }
                },
                {
                  loader: "ruby-sass-loader",
                  options: {
                    modules: true,
                    compass: true
                  }
                }
              ]
            },
            {
              query: {
                  presets: ['es2015']
              },
              test: /\.cjsx$/, loader: "coffee-jsx-loader",// all you have to do is just load this loader
            }
          ]
        },
        plugins: environment.production.plugins
      }))
      .pipe(gulp.dest(assets.output.jsPath));
  }).watch(['resources/assets/**/*.cjsx']);
})
