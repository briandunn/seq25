window.Seq25 = Ember.Application.create()

Seq25.ApplicationStore = DS.Store.extend
  adapter: DS.LSAdapter.extend
    namespace: 'seq25'
    defaultSerializer: 'local'

audioContext = do ->
  contextClass = 'AudioContext webkitAudioContext'.w().find (klass)->
    window[klass]
  new window[contextClass]

remoteSerializer = DS.ActiveModelSerializer.extend
  serializeHasMany: (record, json, relationship)->
    key = relationship.key
    json[key.underscore()] = record.get(key).map @serialize.bind this

  serializeBelongsTo: ->
    #ignore them

Seq25.register 'serializer:local',  DS.LSSerializer
Seq25.register 'serializer:remote', remoteSerializer
Seq25.register 'audioContext:main', audioContext
