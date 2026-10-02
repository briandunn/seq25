import Pitch from "seq25/models/pitch";
const TICKS_PER_BEAT = 96;

const Note = DS.Model.extend({
  pitchNumber: DS.attr('number'),
  beat:        DS.attr('number'),
  tick:        DS.attr('number'),
  velocity:    DS.attr('number', {defaultValue: 0.75}),
  part:        DS.belongsTo('part'),
  duration:    DS.attr('number', {defaultValue: TICKS_PER_BEAT}),
  secondsPerBeat: Em.computed.alias('part.secondsPerBeat'),
  totalTicks:     Em.computed.alias('part.totalTicks'),

  pitch: Em.computed('pitchNumber', function() {
    return Pitch.all.findBy('number', this.get('pitchNumber'));
  }),

  setPitchNumber: (function() {
    return this.set('pitchNumber', Pitch.numberAtScale(this.get('position.y')));
  }).observes('position.y'),

  setBeatAndTick: (function() {
    const ticks = Math.round(this.get('beatCount') * TICKS_PER_BEAT * this.get('position.x'));
    this.set('absoluteTicks', ticks);
    return this.snap(this.get('quant'), Math.floor);
  }).observes('beatCount', 'position.x'),

  absolueSeconds: (function() {
    return this.ticksToTime(this.get('absoluteTicks'));
  }).property('absoluteTicks', 'secondsPerBeat'),

  durationSeconds: Em.computed('duration', 'secondsPerBeat', function() {
    return this.ticksToTime(this.get('duration'));
  }),

  absoluteTicks: (function(_, ticks){
    if (ticks === undefined) {
      return (this.get('beat') * TICKS_PER_BEAT) + this.get('tick');
    } else {
      this.setProperties({
        beat: Math.floor(ticks / TICKS_PER_BEAT),
        tick: ticks % TICKS_PER_BEAT
      });
      return ticks;
    }
  }).property('beat', 'tick'),

  isPitch(pitch){
    return this.get('pitchNumber') === pitch.number;
  },

  ticksToTime(ticks){
    return (ticks / TICKS_PER_BEAT) * this.get('secondsPerBeat');
  },

  snap(quant, round){
    if (!(quant > 0)) { return; }
    const ticksPerGrid = (1 / quant) * TICKS_PER_BEAT;
    const absoluteTicks = this.get('absoluteTicks');
    const snappedTicks = round(absoluteTicks / ticksPerGrid) * ticksPerGrid;
    if (snappedTicks !== absoluteTicks) {
      this.set('absoluteTicks', snappedTicks);
      return true;
    }
  },

  nudge(quant, round, direction){
    if (!this.snap(quant, round)) {
      const ticksPerGrid = (1 / (quant || TICKS_PER_BEAT)) * TICKS_PER_BEAT;
      const {absoluteTicks, totalTicks} = this.getProperties('absoluteTicks', 'totalTicks');
      const newTicks = absoluteTicks + (ticksPerGrid * direction);
      if (totalTicks >= newTicks && newTicks >= 0) {
        return this.set('absoluteTicks', newTicks);
      }
    }
  },

  nudgeLeft(quant){
    return this.nudge(quant, Math.floor, -1);
  },

  nudgeRight(quant){
    return this.nudge(quant, Math.ceil, 1);
  },

  moveUp(num) {
    return this.set('pitchNumber', Pitch.highest(this.get('pitchNumber') + num));
  },

  moveDown(num) {
    return this.set('pitchNumber', Pitch.lowest(this.get('pitchNumber') - num));
  },

  changeDuration(editResolution) {
    if ((this.get('duration') + editResolution) > 0) {
      return this.incrementProperty('duration', editResolution);
    }
  }
});

Note.TICKS_PER_BEAT = TICKS_PER_BEAT;

export default Note;
