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

    '0 1 2 3 4 5 6 7 8 9'.w().forEach (number) =>
      Mousetrap.bind(number, => Seq25.numStack.push(number))

  tagName: 'section'

  partForKey: (name) -> @get('controller').get("song").getPart(name)

  gotoPart: (partKey) ->
    @get('controller').transitionToRoute('part', @partForKey(partKey))

  mutePart: (partKey) ->
    @partForKey(partKey).toggle @get('controller').get('progress')

  bumpVolumeForPart: (partKey, direction="up") ->
    @partForKey(partKey).bumpVolume(direction, Seq25.numStack.drain())

  gotoSummary: ->
    @get('controller').transitionToRoute('parts')

class Seq25.NumStack
  stack: []

  push: (num) ->
    @stack.push(num)

  drain: () ->
    num = parseInt(@stack.join('')) || 1
    @stack = []
    num

Seq25.numStack = new Seq25.NumStack()
