import ENV from './../config/environment';
const SERVER_URL = ENV.serverURL;

const extract = function(store, model, payload){
  const creations = [];
  var flattenHasManys = function(modelName, payload){
    const relations = {};
    store.modelFor(modelName).eachRelationship(function(name, relationship){
      const related = payload[name];
      delete payload[name];
      if ((relationship.kind === 'hasMany') && related) {
        return relations[name.camelize()] = related.map(payload => flattenHasManys(relationship.type, payload));
      }
    });
    const record = store.createRecord(modelName, payload);
    for (var name in relations) {
      var records = relations[name];
      record.get(name).pushObjects(records);
    }
    creations.push(record);
    return record;
  };

  flattenHasManys(model.modelName, payload);
  return creations;
};

const RemoteSong = {
  find(store, id){
    return new Em.RSVP.Promise(resolve=> {
      return Em.$.get(`${SERVER_URL}/${id}`).then(data=> {
        const models = extract(store, store.modelFor('song'), data);
        const song = models.pop();
        return song.save().then(() => Em.RSVP.all(models.invoke('save')).then(() => resolve(song)));
      });
    });
  },

  send(serializer, song){
    const data = serializer.serialize(new DS.Snapshot(song._internalModel));
    return Em.$.ajax({
      data:        JSON.stringify(data),
      dataType:    'json',
      contentType: 'application/json; charset=utf-8',
      type:        'POST',
      url:         SERVER_URL,
      success: response=> {
        song.set('remoteId', response.id);
        return song.save();
      }
    });
  },

  all() {
    return Em.$.get(SERVER_URL);
  }
};

export default RemoteSong;
