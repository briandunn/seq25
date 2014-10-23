Seq25.RemoteSerializer = DS.JSONSerializer.extend
  serializeHasMany: (record, json, relationship)->
    key = relationship.key
    json[key.underscore()] = record.get(key).map @serialize.bind this

  serializeBelongsTo: ->
    #ignore them
