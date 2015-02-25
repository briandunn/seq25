PartInstrumentsRoute = Ember.Route.extend
  controllerName: 'instruments'

  model: ->
    @modelFor 'part'

  renderTemplate: ->
    @render outlet: 'instruments', into: 'song'

`export default PartInstrumentsRoute`
