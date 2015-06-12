ApplicationController = Ember.Controller.extend

  showHelp: false

  toggleHelp: ->
    @toggleProperty('showHelp')
    @send('openHelp')

`export default ApplicationController`
