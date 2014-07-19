Seq25.NoteView = Ember.View.extend
  attributeBindings: ['style']
  startPercentage: ->
    beat_count = @get('controller.beat_count')
    {beat, tick} = @get('content').getProperties('beat', 'tick')
    ((beat + (tick / 96)) / beat_count) * 100

  style: (->
   "left: #{@startPercentage()}%; width: #{@durationPercentage()}%"
  ).property('content.duration', 'content.beat', 'content.tick', 'controller.totalTicks')

  durationPercentage: ->
    totalTicks = Seq25.Note.TICKS_PER_BEAT * @get('controller.beat_count')
    (@get('content.duration') / totalTicks) * 100

Seq25.NotesView = Ember.CollectionView.extend
  itemViewClass: Seq25.NoteView
  tagName: 'ul'
  classNames: ['notes']

Seq25.NotesEditView = Seq25.NotesView.extend
  click: (e) ->
    offsetX = e.pageX - @$().offset().left
    rowWidth = @$().width()
    @get('controller').send 'addNote', (offsetX / rowWidth)

  itemViewClass: 'noteEdit'

Seq25.NoteEditView = Seq25.NoteView.extend
  classNameBindings: ['isSelected:selected']
  selectedNotes: Em.computed.alias('controller.controllers.part.selectedNotes')

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

