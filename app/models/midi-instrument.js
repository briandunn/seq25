import Midi from "seq25/models/midi";
import Pitch from "seq25/models/pitch";

const MidiInstrument = DS.Model.extend({
  part:    DS.belongsTo('part'),
  channel: DS.attr('number', {defaultValue: 1}),
  volume:  DS.attr('number', {defaultValue: 0.75}),
  isMuted: Em.computed.alias('part.isMuted'),

  play(note, start){
    if (this.get('isMuted')) { return; }
    const {durationSeconds, velocity} = note.getProperties('durationSeconds', 'velocity');
    const {volume, channel} = this.getProperties('volume', 'channel');
    return Midi.connect().then(midi=> {
      return midi.play(note.get('pitch.number'), velocity * volume, channel, start, durationSeconds);
    });
  },

  stop(note){
    return Midi.connect().then(midi=> {
      const channel = this.get('channel');
      if (note) {
        return midi.stop(note.get('pitch.number'), channel);
      } else {
        return Array.from(Pitch.all).map((pitch) =>
          midi.stop(pitch, channel));
      }
    });
  }
});

export default MidiInstrument;
