Seq25.Instrument = Ember.Object.extend
  volume:    Ember.computed.alias('part.volume')
  attack:    Ember.computed.alias('part.attack')
  sustain:   Ember.computed.alias('part.sustain')
  decay:     Ember.computed.alias('part.decay')
  resonance: Ember.computed.alias('part.resonance')
  save: -> @get('part').save()

  play: -> Seq25.Osc.play.apply(Seq25.Osc, arguments)
  stop: -> Seq25.Osc.stop.apply(Seq25.Osc, arguments)
