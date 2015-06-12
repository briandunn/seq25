InstrumentsController = Ember.Controller.extend
  midiInstruments: Em.computed.alias 'model.midiInstruments'
  synthesizers: Em.computed.alias 'model.synthesizers'
  actions:
    addInstrument: (collectionName)->
      @get(collectionName).createRecord()

    removeInstrument: (instrument)->
      collection = @get "#{instrument.constructor.modelName}s"
      instrument.destroyRecord()

`export default InstrumentsController`
