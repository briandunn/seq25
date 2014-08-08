Seq25.TransportView = Ember.View.extend
  didInsertElement: ->
    Mousetrap.bind("t", => @keyEvent( => @gotoSummary()))

    Mousetrap.bind("space", (e) =>
      e.preventDefault()
      @keyEvent( => @get('controller').send('play')))

    'q w e r a s d f'.w().forEach (partKey) =>
      Mousetrap.bind "g #{partKey}", =>
        @keyEvent( => @gotoPart(partKey.toUpperCase()))
      Mousetrap.bind "m #{partKey}", =>
        @keyEvent( => @mutePart(partKey.toUpperCase()))
      Mousetrap.bind "b #{partKey}", =>
        @keyEvent( (num) => @changeBeatsForPart(partKey.toUpperCase(), "up", num))
      Mousetrap.bind "x #{partKey}", =>
        @keyEvent( (num) => @changeQuantForPart(partKey.toUpperCase(), num))
      Mousetrap.bind "n #{partKey}", =>
        @keyEvent( (num) => @bumpVolumeForPart(partKey.toUpperCase(), "up", num))
      Mousetrap.bind "shift+n #{partKey}", =>
        @keyEvent( (num) => @bumpVolumeForPart(partKey.toUpperCase(), "down", num))

    '0 1 2 3 4 5 6 7 8 9'.w().forEach (number) =>
      Mousetrap.bind(number, => Seq25.numStack.push(number))

  tagName: 'section'

  partForKey: (name) -> @get('controller').get("song").getPart(name)

  gotoPart: (partKey) ->
    part = @partForKey(partKey)
    if part
      @get('controller').transitionToRoute('part', part)
    else
      @get('controller').send('addPart', partKey)

  mutePart: (partKey) ->
    @partForKey(partKey)?.toggle @get('controller').get('progress')

  bumpVolumeForPart: (partKey, direction="up", num) ->
    @partForKey(partKey)?.bumpVolume(direction, num)

  changeBeatsForPart: (partKey, direction="up", num) ->
    if num is 1
      @partForKey(partKey)?.incrementProperty("beat_count", num)
    else
      @partForKey(partKey)?.set("beat_count", num)

  changeQuantForPart: (partKey, num) ->
    if num is 1
      @get('controller.controllers.part').incrementProperty("quant", num)
    else
      @get('controller.controllers.part').set("quant", num)

  gotoSummary: ->
    @get('controller').transitionToRoute('parts')

  keyEvent: (handler) ->
    handler(Seq25.numStack.drain())

class Seq25.NumStack
  stack: []

  push: (num) ->
    @stack.push(num)

  drain: () ->
    if @stack.length is 0
      num = 1
    else
      num = parseInt(@stack.join(''))
    @stack = []
    num

Seq25.numStack = new Seq25.NumStack()
