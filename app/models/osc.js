const Osc = Ember.Object.extend({
  attack:     Em.computed.alias('synthesizer.attack'),
  context:    Em.computed.alias('synthesizer.context'),
  filterFreq: Em.computed.alias('synthesizer.filterFreq'),
  filterQ:    Em.computed.alias('synthesizer.filterQ'),
  output:     Em.computed.alias('synthesizer.output'),
  release:    Em.computed.alias('synthesizer.release'),
  shape:      Em.computed.alias('synthesizer.shape'),

  init() {
    const {context, output} = this.getProperties('context', 'output');
    this.filter = context.createBiquadFilter();
    const gain    = context.createGain();
    gain.gain.value = 0;
    this.filter.connect(gain);
    gain.connect(output);
    this.gain = gain.gain;

    this.oscillator = context.createOscillator();
    this.oscillator.frequency.value = this.get('pitch.freq');
    this.oscillator.start(0);

    this.noise = context.createScriptProcessor(1 << 14);
    this.noise.onaudioprocess = event => (() => {
      const result = [];
      for (var channel of [0, 1]) {
        var out = event.outputBuffer.getChannelData(channel);
        result.push(__range__(0, event.outputBuffer.length, true).map((i) => (out[i] = Math.random())));
      }
      return result;
    })();

    return this._super();
  },

  setShape: (function() {
    const shape = this.get('shape');
    if (shape === 'noise') {
      this.oscillator.disconnect();
      return this.noise.connect(this.filter);
    } else {
      this.noise.disconnect();
      this.oscillator.type = this.get('shape');
      return this.oscillator.connect(this.filter);
    }
  }).observes('shape').on('init'),

  setFilterQ: (function() {
    return this.filter.Q.value = this.get('filterQ') * 100;
  }).observes('filterQ').on('init'),

  setFilterFreq: (function() {
    const {context, filterFreq} = this.getProperties('context', 'filterFreq');
    return this.filter.frequency.value = filterFreq * (context.sampleRate / 2);
  }).observes('filterFreq').on('init'),

  play(secondsFromNow, rampTo, duration=null){
    if (rampTo == null) { rampTo = 1; }
    const {context, attack} = this.getProperties('context', 'attack');
    const contextTime = context.currentTime + secondsFromNow;
    this.gain.setValueAtTime(0, contextTime);
    this.gain.linearRampToValueAtTime(rampTo, contextTime + attack);
    if (duration) { return this.stop(secondsFromNow + duration); }
  },

  stop(secondsFromNow){
    if (secondsFromNow == null) { secondsFromNow = 0; }
    const {context, release} = this.getProperties('context', 'release');
    const contextTime = context.currentTime + (secondsFromNow - 0.003);
    return this.gain.linearRampToValueAtTime(0, contextTime + release);
  }
});

export default Osc;

function __range__(left, right, inclusive) {
  let range = [];
  let ascending = left < right;
  let end = !inclusive ? right : ascending ? right + 1 : right - 1;
  for (let i = left; ascending ? i < end : i > end; ascending ? i++ : i--) {
    range.push(i);
  }
  return range;
}