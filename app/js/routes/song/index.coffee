Seq25.SongIndexRoute = Ember.Route.extend
  model: ->
    @modelFor 'song'

  renderTemplate: ->
    @render 'parts/index', into: 'song'
