PartsSummaryController = Ember.Controller.extend
  needs: 'transport'
  transport: Em.computed.alias 'controllers.transport'

  secondsPerBeat: Em.computed.alias 'model.secondsPerBeat'
  beat_count: Em.computed.alias 'model.beat_count'
  notes: Em.computed.alias 'model.notes'

`export default PartsSummaryController`
