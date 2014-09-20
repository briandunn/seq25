Seq25.InstrumentController = Ember.ObjectController.extend
  shapes: 'sine square sawtooth triangle'.w()

  saver: Em.observer 'volume', 'shape', 'attack', ->
    @get('model').save()
