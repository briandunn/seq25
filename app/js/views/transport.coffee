Seq25.TransportView = Ember.View.extend
  numberStack: []

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

    '0 1 2 3 4 5 6 7 8 9'.w().forEach (number) =>
      Mousetrap.bind(number, => @addToNumberStack(number))

  tagName: 'section'

  partForKey: (name) -> @get('controller').get("song").getPart(name)

  gotoPart: (partKey) ->
    @get('controller').transitionToRoute('part', @partForKey(partKey))

  mutePart: (partKey) ->
    @partForKey(partKey).toggle @get('controller').get('progress')

  bumpVolumeForPart: (partKey, direction="up") ->
    @partForKey(partKey).bumpVolume(direction, @numberFromStack())

  gotoSummary: ->
    @get('controller').transitionToRoute('parts')

  addToNumberStack: (number) ->
    @numberStack.push number

  numberFromStack: ->
    num = parseInt(@numberStack.join('')) || 1
    @numberStack = []
    num
