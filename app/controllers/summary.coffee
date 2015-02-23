Seq25.PartsSummaryController = Ember.ObjectController.extend
  needs: 'transport'
  transport: Em.computed.alias 'controllers.transport'
