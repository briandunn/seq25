#
# Abstract base classes for viewing lists of notes.
# Check out concrete implementations in notes-edit and notes-summary.
#
Seq25.NotesView = Ember.CollectionView.extend
  tagName: 'ul'
  classNames: 'notes'

Seq25.NoteView = Ember.View.extend
  attributeBindings: ['style', 'class']

  totalTicks: Em.computed.alias 'content.part.totalTicks'

  cssAttributes: 'left width top opacity'.w()

  left: Em.computed 'content.absoluteTicks', 'totalTicks', ->
    "#{(@get('content.absoluteTicks') / @get('totalTicks')) * 100}%"

  width: Em.computed 'content.duration', 'totalTicks', ->
    "#{(@get('content.duration') / @get('totalTicks')) * 100}%"

  top: Em.computed 'content.pitch', ->
    percentage = Seq25.Pitch.scaleAtPitch(@get('content.pitch')) * 100
    "calc(#{percentage}% + 3px)"

  opacity: Em.computed 'content.velocity', ->
    @get("content.velocity")

  style: Em.computed 'left', 'width', 'top', 'height', 'opacity', ->
    @get('cssAttributes')
    .map (attribute)=>
      "#{attribute}: #{@get(attribute)};"
    .join ' '
