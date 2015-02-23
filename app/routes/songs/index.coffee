`import Song from 'seq25/models/song'`
SongsIndexRoute = Ember.Route.extend
  model: ->
    new Em.RSVP.Promise (resolve, reject)=>
      @store.find('song')
      .then (songs)=>
        promises = songs.map (song)=>
          Song.load(@store, song.get('id'))
        Em.RSVP.all(promises)
        .then (songs)->
          resolve(songs)

`export default SongsIndexRoute`
