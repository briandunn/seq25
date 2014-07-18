Seq25.PartView = Ember.View.extend

  didInsertElement: ->
    Mousetrap.bind 'backspace', =>
      @get('controller').send('removeNotes')
      return false

    Mousetrap.bind 'right', =>
      @get('controller').send('extendNotes')

  willDestroyElement: ->
    Mousetrap.unbind 'backspace left'
