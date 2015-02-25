`import RemoteSong from "seq25/models/remote-song"`

LoadSongRoute = Ember.Route.extend
  model: ({id})->
    RemoteSong.saveInto(@store, id)

  setupController: (controller, song)->
    @transitionTo 'song', song

`export default LoadSongRoute`
