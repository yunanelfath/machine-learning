var elixir = require('laravel-elixir'),
    util = require('gulp-util').env,
    Task = elixir.Task;

require('./gulp-tasks/home');

elixir(function(mix) {
    var page = util.page === undefined ? undefined : util.page.split(',');
    var build = page === undefined ? [
    'home'
    ] : page;

    for(var i=0;i<= build.length-1;i++){
        if(typeof mix[build[i]] == 'function'){
            mix[build[i]]();
        }
    }
});
