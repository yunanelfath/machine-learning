const webpack = require('webpack'),
      gutil = require("gulp-util");

var productionPlugins = gutil.env.production !== undefined && gutil.env.production ? [
  new webpack.optimize.UglifyJsPlugin({
      compress: {
          warnings: false
      },
      comments: false,
      sourceMap: true
  }),
	new webpack.ProgressPlugin(function(percentage, message) {
		const percent = Math.round(percentage * 100);
		process.stderr.clearLine();
		process.stderr.cursorTo(0);
		process.stderr.write(percent + "% " + message);
	})
] : [];
var production = {
  plugins: productionPlugins
}
exports.production = production;
