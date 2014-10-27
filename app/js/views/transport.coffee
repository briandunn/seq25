Seq25.TransportView = Ember.View.extend
  didInsertElement: ->
    Seq25.Keystrokes.partfn = (n) => @partForKey.call(@, n)

    Seq25.Keystrokes.registerKeyPressEvents
      "t": (n, p) => @gotoSummary.call(@)
      "g": (n, p) => @gotoPart(p)
      "m": (n, p) => @mutePart(p)
      "o": (n, p) => @muteAllPartsExcept(p)
      "b": (n, p) => @changeBeatsForPart(p, "up", n)
      "x": (n, p) => @changeQuantForPart(p, n)
      "n": (n, p) => @bumpVolumeForPart(p, "up", n)
      "shift+o": => @unmuteAll()
      "shift+m": => @muteAll()

    Seq25.Keystrokes.registerKeyDownEvents
      "shift+n": (n, p) => @bumpVolumeForPart(p, "down", n)
      "space":   (n, p) =>
        @get('controller').send('play')
        return true

  tagName: 'section'

  partForKey: (name) ->
    if name
      @get('controller').get("song").getPart(name) || name
    else
      @get('controller').get("song").getPart(@currentPart())

  gotoPart: (part) ->
    if /[QWERASDF]/i.test(part)
      @get('controller.controllers.songIndex').send('addPart', part)
    else
      @get('controller').transitionToRoute('part', part)

  bumpVolumeForPart: (part, direction="up", num) ->
    part.bumpVolume?(direction, num)

  changeBeatsForPart: (part, direction="up", num) ->
    if num is 1
      part.incrementProperty?("beat_count", num)
    else
      part.set?("beat_count", num)

  changeQuantForPart: (partKey, num) ->
    if num is 1
      @get('controller.controllers.part').incrementProperty("quant", num)
    else
      @get('controller.controllers.part').set("quant", num)

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
