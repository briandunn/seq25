Seq25.NoteView = Ember.View.extend
  attributeBindings: 'style'

  startPercentage: ->
    beat_count = @get('controller.beat_count')
    {beat, tick} = @get('content').getProperties('beat', 'tick')
    ((beat + (tick / 96)) / beat_count) * 100

  durationPercentage: ->
    (@get('content.duration') / @get('controller.totalTicks')) * 100

  pitchPercentage: ->
    (Seq25.Pitch.all.indexOf(this.get('content.pitch')) / Seq25.Pitch.all.length) * 100

  style: (->
    """
    left: #{@startPercentage()}%;
    width: #{@durationPercentage()}%;
    top: calc(#{@pitchPercentage()}% + 3px);
    """
  ).property 'content.duration',
             'content.absoluteTicks',
             'content.pitchNumber',
             'controller.beat_count'

Seq25.NotesView = Ember.CollectionView.extend
  itemViewClass: Seq25.NoteView
  tagName: 'ul'
  classNames: 'notes'

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

