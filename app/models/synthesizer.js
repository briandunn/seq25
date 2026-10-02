import Osc from "seq25/models/osc";

const Synthesizer = DS.Model.extend({
  part:       DS.belongsTo('part'),
  shape:      DS.attr('string', {defaultValue: 'sine'}),
  attack:     DS.attr('number', {defaultValue: 0}),
  release:    DS.attr('number', {defaultValue: 0}),
  filterFreq: DS.attr('number', {defaultValue: 1}),
  filterQ:    DS.attr('number', {defaultValue: 0}),
  volume:     DS.attr('number', {defaultValue: 0.75}),
  isMuted:    Em.computed.alias('part.isMuted'),
  context:    Em.computed(function() { return this.container._registry.resolve('audioContext:main'); }),

  init() {
    this._super();
    this.set('oscillators', {});
    const context = this.get('context');
    this.set('output', context.createGain());
    return this.get('output').connect(context.destination);
  },

  adjustVolume: (function() {
    const {output, volume} = this.getProperties('output', 'volume');
    return output.gain.value = volume;
  }).observes('volume'),

  ready() {
    this.adjustVolume();
    return this.mute();
  },

  mute: (function() {
    const {output, isMuted} = this.getProperties('output', 'isMuted');
    if (isMuted) {
      return output.disconnect();
    } else {
      return output.connect(this.get('context').destination);
    }
  }).observes('isMuted'),

  findOrCreateOscillator(pitch){
    let base, name;
    return (base = this.get('oscillators'))[name = pitch.get('number')] || (base[name] = Osc.create({
      pitch,
      synthesizer: this
    }));
  },

  play(note, secondsFromNow){
    if (secondsFromNow == null) { secondsFromNow = 0; }
    const {pitch, durationSeconds, velocity} = note.getProperties('pitch', 'durationSeconds', 'velocity');
    return this.findOrCreateOscillator(pitch).play(secondsFromNow, velocity, durationSeconds);
  },

  stop(pitch){
    const oscillators = this.get('oscillators');
    if (pitch) {
      return __guard__(oscillators[pitch.get('number')], x => x.stop());
    } else {
      return (() => {
        const result = [];
        for (var _ in oscillators) {
          var value = oscillators[_];
          result.push(value.stop());
        }
        return result;
      })();
    }
  }
});

export default Synthesizer;

function __guard__(value, transform) {
  return (typeof value !== 'undefined' && value !== null) ? transform(value) : undefined;
}