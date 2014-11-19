Seq25.SongIndexController = Ember.ObjectController.extend
  song: Em.computed.alias 'model'
  parts: (->
    song = @get 'song'
    'Q W E R A S D F'.w().map (name)->
      song.getPart(name) || name: name, placeholder: true
  ).property('song.parts.[]')

  actions:
    addPart: (name)->
      @get('song.parts').createRecord(name: name).save().then (part) ->
        part.get('synthesizers').createRecord().save()

      @get('song').save()
      @transitionToRoute('part', name)
