Seq25.SongsIndexRoute = Ember.Route.extend
  model: ->
    new Em.RSVP.Promise (resolve, reject)=>
      @store.find('song')
      .then (songs)=>
        promises = songs.map (song)=>
          Seq25.Song.load(@store, song.get('id'))
        Em.RSVP.all(promises)
        .then (songs)->
          resolve(songs)
