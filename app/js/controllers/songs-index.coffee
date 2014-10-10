Seq25.SongsIndexController = Ember.ArrayController.extend
  actions:
    addSong: ->
      song = @store.createRecord('song')
      song.save()
      @transitionToRoute('song', song)
    removeSong: (song)->
      if confirm '!'
        song.destroyRecord()
    sendToServer: (song)->
      Seq25.Song.load(@store, song.get('id')).then (song)=>
        serializer = @container.lookup('serializer:remote')
        data = serializer.serialize song
        Em.$.ajax
          data: JSON.stringify data
          dataType: 'json'
          contentType: 'application/json; charset=utf-8'
          type: 'POST'
          url:  '/songs'
          success: (response)=>
            song.set 'remoteId', response.id
            song.save()
