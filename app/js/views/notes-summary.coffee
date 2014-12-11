Seq25.NotesSummaryView = Seq25.NotesView.extend
  pitchNumbers: Em.computed.mapBy 'content', 'pitchNumber'
  min: Em.computed.min 'pitchNumbers'
  max: Em.computed.max 'pitchNumbers'
  range: Em.computed 'min', 'max', -> (@get('max') - @get('min')) + 1
  itemViewClass: 'noteSummary'
  createChildView: (viewClass, attrs)->
    {min, range} = @getProperties 'min', 'range'
    @_super viewClass, Em.merge(attrs, range: range, min: min)

Seq25.NoteSummaryView = Seq25.NoteView.extend
  attributeBindings: ['style', 'class']

  cssAttributes: 'left width top height opacity'.w()

  class: Em.computed.alias 'content.part.name'

  heightFraction: ->
    1 / @get('range')

  height: Em.computed ->
    "#{@heightFraction() * 100}%"

  top: Em.computed ->
    adjusted = @get('content.pitchNumber') - @get('min')
    "#{ ((1 - (adjusted / @get('range'))) - @heightFraction()) * 100 }%"

