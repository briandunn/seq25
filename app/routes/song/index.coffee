SongIndexRoute = Ember.Route.extend
  model: ->
    @modelFor 'song'

  renderTemplate: ->
    @render 'parts/index', into: 'song'

`export default SongIndexRoute`
