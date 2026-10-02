const RemoteSerializer = DS.JSONSerializer.extend({
  serializeHasMany(record, json, relationship){
    const {
      key
    } = relationship;
    return json[key.underscore()] = record.get(key).map(relationship=> {
      return this.serialize(relationship);
    });
  },

  serializeBelongsTo() {}
});
    //ignore them
export default RemoteSerializer;
