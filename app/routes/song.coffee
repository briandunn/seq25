`import Song from 'seq25/models/song'`

SongRoute = Ember.Route.extend
  model: (param)->
    new Em.RSVP.Promise (resolve, reject)=>
      @store.find 'song'
      .then (songs)->
        resolve(songs.findBy('id', param.song_id))

  setupController: (controller, song)->
    @controllerFor('transport').set('model', song)
    controller.set('model', song)

  saveBeforeClose: (->
    Em.$(window).bind 'beforeunload', =>
      @store.all('song').invoke 'save'
      return
  ).on 'init'

`export default SongRoute`
