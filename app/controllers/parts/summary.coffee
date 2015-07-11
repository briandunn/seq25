PartsSummaryController = Ember.Controller.extend
  needs: 'transport'
  transport: Em.computed.alias 'controllers.transport'

  secondsPerBeat: Em.computed.alias 'model.secondsPerBeat'
  beatCount: Em.computed.alias 'model.beatCount'
  notes: Em.computed.alias 'model.notes'

`export default PartsSummaryController`
