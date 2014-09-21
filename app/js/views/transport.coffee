Seq25.TransportView = Ember.View.extend
  didInsertElement: ->
    Seq25.Keystrokes.partfn = (n) => @partForKey.call(@, n)
    Seq25.Keystrokes.bind "t", => @gotoSummary.call(@)

    Seq25.Keystrokes.keyDownBind "space", (e) =>
      @get('controller').send('play')
      return true

    Seq25.Keystrokes.bind "g", (n, p) => @gotoPart(p)
    Seq25.Keystrokes.bind "m", (n, p) => @mutePart(p)
    Seq25.Keystrokes.bind "b", (n, p) => @changeBeatsForPart(p, "up", n)
    Seq25.Keystrokes.bind "x", (n, p) => @changeQuantForPart(p, n)
    Seq25.Keystrokes.bind "n", (n, p) => @bumpVolumeForPart(p, "up", n)
    Seq25.Keystrokes.keyDownBind "shift+n", (n, p) => @bumpVolumeForPart(p, "down", n)

  tagName: 'section'

  partForKey: (name) ->
    if name
      @get('controller').get("song").getPart(name) || name
    else
      @get('controller').get("song").getPart(@currentPart())

  gotoPart: (part) ->
    if /[QWERASDF]/.test(part)
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
