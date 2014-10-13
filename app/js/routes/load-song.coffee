Seq25.LoadSongRoute = Ember.Route.extend
  model: ({id})->
    Seq25.RemoteSong.saveInto(@store, id)

  setupController: (controller, song)->
    @transitionTo 'song', song
