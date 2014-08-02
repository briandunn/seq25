Seq25.PianoKeyView = Ember.View.extend
  attributeBindings: ['class']
  classNames: ['row']
  classNameBindings: ['isSharp']
  isSharp: (-> 'sharp' if @get('controller.isSharp')).property()
  tagName: 'li'

  mouseLeave: -> @get('controller').send 'stop'
  mouseUp:    -> @get('controller').send 'stop'
  mouseDown:  -> @get('controller').send 'play'

Ember.Handlebars.helper 'piano-key', Seq25.PianoKeyView
