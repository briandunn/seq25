`import Ember from 'ember'`

stop = -> @get('part').stop @get('pitch')
play = -> @get('part').play @get('pitch')

PianoKeyComponent = Ember.Component.extend
  name: Em.computed.alias('pitch.name')
  isSharp: Em.computed.alias('pitch.isSharp')
  classNameBindings: ['isSharp:sharp', ':row']
  tagName: 'li'

  mouseLeave: stop
  mouseUp:    stop
  mouseDown:  play

`export default PianoKeyComponent`
