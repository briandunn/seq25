`import RemoteSong from "seq25/models/remote-song"`

SongRoute = Ember.Route.extend
  model: (param)->
    new Em.RSVP.Promise (resolve, reject)=>
      @store.find 'song'
      .then (songs)=>
        song = songs.findBy('id', param.song_id)
        if song
          resolve(song)
        else
          RemoteSong.find(@store, param.song_id)
          .then (song)->
            resolve(song)
          .catch ->
            reject('not found')

  setupController: (controller, song)->
    @controllerFor('transport').set('model', song)
    controller.set('model', song)

  saveBeforeClose: (->
    Em.$(window).bind 'beforeunload', =>
      @store.all('song').invoke 'save'
      return
  ).on 'init'

  actions:
    addAndGotoPart: (name)->
      @controllerFor('song/index').send('addPart', name)

`export default SongRoute`
