Seq25.Song = DS.Model.extend
  tempo: DS.attr 'number', defaultValue: 120
  parts: DS.hasMany 'part'

  beatCounts: Ember.computed.mapBy('parts', 'beat_count')

  maxBeatCount: Ember.computed.max('beatCounts')

  getPart: (name)->
    parts = @get('parts')
    parts.findBy('name', name) || parts.createRecord(name: name).save()

  schedule: (progress)->
    @get('parts').forEach (part)=>
      part.schedule progress

  stop: ->
    @get('parts').forEach (part)->
      part.stop()

  save: ->
    @_super()
    @get('parts').invoke 'save'

Seq25.Song.loadDefault = (store)->
  new Ember.RSVP.Promise (resolve, reject) =>
    store.find('song').then (songs)=>
      song = songs.get('firstObject') || store.createRecord('song')
      store.find('part', song: song.get('id')).then (parts)=>
        promises = parts.map (part)=>
          store.find 'note', part: part.get('id')
        Ember.RSVP.Promise.all(promises).then =>
          resolve(song)
