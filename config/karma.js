module.exports = function(config){

  return config.set({
    frameworks: ['mocha', 'sinon-chai'],
    files: [
      'app/assets/javascripts/**/__tests__/*'
    ],
    preprocessors: {
      'app/assets/javascripts/**/__tests__/*': ['webpack']
    },
    webpack: require('./webpack'),
    reporters: ['nyan'],
    browsers: [ 'Firefox' ]
  })

}
