Seq25.PartView = Ember.View.extend

  didInsertElement: ->
    Mousetrap.bind 'c', =>
      @get('controller').send('createNote')
      return false

    Mousetrap.bind 'backspace', =>
      @get('controller').send('removeNotes')
      return false

    Mousetrap.bind 'shift+right', =>
      @get('controller').send('extendNotes')

    Mousetrap.bind 'shift+left', =>
      @get('controller').send('shortenNotes')

    Mousetrap.bind 'left', =>
      @get('controller').send('nudgeLeft')

    Mousetrap.bind 'right', =>
      @get('controller').send('nudgeRight')

  willDestroyElement: ->
    Mousetrap.unbind('backspace left right'.w())
