Seq25.InstrumentsController = Ember.ArrayController.extend
  lookupItemController: (instrument)->
    instrument.constructor.typeKey

  actions:
    addInstrument: ->
      instrument = @store.createRecord 'synthesizer'
      @pushObject instrument
      instrument.get('part').save()
