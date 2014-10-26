Seq25.NoteView = Ember.View.extend
  attributeBindings: ['style', 'class']

  totalTicks: Em.computed.alias 'content.part.totalTicks'

  cssAttributes: 'left width top'.w()

  left: Em.computed 'content.absoluteTicks', 'totalTicks', ->
    "#{(@get('content.absoluteTicks') / @get('totalTicks')) * 100}%"

  width: Em.computed 'content.duration', 'totalTicks', ->
    "#{(@get('content.duration') / @get('totalTicks')) * 100}%"

  top: Em.computed 'content.pitch', ->
    percentage = Seq25.Pitch.scaleAtPitch(@get('content.pitch')) * 100
    "calc(#{percentage}% + 3px)"

  style: Em.computed 'left', 'width', 'top', 'height', ->
    @get('cssAttributes')
    .map (attribute)=>
      "#{attribute}: #{@get(attribute)};"
    .join ' '

Seq25.NoteSummaryView = Seq25.NoteView.extend
  attributeBindings: ['style', 'class']

  cssAttributes: 'left width top height'.w()

  class: Em.computed.alias 'content.part.name'

  heightFraction: ->
    1 / @get('range')

  height: Em.computed ->
    "#{@heightFraction() * 100}%"

  top: Em.computed ->
    adjusted = @get('content.pitchNumber') - @get('min')
    "#{ ((1 - (adjusted / @get('range'))) - @heightFraction()) * 100 }%"

Seq25.NotesView = Ember.CollectionView.extend
  itemViewClass: Seq25.NoteView
  tagName: 'ul'
  classNames: 'notes'

Seq25.NotesSummaryView = Seq25.NotesView.extend
  pitchNumbers: Em.computed.mapBy 'content', 'pitchNumber'
  min: Em.computed.min 'pitchNumbers'
  max: Em.computed.max 'pitchNumbers'
  range: Em.computed 'min', 'max', -> (@get('max') - @get('min')) + 1
  itemViewClass: Seq25.NoteSummaryView
  createChildView: (viewClass, attrs)->
    {min, range} = @getProperties 'min', 'range'
    @_super viewClass, Em.merge(attrs, range: range, min: min)

Seq25.NotesEditView = Seq25.NotesView.extend
  click: (e) ->
    $el = @$()
    offset = $el.offset()
    {pageX, pageY} = e
    position =
      x: (pageX - offset.left) / $el.width()
      y: (pageY - offset.top)  / $el.height()
    @get('controller').send 'addNote', position

  itemViewClass: 'noteEdit'

Seq25.NoteEditView = Seq25.NoteView.extend
  classNameBindings: 'isSelected:selected'
  selectedNotes: Em.computed.alias('controller.selectedNotes')

  isSelected: ( ->
    !!@get('selectedNotes').contains(@get('content'))
  ).property('selectedNotes.@each')

  click: (event) ->
    if event.shiftKey
      @toggleSelected()
    else
      @selectMeOnly()
    false

  selectMeOnly: ->
    if @get('isSelected') && @get('selectedNotes.length') == 1
      @set 'selectedNotes', []
    else
      @set 'selectedNotes', [@get('content')]

  toggleSelected: ->
    note = @get('content')
    selectedNotes = @get('selectedNotes')
    if @get('isSelected')
      selectedNotes.removeObject(note)
    else
      selectedNotes.pushObject(note)

