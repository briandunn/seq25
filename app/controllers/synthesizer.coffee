Seq25.SynthesizerController = Ember.ObjectController.extend
  shapes: 'sine square sawtooth triangle noise'.w()

  saver: (->
    @get('model').save()
  ).observes('attack', 'filterFreq', 'filterQ', 'release', 'shape',  'volume')
