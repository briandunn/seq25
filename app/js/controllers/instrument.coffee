Seq25.InstrumentController = Ember.ObjectController.extend
  actions:
    updateParameter: (param, value)->
      @set(param, value)
      @get('model').save()
