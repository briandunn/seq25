do ->
  stubGain =
    setValueAtTime: ->
    cancelScheduledValues: ->
    connect: ->
    gain: {}

  stubOscillator =
    frequency: {}
    start: ->
    connect: ->

  Seq25.audioContext =
    currentTime: 0
    createGain: -> stubGain
    createOscillator: -> stubOscillator

Seq25.setupForTesting()
emq.globalize()
setResolver Ember.DefaultResolver.create namespace: Seq25
Seq25.injectTestHelpers()

QUnit.testStart ->
  Seq25.reset()
