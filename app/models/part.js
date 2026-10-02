import Note from "seq25/models/note";

const eachInstrument = function() {
  return (() => {
    const result = [];
    const object = this.getProperties('midiInstruments', 'synthesizers');
    for (var _ in object) {
      var value = object[_];
      result.push(value.invoke.apply(value, arguments));
    }
    return result;
  })();
};

const Part = DS.Model.extend({
  notes:           DS.hasMany('note'),
  synthesizers:    DS.hasMany('synthesizer'),
  midiInstruments: DS.hasMany('midiInstrument'),
  song:            DS.belongsTo('song'),
  name:            DS.attr('string'),
  volume:          DS.attr('number', {defaultValue: 0.75}),
  beatCount:       DS.attr('number', {defaultValue: 16}),
  isMuted:         DS.attr('boolean', {defaultValue: false}),
  secondsPerBeat: Em.computed.alias('song.secondsPerBeat'),

  totalTicks: Em.computed('beatCount', function() {
    return Note.TICKS_PER_BEAT * this.get('beatCount');
  }),

  duration: Em.computed('secondsPerBeat', 'beatCount', function() {
    return this.get('secondsPerBeat') * this.get('beatCount');
  }),

  toggle() {
    return this.toggleProperty('isMuted');
  },

  schedule(now, from, to){
    const {duration, notes} = this.getProperties('duration', 'notes');
    const loopOffset = Math.floor(from / duration) * duration;
    return notes.forEach(note=> {
      let start = loopOffset + note.get('absolueSeconds');
      return (() => {
        const result = [];
        while (start < to) {
          if (start >= from) {
            eachInstrument.call(this, 'play', note, start - now);
          }
          result.push(start += duration);
        }
        return result;
      })();
    });
  },

  stop(pitch){
    return eachInstrument.call(this, 'stop', pitch);
  },

  play(pitch){
    return eachInstrument.call(this, 'play', pitch);
  },

  addNoteAtPoint(position, quant){
    return this.get('notes').createRecord({
      position,
      beatCount: this.get('beatCount'),
      quant
    });
  },

  addNote(pitchNumber, ticks, duration, quant){
    return this.get('notes').createRecord({
      pitchNumber,
      absoluteTicks: ticks,
      duration,
      quant
    });
  },

  bumpVolume(direction, multiplier) {
    if (multiplier == null) { multiplier = 1; }
    let amount = 0.1 * multiplier;
    if (direction === "down") { amount = amount * -1; }
    return this.incrementProperty('volume', amount);
  },

  destroyRecord() {
    for (var collection of Array.from('notes synthesizers midiInstruments'.w())) {
      this.get(collection).forEach(item=> {
        return this.store.unloadRecord(item);
      });
    }
    return this._super();
  }
});

export default Part;
