Seq25.InstrumentController = Ember.ObjectController.extend
  shapes: 'sine square sawtooth triangle'.w()

  actions:
    updateParameter: (param, value)->
      @set(param, value)
