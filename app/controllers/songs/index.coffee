`import Song from "seq25/models/song"`
`import RemoteSong from "seq25/models/remote-song"`
SongsIndexController = Ember.ArrayController.extend
  init: ->
    @_super()
    @set('remoteSongs', [])

  refreshRemoteSongs: (->
    RemoteSong.all().then (response)=>
      @set 'remoteSongs', response.songs
  ).observes('@each.remoteId').on 'init'

  actions:
    addSong: ->
      song = @store.createRecord('song')
      @transitionToRoute('song', song)

    removeSong: (song)->
      if Ember.testing || confirm '!'
        song.destroyRecord()

    sendToServer: (song)->
      serializer = @container.lookup('serializer:remote')
      RemoteSong.send(serializer, song)

`export default SongsIndexController`
