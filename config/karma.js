module.exports = function (config) {

  return config.set({
    frameworks: [ 'mocha' ],
    client: {
      mocha: {
        ui: 'qunit'
      }
    },
    files: [
      '../test/**/*.test.js'
    ],
    preprocessors: {
      '../test/**/*.test.js': [ 'webpack' ]
    },
    webpack: require('./webpack'),
    webpackMiddleware: {
      noInfo: true
    },
    phantomjsLauncher: {
      exitOnResourceError: true
    },
    browsers: process.env.CIRCLECI ? [ 'Firefox', 'Chrome', 'PhantomJS' ] : [ 'PhantomJS' ]
  })

}
