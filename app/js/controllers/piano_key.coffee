Seq25.PianoKeyController = Ember.ObjectController.extend
  needs: 'part'
  part: Ember.computed.alias('controllers.part')
  instrument: Ember.computed.alias('part.instrument')

  actions:
    play: -> @get('instrument').play @get('model')
    stop: -> @get('instrument').stop @get('model')
