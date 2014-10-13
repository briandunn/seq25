window.Seq25 = Ember.Application.create()

Seq25.ApplicationStore = DS.Store.extend
  adapter: DS.LSAdapter.extend
    namespace: 'seq25'
    defaultSerializer: 'local'

audioContext = do ->
  contextClass = 'AudioContext webkitAudioContext'.w().find (klass)->
    window[klass]
  new window[contextClass]

Seq25.register 'serializer:local',  DS.LSSerializer
Seq25.register 'audioContext:main', audioContext
