Seq25.PartInstrumentRoute = Ember.Route.extend
  controllerName: 'instrument'

  model: ->
    @modelFor('part').get('instrument')

  renderTemplate: ->
    @render outlet: 'instrument', into: 'application'
