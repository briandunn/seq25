window.Seq25 = Ember.Application.create()

Seq25.ApplicationSerializer = DS.LSSerializer.extend()

Seq25.ApplicationAdapter = DS.LSAdapter.extend namespace: 'seq25'

audioContext = do ->
  contextClass = 'AudioContext webkitAudioContext'.w().find (klass)->
    window[klass]
  new window[contextClass]

Seq25.register 'audioContext:main', audioContext
