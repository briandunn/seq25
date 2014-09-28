Seq25.MidiInstrumentController = Ember.ObjectController.extend
  saver: (->
    @get('model').save()
  ).observes('channel')
