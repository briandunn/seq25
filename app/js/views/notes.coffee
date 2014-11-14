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
