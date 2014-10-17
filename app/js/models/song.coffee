Seq25.Song = DS.Model.extend
  parts:    DS.hasMany 'part'
  remoteId: DS.attr 'number'
  tempo:    DS.attr 'number', defaultValue: 120
  secondsPerBeat: (-> 60 / @get('tempo') ).property('tempo')

  getPart: (name)->
    @get('parts').findBy 'name', name

  schedule: (now, from, to)->
    @get('parts').invoke 'schedule', now, from, to

  stop: ->
    @get('parts').invoke 'stop'

  destroyRecord: ->
    @get('parts').invoke 'destroyRecord'
    @_super()

Seq25.Song.load = (store, id)->
  new Ember.RSVP.Promise (resolve, reject)->
    store.find('song', id).then (song)->
      store.find('part', song: song.get('id')).then (parts)->
        promises = parts.map (part)->
          store.find 'note', part: part.get('id')
        Ember.RSVP.Promise.all(promises).then ->
          resolve(song)
