Seq25.ApplicationView = Ember.View.extend

  didInsertElement: ->
    Seq25.Keystrokes.bind "shift+?", =>
      @get('controller').toggleHelp()
