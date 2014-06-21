window.Seq25 = Ember.Application.create()

Song = Ember.Object.extend
  tempo: 120

  parts: []

  beatCounts: Ember.computed.mapBy('parts', 'beat_count')

  maxBeatCount: Ember.computed.max('beatCounts')

  schedule: ->
    for part in @get('parts')
      part.schedule(@get('tempo'))

  stop: ->
    for part in @get('parts')
      part.stop()

Seq25.Part = Ember.Object.extend
  init: ->
    @set('notes', [])
    @_super()

  name: ''
  notes: null
  beat_count: 16
  isMuted: false

  toggle: ->
    @set('isMuted', !@get('isMuted'))

  schedule: (tempo)->
    for note in @get('notes')
      note.schedule(tempo)

  stop: ->
    for note in @get('notes')
      note.stop()

  addNoteAtPoint: (position, pitch)->
    note = new Note pitch, position, @get('beat_count')
    @get('notes').addObject note

  removeNote:(note)->
    note.stop()
    @get('notes').removeObject(note)

window.song = Song.create()

Seq25.audioContext = do ->
  contextClass = 'AudioContext webkitAudioContext'.w().find (klass)->
    window[klass]
  new window[contextClass]

Seq25.Router.map ->
  @resource 'song', path: '/', ->
    @resource 'part', path: "/parts/:name"
    @resource 'parts', ->
      @route 'notes'
      @route 'instrument'

Seq25.SongRoute = Ember.Route.extend
  model: -> song

  setupController: (controller, model)->
    @controllerFor('transport').set('model', model)
    controller.set('model', model)

  redirect: ->
    @transitionTo 'parts'

Seq25.PartRoute = Ember.Route.extend
  parts: (-> @modelFor('song').get('parts')).property()

  findPart: (name)-> @get('parts').findBy 'name', name

  model: (params)->
    @set('intendedName', params.name)
    @findPart @get('intendedName')

  setupController: (controller, model)->
    unless model
      model = Seq25.Part.create name: @get('intendedName')
    unless @findPart model.get('name')
      @get('parts').addObject model
    controller.set('model', model)

Seq25.PartsIndexRoute = Ember.Route.extend
  model: ->
    'Q W E R A S D F'.w().map (name)=>
      @modelFor('song').get('parts').findBy('name', name) || Seq25.Part.create(name: name)

Seq25.PartsSummaryView = Ember.View.extend
  didInsertElement: ->
    addEventListener 'keydown', (e)=>
      return unless @get('state') == 'inDOM'
      key = String.fromCharCode(e.keyCode)
      if @get('controller').get('name') == key and not e.metaKey
        @get('controller').send('hotKey')
        e.preventDefault()

Seq25.TransportView = Ember.View.extend
  didInsertElement: ->
    addEventListener 'keydown', (e)=>
      if e.keyCode == 32
        e.preventDefault()
        @get('controller').send 'play'

  tagName: 'section'

Seq25.NumberView = Ember.TextField.extend
  type: 'number'
  attributeBindings: ['min', 'max', 'action']
  change: ->
    @triggerAction
      action: @get('action'),
      actionContext: +@get('value')

Seq25.PianoKeyView = Ember.View.extend
  attributeBindings: ['class']
  classNames: ['row']
  classNameBindings: ['isSharp']
  isSharp: (-> 'sharp' if @get('controller').get('isSharp')).property()
  tagName: 'li'

  mouseLeave: -> @get('controller').send 'stop'
  mouseUp:    -> @get('controller').send 'stop'
  mouseDown:  -> @get('controller').send 'play'

Seq25.BeatListView = Ember.CollectionView.extend
  classNames: ['measures']
  itemViewClass: Ember.View.extend
    classNames: ['measure']
    didInsertElement: ->
      beats = @get('controller').get('beat_count')
      @$().css(width: "#{100 / beats }%")

Seq25.NoteView = Ember.View.extend
  percentageOfScreen: ->
    beat_count = @get('controller').get('beat_count')
    {beat, tick} = @get('content').getProperties('beat', 'tick')
    ((beat + (tick / 96)) / beat_count) * 100

  didInsertElement: ->
    @$().css(left: "#{@percentageOfScreen()}%")

Seq25.NotesView = Ember.CollectionView.extend
  itemViewClass: Seq25.NoteView
  tagName: 'ul'
  classNames: ['notes']

Seq25.NotesEditView = Seq25.NotesView.extend
  click: (e)->
    offsetX = e.pageX - @$().offset().left
    rowWidth = @$().width()
    @get('controller').send 'addNote', (offsetX / rowWidth)

  itemViewClass: Seq25.NoteView.extend
    click: ->
      @get('controller').send 'removeNote', @get('content')
      false

Ember.Handlebars.helper 'beat-list',   Seq25.BeatListView
Ember.Handlebars.helper 'piano-key',   Seq25.PianoKeyView
Ember.Handlebars.helper 'note-list',   Seq25.NotesView
Ember.Handlebars.helper 'notes-edit',  Seq25.NotesEditView
Ember.Handlebars.helper 'number-input',Seq25.NumberView

Note = Ember.Object.extend
  init: (@pitch, position, beat_count)->
    @_super()
    beatFraction = position * beat_count
    @beat = Math.floor(beatFraction)
    @tick = Math.floor((beatFraction - @beat) * 96)

  isPitch: (pitch)->
    @get('pitchNumber') == pitch.number

  pitchNumber: (-> @get('pitch').number ).property('pitch')

  schedule: (tempo)->
    beatDuration = 60 / tempo
    start = (@get('beat') * beatDuration) + ((@get('tick') / 96) * beatDuration)
    Seq25.Osc.play(@pitch, start, 0.1)

  stop: ->
    Seq25.Osc.stop(@pitch)

class Seq25.Pitch
  noteNames = "A A# B C C# D D# E F F# G G#".w()
  a0Pitch = 27.5
  constructor: (@number)->
    @name = noteNames[(number - 21) % 12] + Math.round((number - 17) / 12)
    @freq = a0Pitch * Math.pow(2, (@number - 21)/12)
    @isSharp = @name.indexOf('#') > 0

  do ->
    pitches = for number in [45..95] #[21..108]
      new Pitch(number)
    Pitch.all = pitches.reverse()
