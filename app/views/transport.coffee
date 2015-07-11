`import Keystrokes from "seq25/models/keystrokes"`

TransportView = Ember.View.extend
  target: Em.computed.alias 'controller'
  didInsertElement: ->
    Keystrokes.partfn = (n) => @partForKey.call(@, n)

    Keystrokes.registerKeyPressEvents
      "t": (n, p) => @gotoSummary.call(@)
      "g": (n, p) => @gotoPart(p)
      "m": (n, p) => @mutePart(p)
      "o": (n, p) => @muteAllPartsExcept(p)
      "b": (n, p) => @changeBeatsForPart(p, "up", n)
      "x": (n, p) => @changeQuantForPart(p, n)
      "n": (n, p) => @bumpVolumeForPart(p, "up", n)
      "shift+o": => @unmuteAll()
      "shift+m": => @muteAll()

    Keystrokes.registerKeyDownEvents
      "shift+n": (n, p) => @bumpVolumeForPart(p, "down", n)
      "space":   (n, p) =>
        @send('play')
        return true

  tagName: 'section'

  partForKey: (name) ->
    if name
      @get('controller.song').getPart(name)
    else
      @currentPart()

  gotoPart: (nameOrPart) ->
    if /^[QWERASDF]$/i.test(nameOrPart)
      @send('addAndGotoPart', nameOrPart.capitalize())
    else
      @send('gotoPart', nameOrPart)

  bumpVolumeForPart: (part, direction="up", num) ->
    part.bumpVolume?(direction, num)

  changeBeatsForPart: (part, direction="up", num) ->
    if num is 1
      part.incrementProperty("beatCount", num)
    else
      part.set("beatCount", num)

  changeQuantForPart: (part, num) ->
    if num is 1
      @send('incrementQuant')
    else
      @send('setQuant', num)

  gotoSummary: ->
    this.get('controller').transitionToRoute('song')

  currentPart: ->
    @get('controller.currentPart')

  mutePart: (part) ->
    if part
      part.toggle?()
    else
      @muteAll()

  muteAllPartsExcept: (part) ->
    if part
      @muteAll()
      @mutePart(part)
    else
      @unmuteAll()

  unmuteAll: ->
    @get('controller').unmuteAll()

  muteAll: ->
    @get('controller').muteAll()

`export default TransportView`
