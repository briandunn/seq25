`import Song from 'seq25/models/song'`

SongRoute = Ember.Route.extend
  model: (param)->
    Song.load @store, param.song_id

  setupController: (controller, song)->
    @controllerFor('transport').set('model', song)
    controller.set('model', song)

`export default SongRoute`
