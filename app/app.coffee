`import Ember from 'ember'`
`import DS from 'ember-data'`
`import Resolver from 'ember/resolver'`
`import loadInitializers from 'ember/load-initializers'`
`import config from './config/environment'`

Ember.MODEL_FACTORY_INJECTIONS = true

App = Ember.Application.extend
  modulePrefix: config.modulePrefix
  podModulePrefix: config.podModulePrefix
  Resolver: Resolver

unless config.skipAudioContext
  Em.Application.initializer
    name: 'register-stuff'
    initialize: (container, application)->
      contextClass = 'AudioContext webkitAudioContext'.w().find (klass)-> window[klass]
      application.register 'audioContext:main', new window[contextClass]

loadInitializers(App, config.modulePrefix)

`export default App`
