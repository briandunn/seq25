Seq25.TransportView = Ember.View.extend
  didInsertElement: ->
    Seq25.Keystrokes.bind("t", => @keyEvent( => @gotoSummary()))

    Seq25.Keystrokes.keyDownBind "space", (e) =>
      @get('controller').send('play')
      return true

    Seq25.Keystrokes.bind "g", =>
      @gotoPart(@currentPart())
    Seq25.Keystrokes.bind "m", =>
      @mutePart(@currentPart())
    Seq25.Keystrokes.bind "b", (num) =>
      @changeBeatsForPart(@currentPart(), "up", num)
    Seq25.Keystrokes.bind "x", (num) =>
      @changeQuantForPart(@currentPart(), num)
    Seq25.Keystrokes.bind "n", (num) =>
      @bumpVolumeForPart(@currentPart(), "up", num)
    Seq25.Keystrokes.bind "shift+n", (num) =>
      @bumpVolumeForPart(@currentPart(), "down", num)

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

  currentPart: ->
    @get('controller.currentPart')

