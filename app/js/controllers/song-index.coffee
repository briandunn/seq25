Seq25.SongIndexController = Ember.ObjectController.extend
  song: Em.computed.alias 'model'
  rowSize: 4
  parts: (->
    song = @get 'song'
    'Q W E R A S D F'.w().map (name)->
      song.getPart(name) || name: name, placeholder: true
  ).property('song.parts.[]')
  rows: (->
    [0,1].map (x)=>
      @get('parts').slice @get('rowSize') * x, @get('rowSize') + (@get('rowSize') * x)
  ).property('parts', 'rowSize')

  actions:
    addPart: (name)->
      @get('song.parts').createRecord(name: name).save()
      @get('song').save()
      @transitionToRoute('part', name)
