import Note from "seq25/models/note";
import Pitch from "seq25/models/pitch";

const times = function(count, fn){
  let i = 0;
  return (() => {
    const result = [];
    while (i < count) {
      fn();
      result.push(i++);
    }
    return result;
  })();
};

const PartController = Ember.Controller.extend({
  TICKS_PER_BEAT: Note.TICKS_PER_BEAT,

  pitches: ((() => Pitch.all)).property(),
  needs: ['transport', 'selectionBox'],
  transport: Em.computed.alias('controllers.transport'),
  quant: 1,

  totalTicks: Em.computed.alias('model.totalTicks'),
  beatCount: Em.computed.alias('model.beatCount'),
  beats: (function() { return __range__(1, this.get('beatCount'), true);  }).property('beatCount'),
  notes: Em.computed.alias('model.notes'),
  secondsPerBeat: Em.computed.alias('model.secondsPerBeat'),
  name: Em.computed.alias('model.name'),

  selectedNotes: Em.computed.alias('controllers.selectionBox.selected'),

  editResolution: (function() {
    const q = parseInt(this.get('quant')) || this.TICKS_PER_BEAT;
    const beatSlice = 1 / q;
    return beatSlice * this.TICKS_PER_BEAT;
  }).property('quant'),

  changeNoteDuration(direction, num){
    return this.get('selectedNotes').invoke('changeDuration', this.get('editResolution') * num * direction);
  },

  addAdjacentNotes(num, addNoteCallback) {
    const {selectedNotes, editResolution, quant, model} = this.getProperties('selectedNotes', 'editResolution', 'quant', 'model');
    const selectionBox =  this.get('controllers.selectionBox');
    let firstLength = selectedNotes.get('firstObject.duration');
    if (!selectedNotes.every(n => n.get("duration") === firstLength)) { firstLength = editResolution; }
    const newNotes = selectedNotes
    .map(function(note){
      let newNote;
      const {pitchNumber, absoluteTicks, duration} = addNoteCallback(
        note.getProperties('pitchNumber', 'absoluteTicks', 'duration'), num, firstLength
      );
      return newNote = model.addNote(pitchNumber, absoluteTicks, duration, quant);
    });
    return selectionBox.send('toggle', newNotes);
  },

  actions: {
    removeNotes() {
      const selectedNotes = this.get('selectedNotes');
      var removeOne = function(note){
        if (note) {
          return note.destroyRecord().then(() => removeOne(selectedNotes.popObject()));
        }
      };
      return removeOne(selectedNotes.popObject());
    },

    addNote(position){
      const note = this.get('model').addNoteAtPoint(position, this.get('quant'));
      return this.get('controllers.selectionBox').send('toggle', [note]);
    },

    addNoteLeft(num) {
      return this.addAdjacentNotes(num, function(attributes, moveNum, moveDistance) {
        const absoluteTicks = attributes.absoluteTicks - ((moveDistance || attributes.duration) * moveNum);
        return Em.merge(attributes, {absoluteTicks});
      });
    },

    addNoteRight(num) {
      return this.addAdjacentNotes(num, function(attributes, moveNum, moveDistance) {
        const absoluteTicks = attributes.absoluteTicks + ((moveDistance || attributes.duration) * moveNum);
        return Em.merge(attributes, {absoluteTicks});
      });
    },

    addNoteDown(num) {
      return this.addAdjacentNotes(num, (attributes, moveNum) => Em.merge(attributes, {pitchNumber: attributes.pitchNumber - moveNum}));
    },

    addNoteUp(num) {
      return this.addAdjacentNotes(num, (attributes, moveNum) => Em.merge(attributes, {pitchNumber: attributes.pitchNumber + moveNum}));
    },

    extendNotes(num) {
      return this.changeNoteDuration(1, num);
    },

    shortenNotes(num) {
      return this.changeNoteDuration(-1, num);
    },

    nudgeLeft(num) {
      return times(num, () => this.get('selectedNotes').invoke('nudgeLeft', this.get('quant')));
    },

    nudgeRight(num) {
      return times(num, () => this.get('selectedNotes').invoke('nudgeRight', this.get('quant')));
    },

    createNote() {
      return this.send('addNote', {x: 0, y: 0});
    },

    moveUp(num) {
      return this.get('selectedNotes').invoke('moveUp', num);
    },

    moveDown(num) {
      return this.get('selectedNotes').invoke('moveDown', num);
    },

    setVelocity(num) {
      return this.get('selectedNotes').invoke('set', 'velocity', Math.min((num / 10), 1.0));
    }
  }
});

export default PartController;

function __range__(left, right, inclusive) {
  let range = [];
  let ascending = left < right;
  let end = !inclusive ? right : ascending ? right + 1 : right - 1;
  for (let i = left; ascending ? i < end : i > end; ascending ? i++ : i--) {
    range.push(i);
  }
  return range;
}