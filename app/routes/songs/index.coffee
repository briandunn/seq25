`import Song from 'seq25/models/song'`
SongsIndexRoute = Ember.Route.extend
  model: ->
    @store.find('song')

`export default SongsIndexRoute`
