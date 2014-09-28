Seq25.InstrumentsController = Ember.ObjectController.extend
  actions:
    addInstrument: (collectionName)->
      @get(collectionName).createRecord().save()
      @get('model').save()

    removeInstrument: (instrument)->
      collection = @get "#{instrument.constructor.typeKey}s"
      collection.removeRecord(instrument)
      instrument.destroyRecord()
      @get('model').save()
