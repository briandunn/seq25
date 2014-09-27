Seq25.InstrumentsController = Ember.ArrayController.extend
  lookupItemController: (instrument)->
    instrument.constructor.typeKey

  actions:
    addInstrument: ->
      instrument = @store.createRecord 'synthesizer'
      @pushObject instrument
      instrument.get('part').save()

    removeInstrument: (instrument)->
      {part, id} = instrument.getProperties 'part', 'id'
      @removeObject @findProperty 'id', id
      part.save()
      instrument.destroyRecord()
