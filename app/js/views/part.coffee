Seq25.PartView = Ember.View.extend

  didInsertElement: ->
    Seq25.Keystrokes.bind 'c', =>
      @keyEvent( => @get('controller').send('createNote'))
      return false

    Seq25.Keystrokes.bind 'backspace', =>
      @keyEvent( => @get('controller').send('removeNotes'))
      return false

    Seq25.Keystrokes.bind 'shift+right', =>
      @keyEvent( (num) => @get('controller').send('extendNotes', num))

    Seq25.Keystrokes.bind 'shift+left', =>
      @keyEvent( (num) => @get('controller').send('shortenNotes', num))

    Seq25.Keystrokes.bind 'left', =>
      @keyEvent( (num) => @get('controller').send('nudgeLeft', num))

    Seq25.Keystrokes.bind 'right', =>
      @keyEvent( (num) => @get('controller').send('nudgeRight', num))

    Mousetrap.bind 'up', =>
      @keyEvent( (num) => @get('controller').send('moveUp', num))

    Mousetrap.bind 'down', =>
      @keyEvent( (num) => @get('controller').send('moveDown', num))

  keyEvent: (handler) ->
    handler(Seq25.numStack.drain())

  willDestroyElement: ->
    Mousetrap.unbind('backspace left right'.w())
