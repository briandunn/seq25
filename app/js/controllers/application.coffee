Seq25.ApplicationController = Ember.ObjectController.extend

  showHelp: false

  toggleHelp: ->
    @toggleProperty('showHelp')
    @send('openHelp')
