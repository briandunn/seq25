Seq25.ApplicationController = Ember.ObjectController.extend

  showHelp: false

  tempoSaver: ( ->
    @get('model').save()
  ).observes('tempo')

  toggleHelp: ->
    @toggleProperty('showHelp')
    @send('openHelp')
