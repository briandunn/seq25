Seq25.TransportView = Ember.View.extend
  didInsertElement: ->
    Mousetrap.bind("t", => @gotoSummary())

    Mousetrap.bind("space", (e)=>
      e.preventDefault()
      @get('controller').send('play'))

    'q w e r a s d f'.w().forEach (partKey) =>
      Mousetrap.bind("g #{partKey}", => @gotoPart(partKey.toUpperCase()))
      Mousetrap.bind("m #{partKey}", => @mutePart(partKey.toUpperCase()))

  tagName: 'section'

  partForKey: (name) -> @get('controller').get("song").getPart(name)

  gotoPart: (partKey) ->
    @get('controller').transitionToRoute('part', @partForKey(partKey))

  mutePart: (partKey) ->
    @partForKey(partKey).toggle @get('controller').get('progress')

  gotoSummary: ->
    @get('controller').transitionToRoute('parts')
