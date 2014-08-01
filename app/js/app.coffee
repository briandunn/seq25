window.Seq25 = Ember.Application.create()

Seq25.ApplicationSerializer = DS.LSSerializer.extend()

Seq25.SongSerializer = Seq25.ApplicationSerializer.extend
  attrs:
    parts:
      embedded: 'always'

  serializeHasMany: (record, json, relationship)->
    key = relationship.key
    hasManyRecords = Ember.get(record, key)
    # Embed hasMany relationship if records exist
    if (hasManyRecords && @attrs[relationship.key].embedded == 'always')
      json._embedded = {}
      json._embedded[key] = []
      hasManyRecords.forEach (item, index)->
        json._embedded[key].push(item.serialize())
    # Fallback to default serialization behavior
    else
      @_super(record, json, relationship)

Seq25.ApplicationAdapter = DS.LSAdapter.extend namespace: 'seq25'

Seq25.audioContext = do ->
  contextClass = 'AudioContext webkitAudioContext'.w().find (klass)->
    window[klass]
  new window[contextClass]
