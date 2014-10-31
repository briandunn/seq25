relativePoint = ($el, event)->
  {pageX, pageY} = event
  {left, top} = $el.offset()
  x: (pageX - left) / $el.width()
  y: (pageY - top) / $el.height()

Seq25.NotesEditView = Seq25.NotesView.extend
  mouseDown: (down)->
    down.stopPropagation()
    startCorner = relativePoint(@$(), down)
    @mouseMove = (move)=>
      move.stopPropagation()
      @get('controller.selection').setProperties
        corners: [startCorner, relativePoint(@$(), move)]
        isAdditive: move.shiftKey

  mouseUp: (up)->
    up.stopPropagation()
    delete this.mouseMove
    if @get 'controller.selection.boxClosed'
      @get('controller').send 'addNote', relativePoint(@$(), up)

    @get('controller.selection').closeBox()

  itemViewClass: 'noteEdit'

Seq25.NoteEditView = Seq25.NoteView.extend
  classNameBindings: 'isSelected:selected'
  selectedNotes: Em.computed.alias('controller.selection.selected')

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
      selection.toggle @get('content')
    else
      selection.only @get('content')
