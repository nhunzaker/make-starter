module.exports = function(config){

  return config.set({
    frameworks: ['mocha', 'sinon-chai'],
    files: [
      '../app/assets/javascripts/**/__tests__/*'
    ],
    preprocessors: {
      '../app/assets/javascripts/**/__tests__/*': [ 'webpack' ]
    },
    webpack: require('./webpack'),
    webpackMiddleware: {
      noInfo: true
    },
    reporters: ['nyan'],
    browsers: [ 'Firefox' ]
  })

}
