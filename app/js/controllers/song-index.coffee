Seq25.SongIndexController = Ember.ObjectController.extend
  needs: 'song'
  song: ( ->
    @get('model') || @get('controllers.song.model')
  ).property('model', 'controllers.song.model')

  parts: (->
    song = @get 'song'
    'Q W E R A S D F'.w().map (name)->
      song.getPart(name) || name: name, placeholder: true
  ).property('song.parts.[]')

  actions:
    addPart: (name)->
      @get('song.parts').createRecord(name: name).save()
      @get('song').save()
      @transitionToRoute('part', name)
