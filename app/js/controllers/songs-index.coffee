Seq25.SongsIndexController = Ember.ArrayController.extend
  refreshRemoteSongs: (->
    Seq25.RemoteSong.all().then (songs)=>
      @set 'remoteSongs', songs
  ).observes('@each.remoteId').on 'init'

  actions:
    addSong: ->
      song = @store.createRecord('song')
      song.save()
      @transitionToRoute('song', song)

    removeSong: (song)->
      Seq25.Song.load(@store, song.get('id')).then (song)=>
        if Ember.testing || confirm '!'
          song.destroyRecord()
          @removeObject(song)

    sendToServer: (song)->
      Seq25.Song.load(@store, song.get('id')).then (song)=>
        serializer = @container.lookup('serializer:remote')
        Seq25.RemoteSong.send(serializer, song)
