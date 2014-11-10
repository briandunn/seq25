Seq25.PianoKeyController = Ember.ObjectController.extend
  needs: 'part'
  part: Ember.computed.alias('controllers.part.model')
  actions:
    play: -> @get('part').play @get('model')
    stop: -> @get('part').stop @get('model')
