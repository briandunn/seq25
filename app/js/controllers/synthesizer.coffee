Seq25.SynthesizerController = Ember.ObjectController.extend
  viewName: 'synthesizer'
  shapes: 'sine square sawtooth triangle'.w()

  saver: (->
    @get('model').save()
  ).observes('attack', 'filterFreq', 'filterQ', 'release', 'shape',  'volume')
