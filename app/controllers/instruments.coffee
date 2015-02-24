Seq25.InstrumentsController = Ember.ObjectController.extend
  actions:
    addInstrument: (collectionName)->
      @get(collectionName).createRecord()

    removeInstrument: (instrument)->
      collection = @get "#{instrument.constructor.typeKey}s"
      collection.removeRecord(instrument)
      instrument.destroyRecord()
