Seq25.PartView = Ember.View.extend
  target: Em.computed.alias 'controller'

  didInsertElement: ->
    Seq25.Keystrokes.bind 'c', =>
      @send('createNote')

    Seq25.Keystrokes.registerKeyDownEvents
      'backspace': => @send('removeNotes'); return true
      'shift+right': (num) => @send('extendNotes', num)
      'shift+left':  (num) => @send('shortenNotes', num)
      'left':        (num) => @send('nudgeLeft', num)
      'right':       (num) => @send('nudgeRight', num)
      'up':    (num) => @send('moveUp', num); return true
      'down':  (num) => @send('moveDown', num); return true
      'ctrl+shift+right': (num) => @send('addNoteRight', num)
      'ctrl+shift+left': (num) => @send('addNoteLeft', num)
      'ctrl+shift+up': (num) => @send('addNoteUp', num)
      'ctrl+shift+down': (num) => @send('addNoteDown', num)
      'v': (num) => @send 'setVelocity', num
