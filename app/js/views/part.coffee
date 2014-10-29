Seq25.PartView = Ember.View.extend

  didInsertElement: ->
    Seq25.Keystrokes.bind 'c', =>
      @get('controller').send('createNote')

    Seq25.Keystrokes.registerKeyDownEvents
      'backspace': => @get('controller').send('removeNotes'); return true
      'shift+right': (num) => @get('controller').send('extendNotes', num)
      'shift+left':  (num) => @get('controller').send('shortenNotes', num)
      'left':        (num) => @get('controller').send('nudgeLeft', num)
      'right':       (num) => @get('controller').send('nudgeRight', num)
      'up':    (num) => @get('controller').send('moveUp', num); return true
      'down':  (num) => @get('controller').send('moveDown', num); return true
      'ctrl+shift+right': (num) => @get('controller').send('addNoteRight', num)
      'ctrl+shift+left': (num) => @get('controller').send('addNoteLeft', num)
      'ctrl+shift+up': (num) => @get('controller').send('addNoteUp', num)
      'ctrl+shift+down': (num) => @get('controller').send('addNoteDown', num)
