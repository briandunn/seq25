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
      Em.$.get("/songs/#{id}").then (data)=>
        models = extract(store, store.modelFor('song'), data)
        song = models.pop()
        song.save().then ->
          Em.RSVP.all(models.invoke('save')).then ->
            resolve(song)
