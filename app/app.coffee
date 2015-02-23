`import Ember from 'ember'`
`import DS from 'ember-data'`
`import Resolver from 'ember/resolver'`
`import loadInitializers from 'ember/load-initializers'`
`import config from './config/environment'`

Ember.MODEL_FACTORY_INJECTIONS = true

App = Ember.Application.extend
  modulePrefix: config.modulePrefix
  podModulePrefix: config.podModulePrefix
  ApplicationAdapter: DS.LSAdapter.extend
    namespace: 'seq25'
    defaultSerializer: 'local'
  ApplicationSerializer: DS.LSSerializer
  Resolver: Resolver

Em.Application.initializer
  name: 'register-stuff'
  initialize: (container, application)->

    audioContext = do ->
      contextClass = 'AudioContext webkitAudioContext'.w().find (klass)->
        window[klass]
      new window[contextClass]

    application.register 'audioContext:main', audioContext

loadInitializers(App, config.modulePrefix)

`export default App`
