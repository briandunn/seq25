Seq25.SongsIndexController = Ember.ArrayController.extend
  actions:
    addSong: ->
      song = @store.createRecord('song')
      song.save()
      @transitionToRoute('song', song)
    removeSong: (song)->
      if confirm '!'
        song.destroyRecord()
