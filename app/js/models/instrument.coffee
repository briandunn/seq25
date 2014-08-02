Seq25.Instrument = Ember.Object.extend
  volume:    Ember.computed.alias('part.volume')
  attack:    Ember.computed.alias('part.attack')
  sustain:   Ember.computed.alias('part.sustain')
  decay:     Ember.computed.alias('part.decay')
  resonance: Ember.computed.alias('part.resonance')
  isMuted:   Ember.computed.alias('part.isMuted')
  shape:     Ember.computed.alias('part.shape')
  save: -> @get('part').save()

  init: ->
    console.log 'instrument for:', @get('part.name')
    @set 'oscillators', {}
    @_super.apply(this, arguments)

  applySound: (->
    _.values(@get('oscillators')).forEach (oscillator)=>
      oscillator.set('shape', @get('shape'))
  ).observes 'shape'

  play: (pitch, secondsFromNow=0, duration=null)->
    unless @get 'isMuted'
      (@get('oscillators')[pitch.number] ||= Seq25.Osc.create(pitch: pitch))
        .play(secondsFromNow, duration)

  stop: (pitch, secondsFromNow=0)->
    @get('oscillators')[pitch.number]?.stop(secondsFromNow)
