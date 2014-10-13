Seq25.RemoteSerializer = DS.JSONSerializer.extend
  serializeAttribute: (record, json, key, attribute)->
    @_super(record, json, key, attribute) unless key == 'remoteId'

  serializeHasMany: (record, json, relationship)->
    key = relationship.key
    json[key.underscore()] = record.get(key).map @serialize.bind this

  serializeBelongsTo: ->
    #ignore them
