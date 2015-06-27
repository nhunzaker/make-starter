var path = require('path')

var isDevelopment = process.env.NODE_ENV !== 'production'

module.exports = {
  debug: isDevelopment,

  devtool: isDevelopment ? '#eval-source-map' : 'source-map',

  context: path.resolve(__dirname, '..', './app/assets/javascripts/'),

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
