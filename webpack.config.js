var path   = require('path')
var config = require('./')

module.exports = {
  context: path.resolve(config.sourceAssets + '/javascripts/'),

  entry: {
    page1 : './page1.js',
    page2 : './page2.js'
  },

  output: {
    path: config.publicAssets + '/javascripts/',
    filename: '[name].js',
    publicPath: 'assets/javascripts/'
  },

  module: {
    loaders: [{
      test: /\.js*$/,
      loader: 'babel',
      exclude: /node_modules/
    }]
  }
}
