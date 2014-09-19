class Seq25.Keystrokes
  @callbacks = {}
  @bind: (key, callback) ->
    Mousetrap.bind(key, callback)
    @callbacks[key] = callback

  @trigger: (key) ->
    @callbacks[key]()


Seq25.TransportView = Ember.View.extend
  didInsertElement: ->
    Seq25.Keystrokes.bind("t", => @keyEvent( => @gotoSummary()))

    Seq25.Keystrokes.bind("space", (e) =>
      e.preventDefault()
      @keyEvent( => @get('controller').send('play')))

    Seq25.Keystrokes.bind "g", =>
      @keyEvent( => @gotoPart(@currentPart()))
    Seq25.Keystrokes.bind "m", =>
      @keyEvent( => @mutePart(@currentPart()))
    Seq25.Keystrokes.bind "b", =>
      @keyEvent( (num) => @changeBeatsForPart(@currentPart(), "up", num))
    Seq25.Keystrokes.bind "x", =>
      @keyEvent( (num) => @changeQuantForPart(@currentPart(), num))
    Seq25.Keystrokes.bind "n", =>
      @keyEvent( (num) => @bumpVolumeForPart(@currentPart(), "up", num))
    Seq25.Keystrokes.bind "shift+n", =>
      @keyEvent( (num) => @bumpVolumeForPart(@currentPart(), "down", num))

    'q w e r a s d f'.w().forEach (partKey) =>
      Seq25.Keystrokes.bind "#{partKey} g", =>
        @keyEvent( => @gotoPart(partKey.toUpperCase()))
      Seq25.Keystrokes.bind "#{partKey} m", =>
        @keyEvent( => @mutePart(partKey.toUpperCase()))
      Seq25.Keystrokes.bind "#{partKey} b", =>
        @keyEvent( (num) => @changeBeatsForPart(partKey.toUpperCase(), "up", num))
      Seq25.Keystrokes.bind "#{partKey} x", =>
        @keyEvent( (num) => @changeQuantForPart(partKey.toUpperCase(), num))
      Seq25.Keystrokes.bind "#{partKey} n", =>
        @keyEvent( (num) => @bumpVolumeForPart(partKey.toUpperCase(), "up", num))
      Seq25.Keystrokes.bind "#{partKey} shift+n", =>
        @keyEvent( (num) => @bumpVolumeForPart(partKey.toUpperCase(), "down", num))

    '0 1 2 3 4 5 6 7 8 9'.w().forEach (number) =>
      Seq25.Keystrokes.bind(number, => Seq25.numStack.push(number))

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

  currentPart: ->
    @get('controller.currentPart')

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
