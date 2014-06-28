Seq25.ApplicationController = Ember.ObjectController.extend
  actions:
    setTempo: (val)->
      @get('model').set 'tempo', val
