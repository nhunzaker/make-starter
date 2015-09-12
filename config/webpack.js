var Path = require('path')
var Webpack = require('webpack')
var isDevelopment = process.env.NODE_ENV !== 'production'
var settings = require('../package')

module.exports = {
  devtool: isDevelopment ? '#eval-source-map' : 'source-map',

  entry: [ settings.main ],

  output: {
    path: Path.resolve(__dirname, '../tmp/js'),
    filename: [ settings.name, settings.version, 'js' ].join('.')
  },

  plugins: [
    new Webpack.DefinePlugin({
      "process.env.NODE_ENV": JSON.stringify(process.env.NODE_ENV)
    })
  ],

  resolve: {
    extensions: [ '', '.js', '.json' ]
  },

  module: {
    loaders: [
      {
        test: /\.jsx*$/,
        loader: 'babel',
        exclude: /node_modules/
      },
      {
        test: /\.json$/,
        loader: 'json'
      }
    ]
  }
}
