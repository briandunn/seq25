Seq25.PartStatusController = Ember.Controller.extend
  needs: ['transport']

  part: Em.computed.alias('model')
  name: (-> @get('part').name || @get('part').get('name')).property('part')
  isMuted: Em.computed.alias('model.isMuted')
  isPlaceholder: Em.computed.alias('model.placeholder')
  currentPart: Em.computed.alias('controllers.transport.currentPart')

  isCurrentPart: (-> @get('currentPart') == @get('name')).property('currentPart', 'name')
