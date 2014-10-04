Seq25.SongsIndexRoute = Ember.Route.extend
  model: ->
    @store.find 'song'
