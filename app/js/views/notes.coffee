Seq25.NotesView = Ember.CollectionView.extend
  itemViewClass: 'note'
  tagName: 'ul'
  classNames: 'notes'

Seq25.NoteView = Ember.View.extend
  attributeBindings: ['style', 'class']

  didInsertElement: ->
    @scrollNote()

  totalTicks: Em.computed.alias 'content.part.totalTicks'

  cssAttributes: 'left width top'.w()

  left: Em.computed 'content.absoluteTicks', 'totalTicks', ->
    "#{(@get('content.absoluteTicks') / @get('totalTicks')) * 100}%"

  width: Em.computed 'content.duration', 'totalTicks', ->
    "#{(@get('content.duration') / @get('totalTicks')) * 100}%"

  top: Em.computed 'content.pitch', ->
    percentage = Seq25.Pitch.scaleAtPitch(@get('content.pitch')) * 100
    "calc(#{percentage}% + 3px)"

  scrollNote: (->
    Ember.run.scheduleOnce 'afterRender', this, ->
      window.scrollTo(10, this.element.offsetTop)
  ).observes("top")

  style: Em.computed 'left', 'width', 'top', 'height', ->
    @get('cssAttributes')
    .map (attribute)=>
      "#{attribute}: #{@get(attribute)};"
    .join ' '
