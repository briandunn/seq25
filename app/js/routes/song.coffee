Seq25.SongRoute = Ember.Route.extend
  model: (param)->
    Seq25.Song.load @store, param.song_id

  setupController: (controller, song)->
    @controllerFor('transport').set('model', song)
    controller.set('model', song)
