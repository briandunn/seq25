Seq25.Song = DS.Model.extend
  tempo: DS.attr 'number', defaultValue: 120
  parts: DS.hasMany 'part'

  beatCounts: Ember.computed.mapBy('parts', 'beat_count')

  maxBeatCount: Ember.computed.max('beatCounts')

  getPart: (name)->
    parts = @get('parts')
    parts.findBy('name', name) || parts.createRecord(name: name).save()

  schedule: ->
    @get('parts').forEach (part)=>
      part.schedule @get 'tempo'

  stop: ->
    @get('parts').forEach (part)->
      part.stop()
