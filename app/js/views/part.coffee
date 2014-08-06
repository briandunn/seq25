Seq25.PartView = Ember.View.extend

  didInsertElement: ->
    Mousetrap.bind 'c', =>
      @keyEvent( => @get('controller').send('createNote'))
      return false

    Mousetrap.bind 'backspace', =>
      @keyEvent( => @get('controller').send('removeNotes'))
      return false

    Mousetrap.bind 'shift+right', =>
      @keyEvent( (num) => @get('controller').send('extendNotes', num))

    Mousetrap.bind 'shift+left', =>
      @keyEvent( (num) => @get('controller').send('shortenNotes', num))

    Mousetrap.bind 'left', =>
      @keyEvent( (num) => @get('controller').send('nudgeLeft', num))

    Mousetrap.bind 'right', =>
      @keyEvent( (num) => @get('controller').send('nudgeRight', num))

  keyEvent: (handler) ->
    handler(Seq25.numStack.drain())

  willDestroyElement: ->
    Mousetrap.unbind('backspace left right'.w())
