PianoKeyController = Ember.Controller.extend
  needs: 'part'
  part: Ember.computed.alias('controllers.part.model')
  name: Em.computed.alias('model.name')
  isSharp: Em.computed.alias('model.isSharp')
  actions:
    play: -> @get('part').play @get('model')
    stop: -> @get('part').stop @get('model')

`export default PianoKeyController`
