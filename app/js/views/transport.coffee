Seq25.TransportView = Ember.View.extend
  didInsertElement: ->
    Seq25.Keystrokes.partfn = (n) => @partForKey.call(@, n)

    Seq25.Keystrokes.registerKeyPressEvents
      "t": (n, p) => @gotoSummary.call(@)
      "g": (n, p) => @gotoPart(p)
      "m": (n, p) => @mutePart(p)
      "b": (n, p) => @changeBeatsForPart(p, "up", n)
      "x": (n, p) => @changeQuantForPart(p, n)
      "n": (n, p) => @bumpVolumeForPart(p, "up", n)

    Seq25.Keystrokes.registerKeyPressEvents
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
      @get('controller').send('addPart', part)
    else
      @get('controller').transitionToRoute('part', part)

  mutePart: (part) ->
    part?.toggle?(@get('controller').get('progress'))

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
    this.get('controller').transitionToRoute('parts')

  currentPart: ->
    @get('controller.currentPart')
