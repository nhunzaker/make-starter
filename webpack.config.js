var path = require('path')

module.exports = {
  context: path.resolve('./app/assets/javascripts/'),

  entry: {
    page1 : './page1.js',
    page2 : './page2.js'
  },

  output: {
    path: './public/assets/javascripts/',
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
