select = ->
  {totalTicks, corners, notes} = @getProperties('corners', 'totalTicks', 'notes')
  [lowPitch, highPitch] = corners
  .map (corner)->
    Seq25.Pitch.numberAtScale(Math.max(corner.y, 0))
  .sort (a, b)-> a > b

  [firstTick, lastTick] = corners.map (corner)=>
    Math.round(corner.x * totalTicks)
  .sort (a, b)-> a > b

  boxed = notes
  .filter (note)->
    {pitchNumber, absoluteTicks, duration} = note.getProperties('pitchNumber', 'absoluteTicks', 'duration')
    (lowPitch  <= pitchNumber <= highPitch) and
    (firstTick <= absoluteTicks + duration) and
    (lastTick  >= absoluteTicks)

  @set('boxed', boxed)

EMPTY_CORNERS =
  [
    {x: 0, y: 0}
    {x: 0, y: 0}
  ]

Seq25.Selection = Em.Object.extend
  init: ->
    @setProperties
      notes: []
      selected: []
      corners: EMPTY_CORNERS
    @_super()

  toggle: (note)->
    selected = @get('selected')
    if !!selected.contains note
      selected.removeObject note
    else
      selected.pushObject note

  closeBox: ->
    @set 'corners', EMPTY_CORNERS

  only: (note)->
    selected = @get('selected')
    if selected.contains(note) && selected.length == 1
      selected.setObjects []
    else
      selected.setObjects [note]

  boxClosed: Em.computed  'corners.@each', ->
    @get('corners').reduce(((sum, corner)-> sum + corner.x + corner.y), 0) == 0

  observeBoxed: Em.observer 'boxed.[]', ->
    {isAdditive, selected, boxed} = @getProperties 'isAdditive', 'selected', 'boxed'

    if isAdditive
      selected.pushObjects boxed
    else
      selected.setObjects boxed

  observeBox: Em.observer 'corners.@each', ->
    unless @get('boxClosed')
      Em.run.debounce this, select, 25
