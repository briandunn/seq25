PianoKeyView = Ember.View.extend
  classNameBindings: ['isSharp', ':row']
  isSharp: (-> 'sharp' if @get('controller.isSharp')).property()
  tagName: 'li'

  mouseLeave: -> @get('controller').send 'stop'
  mouseUp:    -> @get('controller').send 'stop'
  mouseDown:  -> @get('controller').send 'play'

`export default PianoKeyView`
