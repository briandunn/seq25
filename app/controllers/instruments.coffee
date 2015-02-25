InstrumentsController = Ember.ObjectController.extend
  actions:
    addInstrument: (collectionName)->
      @get(collectionName).createRecord()

    removeInstrument: (instrument)->
      collection = @get "#{instrument.constructor.typeKey}s"
      instrument.destroyRecord()

`export default InstrumentsController`
