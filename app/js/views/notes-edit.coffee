relativePoint = ($el, event)->
  {pageX, pageY} = event
  {left, top} = $el.offset()
  x: (pageX - left) / $el.width()
  y: (pageY - top) / $el.height()

Seq25.NotesEditView = Seq25.NotesView.extend
  target: Em.computed.alias 'controller.controllers.selectionBox'
  isDragging: false

  mouseDown: (down)->
    down.stopPropagation()
    startCorner = relativePoint(@$(), down)
    @mouseMove = (move)=>
      move.stopPropagation()
      @set('isDragging', true)
      @send 'resize',
        [startCorner, relativePoint(@$(), move)]
        down.shiftKey

  mouseUp: (up)->
    up.stopPropagation()
    delete this.mouseMove
    if @get 'isDragging'
      @send 'resized'
      @set 'isDragging', false
    else
      @send 'addNote', relativePoint(@$(), up)

  itemViewClass: 'noteEdit'

Seq25.NoteEditView = Seq25.NoteView.extend
  target: Em.computed.alias 'controller.controllers.selectionBox'
  classNameBindings: 'isSelected:selected'
  selectedNotes: Em.computed.alias('controller.selectedNotes')

  isSelected: Em.computed 'selectedNotes.[]', ->
    @get('selectedNotes').contains @get 'content'

  noteOnScreen: ->
    top = @$().offset().top
    top > document.documentElement.scrollTop and
    top < (document.documentElement.scrollTop + window.innerHeight)

  scrollNote: (->
    Ember.run.scheduleOnce 'afterRender', this, ->
      unless @isDestroying or @noteOnScreen()
        scrollTo 10, @element.offsetTop
  ).observes("top").on 'init'

  mouseDown: (down)->
    down.stopPropagation()

  mouseUp: (up)->
    up.stopPropagation()

  click: (event) ->
    event.stopPropagation()
    @send 'toggle', [@get('content')], isAdditive: event.shiftKey
