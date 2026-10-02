import Keystrokes from "seq25/models/keystrokes";

const PartView = Ember.View.extend({
  target: Em.computed.alias('controller'),

  didInsertElement() {
    Keystrokes.bind('c', () => {
      return this.send('createNote');
    });

    return Keystrokes.registerKeyDownEvents({
      'backspace': () => { this.send('removeNotes'); return true; },
      'shift+right': num => this.send('extendNotes', num),
      'shift+left':  num => this.send('shortenNotes', num),
      'left':        num => this.send('nudgeLeft', num),
      'right':       num => this.send('nudgeRight', num),
      'up':    num => { this.send('moveUp', num); return true; },
      'down':  num => { this.send('moveDown', num); return true; },
      'ctrl+shift+right': num => this.send('addNoteRight', num),
      'ctrl+shift+left': num => this.send('addNoteLeft', num),
      'ctrl+shift+up': num => this.send('addNoteUp', num),
      'ctrl+shift+down': num => this.send('addNoteDown', num),
      'v': num => this.send('setVelocity', num)
    });
  }
});

export default PartView;
