RemoteSerializer = DS.JSONSerializer.extend
  serializeHasMany: (record, json, relationship)->
    key = relationship.key
    json[key.underscore()] = record.get(key).map (relationship)=>
      @serialize(relationship)

  serializeBelongsTo: ->
    #ignore them
`export default RemoteSerializer`
