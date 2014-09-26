Seq25.PartInstrumentsRoute = Ember.Route.extend
  controllerName: 'instruments'

  model: ->
    @modelFor('part').get 'instruments'

  renderTemplate: ->
    @render outlet: 'instruments', into: 'application'
