Seq25.PartView = Ember.View.extend

  didInsertElement: ->
    Seq25.Keystrokes.bind 'c', =>
      @get('controller').send('createNote')

    Seq25.Keystrokes.keyDownBind 'backspace', =>
      @get('controller').send('removeNotes')
      return true

    Seq25.Keystrokes.keyDownBind 'shift+right', (num) =>
      @get('controller').send('extendNotes', num)

    Seq25.Keystrokes.keyDownBind 'shift+left', (num) =>
      @get('controller').send('shortenNotes', num)

    Seq25.Keystrokes.keyDownBind 'left', (num) =>
      @get('controller').send('nudgeLeft', num)

    Seq25.Keystrokes.keyDownBind 'right', (num) =>
      @get('controller').send('nudgeRight', num)

    Seq25.Keystrokes.keyDownBind 'up', (num) =>
      @get('controller').send('moveUp', num)
      return true

    Seq25.Keystrokes.keyDownBind 'down', (num) =>
      @get('controller').send('moveDown', num)
      return true
