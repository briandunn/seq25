const PlayBarComponent = Ember.Component.extend({
  beat: Em.computed.alias('transport.beat'),
  isPlaying: Em.computed.alias('transport.isPlaying'),
  beatCount: Em.computed.alias('part.beatCount'),
  secondsPerBeat: Em.computed.alias('part.secondsPerBeat'),

  loopCount: (function() {
    return Math.floor(this.get('beat') / this.get('beatCount'));
  }).property('beat', 'beatCount'),

  isEvenLoop: (function() { return (this.get('loopCount') % 2) === 0;  }).property('loopCount'),

  progress: (function() {
    return (this.get('beat') % this.get('beatCount')) / this.get('beatCount');
  }).property('beat', 'beatCount'),

  playBarOne: (function() {
    return this.toStyleAttribute(this.get('isEvenLoop'));
  }).property('secondsPerBeat', 'progress', 'isPlaying'),

  playBarTwo: (function() {
    return this.toStyleAttribute(!this.get('isEvenLoop'));
  }).property('secondsPerBeat', 'progress', 'isPlaying'),

  toStyleAttribute(active){
    const {progress, beatCount, secondsPerBeat, isPlaying} =
      this.getProperties('progress', 'beatCount', 'secondsPerBeat', 'isPlaying');

    const [left, duration] = Array.from(isPlaying && active ?
      [(progress + (1/beatCount)), secondsPerBeat]
    :
      [-0.02, 0]);
    return `transition-duration: ${duration}s; left: ${left * 100}%`.htmlSafe();
  }
});

export default PlayBarComponent;
