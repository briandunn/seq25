Seq25.InstrumentController = Ember.ObjectController.extend
  shapes: 'sine square sawtooth triangle'.w()

  volumeSaver: ( ->
    @get('model').save()
  ).observes('volume')
