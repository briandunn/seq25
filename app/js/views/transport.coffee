Seq25.TransportView = Ember.View.extend
  didInsertElement: ->
    Mousetrap.bind("t", => @gotoSummary())

    Mousetrap.bind("space", (e)=>
      e.preventDefault()
      @get('controller').send('play'))

    'q w e r a s d f'.w().forEach (partKey) =>
      Mousetrap.bind("g #{partKey}", => @gotoPart(partKey.toUpperCase()))
      Mousetrap.bind("m #{partKey}", => @mutePart(partKey.toUpperCase()))
      Mousetrap.bind "n #{partKey}", => @bumpVolumeForPart(partKey.toUpperCase())
      Mousetrap.bind("shift+n #{partKey}", => @bumpVolumeForPart(partKey.toUpperCase(), "down"))

  tagName: 'section'

  partForKey: (name) -> @get('controller').get("song").getPart(name)

  gotoPart: (partKey) ->
    @get('controller').transitionToRoute('part', @partForKey(partKey))

  mutePart: (partKey) ->
    @partForKey(partKey).toggle @get('controller').get('progress')

  bumpVolumeForPart: (partKey, direction="up") ->
    @partForKey(partKey).bumpVolume(direction)

  gotoSummary: ->
    @get('controller').transitionToRoute('parts')
