Seq25.PianoKeyController = Ember.ObjectController.extend
  needs: 'part'
  part: Ember.computed.alias('controllers.part')
  actions:
    play: -> @get('part.instruments').invoke 'play', @get('model')
    stop: -> @get('part.instruments').invoke 'stop', @get('model')
