let number;
const NOTE_NAMES = "A A# B C C# D D# E F F# G G#".w();
const A0_PITCH = 27.5;

const Pitch = Ember.Object.extend({
  pitch: Em.computed(function() { return this; }),

  init() {
    number = this.get('number');
    this.set('name', NOTE_NAMES[(number - 21) % 12] + Math.round((number - 17) / 12));
    this.set('freq', A0_PITCH * Math.pow(2, (number - 21)/12));
    return this.set('isSharp', this.get('name').indexOf('#') > 0);
  }}).reopenClass({
  numberAtScale(scale){
    return this.all[Math.floor(this.all.length * scale)].get('number');
  },

  scaleAtPitch(pitch){
    return this.all.indexOf(pitch) / this.all.length;
  },

  highest(num){
    return Math.min(this.all.get('firstObject.number'), num);
  },

  lowest(num){
    return Math.max(this.all.get('lastObject.number'), num);
  }
});

const pitches = (() => {
  const result = [];
  for (number = 21; number <= 108; number++) {
    result.push(Pitch.create({number}));
  }
  return result;
})();
Pitch.all = pitches.reverse();

export default Pitch;
