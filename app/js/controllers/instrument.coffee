Seq25.InstrumentController = Ember.ObjectController.extend
  shapes: 'sine square sawtooth triangle'.w()

  saver: Em.observer 'volume', 'shape', 'attack', 'resonance', ->
    @get('model').save()
