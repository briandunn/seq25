`import Keystrokes from "seq25/models/keystrokes"`

ApplicationView = Ember.View.extend
  didInsertElement: ->
    Keystrokes.bind "shift+?", =>
      @get('controller').toggleHelp()

`export default ApplicationView`
