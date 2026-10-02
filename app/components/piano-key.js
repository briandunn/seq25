import Ember from 'ember';

const stop = function() { return this.get('part').stop(this.get('pitch')); };
const play = function() { return this.get('part').play(this.get('pitch')); };

const PianoKeyComponent = Ember.Component.extend({
  name: Em.computed.alias('pitch.name'),
  isSharp: Em.computed.alias('pitch.isSharp'),
  classNameBindings: ['isSharp:sharp', ':row'],
  tagName: 'li',

  mouseLeave: stop,
  mouseUp:    stop,
  mouseDown:  play
});

export default PianoKeyComponent;
