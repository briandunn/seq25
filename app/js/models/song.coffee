Seq25.Song = DS.Model.extend
  tempo: DS.attr 'number', defaultValue: 120
  parts: DS.hasMany 'part'
  secondsPerBeat: (-> 60 / @get('tempo') ).property('tempo')

  getPart: (name)->
    @get('parts').findBy 'name', name

  schedule: (now, from, to)->
    @get('parts').invoke 'schedule', now, from, to

  stop: ->
    @get('parts').invoke 'stop'

  save: ->
    @_super()
    @get('parts').invoke 'save'

Seq25.Song.load = (store, id)->
  new Ember.RSVP.Promise (resolve, reject)->
    store.find('song', id).then (song)->
      store.find('part', song: song.get('id')).then (parts)->
        promises = parts.map (part)->
          store.find 'note', part: part.get('id')
        Ember.RSVP.Promise.all(promises).then ->
          resolve(song)
