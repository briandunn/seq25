const InstrumentsController = Ember.Controller.extend({
  midiInstruments: Em.computed.alias('model.midiInstruments'),
  synthesizers: Em.computed.alias('model.synthesizers'),
  actions: {
    addInstrument(collectionName){
      return this.get(collectionName).createRecord();
    },

    removeInstrument(instrument){
      return instrument.destroyRecord();
    }
  }
});

export default InstrumentsController;
