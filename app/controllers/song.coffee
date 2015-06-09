SongController = Ember.Controller.extend
  remoteURL: Em.computed.alias 'model.remoteURL'
  tempo: Em.computed.alias 'model.tempo'

`export default SongController`
