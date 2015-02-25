SongIndexController = Ember.ObjectController.extend
  song: Em.computed.alias 'model'
  parts: (->
    song = @get 'song'
    'Q W E R A S D F'.w().map (name)->
      song.getPart(name) || name: name, placeholder: true
  ).property('song.parts.[]')

  actions:
    addPart: (name)->
      part = @get('song.parts').createRecord(name: name)
      part.get('synthesizers').createRecord()

      @transitionToRoute('part', name)

`export default SongIndexController`
