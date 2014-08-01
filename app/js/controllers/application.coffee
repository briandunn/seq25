Seq25.ApplicationController = Ember.ObjectController.extend

  tempoSaver: ( ->
    @get('model').save()
  ).observes('tempo')

  actions:
    commit: ->
      debugger
