Seq25.PartView = Ember.View.extend

  didInsertElement: ->
    Mousetrap.bind 'backspace', =>
      @get('controller').send('removeNotes')
      return false

  willDestroyElement: ->
    Mousetrap.unbind 'backspace'
