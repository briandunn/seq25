Seq25.Instrument = Ember.Object.extend
  attack:     Em.computed.alias 'part.attack'
  filterFreq: Em.computed.alias 'part.filterFreq'
  filterQ:    Em.computed.alias 'part.filterQ'
  isMuted:    Em.computed.alias 'part.isMuted'
  release:  Em.computed.alias 'part.release'
  shape:      Em.computed.alias 'part.shape'
  volume:     Em.computed.alias 'part.volume'
  context:   Seq25.audioContext

  save: -> @get('part').save()

  init: ->
    @set 'oscillators', {}
    context = @get('context')
    @set('output', context.createGain())
    @get('output').connect context.destination
    @_super.apply(this, arguments)

  adjustVolume: (->
    @get('output').gain.value = @get('volume')
  ).observes('volume').on('init')

  play: (pitch, secondsFromNow=0, duration=null)->
    unless @get 'isMuted'
      (@get('oscillators')[pitch.number] ||= Seq25.Osc.create(pitch: pitch, instrument: this))
        .play(secondsFromNow, duration)

      Seq25.midi.play(pitch.name, secondsFromNow, duration)

  stop: (pitch, secondsFromNow=0)->
    @get('oscillators')[pitch.number]?.stop(secondsFromNow)
    Seq25.midi.sendOffAt(pitch.name, secondsFromNow)
