Seq25.Instrument = Ember.Object.extend
  volume:    Ember.computed.alias('part.volume')
  attack:    Ember.computed.alias('part.attack')
  sustain:   Ember.computed.alias('part.sustain')
  decay:     Ember.computed.alias('part.decay')
  resonance: Ember.computed.alias('part.resonance')
  isMuted:   Ember.computed.alias('part.isMuted')
  save: -> @get('part').save()

  oscillators: {}

  play: (pitch, secondsFromNow=0, duration=null)->
    unless @get 'isMuted'
      (@oscillators[pitch.number] ||= new Seq25.Osc(pitch))
        .play(secondsFromNow, duration)

  stop: (pitch, secondsFromNow=0)->
    @oscillators[pitch.number]?.stop(secondsFromNow)
