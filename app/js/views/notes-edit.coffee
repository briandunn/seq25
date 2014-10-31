relativePoint = ($el, event)->
  {pageX, pageY} = event
  {left, top} = $el.offset()
  x: (pageX - left) / $el.width()
  y: (pageY - top) / $el.height()

Seq25.NotesEditView = Seq25.NotesView.extend
  isDragging: false
  mouseDown: (down)->
    down.stopPropagation()
    startCorner = relativePoint(@$(), down)
    @mouseMove = (move)=>
      move.stopPropagation()
      @set('isDragging', true)
      @get('controller').send 'selectionBoxResize',
        corners: [startCorner, relativePoint(@$(), move)]
        isAdditive: move.shiftKey

  mouseUp: (up)->
    up.stopPropagation()
    delete this.mouseMove
    if @get 'isDragging'
      @get('controller').send 'selectionBoxResized'
      @set 'isDragging', false
    else
      @get('controller').send 'addNote', relativePoint(@$(), up)

  itemViewClass: 'noteEdit'

Seq25.NoteEditView = Seq25.NoteView.extend
  classNameBindings: 'isSelected:selected'
  selectedNotes: Em.computed.alias('controller.selectedNotes')

  isSelected: Em.computed 'selectedNotes.[]', ->
    @get('selectedNotes').contains @get 'content'

  mouseDown: (down)->
    down.stopPropagation()

  mouseUp: (up)->
    up.stopPropagation()

  click: (event) ->
    event.stopPropagation()
    selection = @get('controller.selection')
    if event.shiftKey
      @get('controller').send 'selectionBoxToggle', @get('content')
    else
      @get('controller').send 'selectionBoxOnly', @get('content')
