Seq25.InstrumentController = Ember.ObjectController.extend
  shapes: 'sine square sawtooth triangle'.w()

  saver: (->
    @get('model').save()
  ).observes('attack', 'filterFreq', 'filterQ', 'release', 'shape',  'volume')
