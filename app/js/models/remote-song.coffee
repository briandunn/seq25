URL = if window.location.hostname == 'seq25.com' then 'http://seq25.herokuapp.com/songs' else '/songs'

extract = (store, model, payload)->
  creations = []
  flattenHasManys = (model, payload)->
    relations = {}
    model.eachRelationship (name, relationship)->
      related = payload[name]
      delete payload[name]
      if (relationship.kind == 'hasMany') and related
        relations[name.camelize()] = related.map (payload)->
          flattenHasManys(relationship.type, payload)
    record = store.createRecord model.typeKey, payload
    for name, records of relations
      record.get(name).pushObjects records
    creations.push(record)
    record

  flattenHasManys model, payload
  creations

Seq25.RemoteSong =
  saveInto: (store, id)->
    new Em.RSVP.Promise (resolve, reject)=>
      Em.$.get("#{URL}/#{id}").then (data)=>
        models = extract(store, store.modelFor('song'), data)
        song = models.pop()
        song.save().then ->
          Em.RSVP.all(models.invoke('save')).then ->
            resolve(song)

  send: (serializer, song)->
    data = serializer.serialize song
    Em.$.ajax
      data:         JSON.stringify data
      dataType:    'json'
      contentType: 'application/json; charset=utf-8'
      type:        'POST'
      url:         URL
      success: (response)=>
        song.set 'remoteId', response.id
        song.save()

  all: ->
    Em.$.get URL

