`import Keystrokes from "seq25/models/keystrokes"`

PartView = Ember.View.extend
  target: Em.computed.alias 'controller'

  didInsertElement: ->
    Keystrokes.bind 'c', =>
      @send('createNote')

    Keystrokes.registerKeyDownEvents
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

`export default PartView`
