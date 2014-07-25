Seq25.PartView = Ember.View.extend

  didInsertElement: ->
    Mousetrap.bind 'backspace', =>
      @get('controller').send('removeNotes')
      return false

    Mousetrap.bind 'right', =>
      @get('controller').send('extendNotes')

    Mousetrap.bind 'left', =>
      @get('controller').send('shortenNotes')

    Mousetrap.bind 'shift+left', =>
      @get('controller').send('nudgeLeft')

    Mousetrap.bind 'shift+right', =>
      @get('controller').send('nudgeRight')

  willDestroyElement: ->
    'backspace left right'.w().forEach(Mousetrap.unbind)
