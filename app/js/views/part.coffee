Seq25.PartView = Ember.View.extend

  didInsertElement: ->
    Mousetrap.bind 'backspace', =>
      @get('controller').send('removeNotes')
      return false

    Mousetrap.bind 'right', =>
      @get('controller').send('extendNotes')

    Mousetrap.bind 'left', =>
      @get('controller').send('shortenNotes')

  willDestroyElement: ->
    'backspace left right'.w().forEach(Mousetrap.unbind)
