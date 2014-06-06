beats = 16
Song = Ember.Object.extend
  tempo: 480

  beats: [1..beats]

  notes: []

  startedAt: 0

  toggle: ->
    if @isPlaying() then @stop() else @play()

  elapsed: ->
    return 0 unless @isPlaying()
    @currentTime() - @get('startedAt')

  progress: ->
    @elapsed() / @get('screenDuration')

  screenDuration: (-> beats * 60 / +@get('tempo')).property('tempo')

  currentTime: -> Seq25.Pitch.context.currentTime

  loopHasEnded: -> @progress() >= 1

  isPlaying: -> @get('startedAt') > 0

  play: ->
    @set('startedAt', @currentTime())
    for note in @get('notes')
      note.schedule()
    movePlayBar = =>
      $('#play-bar').css(left: "#{@progress() * 100}%")
      return unless @isPlaying()
      if @loopHasEnded()
        @play()
      else
        requestAnimationFrame movePlayBar

    requestAnimationFrame movePlayBar

  stop: ->
    for note in @get('notes')
      note.stop()
    @set('startedAt', 0)

  addNoteAtPoint: (progress, pitch)->
    note = new Note progress, pitch
    note.schedule() if @isPlaying()
    @get('notes').addObject note

  removeNote:(note)->
    @get('notes').removeObject(note)

window.song = Song.create()

window.Seq25 = Ember.Application.create()

Seq25.Router.map ->

Seq25.IndexRoute = Ember.Route.extend
  init: ->
    song = @model()
    addEventListener 'keydown', (e)->
      if e.keyCode == 32
        e.preventDefault()
        song.toggle()

  model: -> song

Seq25.PitchController = Ember.ObjectController.extend
  notes: (->
    @get('song').get('notes').filter (note)=>
      note.isPitch @get('model')
  ).property('song.notes.@each')
  song: song
  actions:
    addNote: (time)->
      @get('song').addNoteAtPoint(time, @get('model'))
    removeNote: (note)->
      @get('song').removeNote(note)

Seq25.IndexController = Ember.ObjectController.extend
  pitches: (->
    Seq25.Pitch.all.map (pitch)-> Seq25.PitchController.create content: pitch
  ).property()
  actions:
    setTempo: (val)->
      @get('model').set 'tempo', val

Seq25.TempoView = Ember.TextField.extend
  type: 'number'
  attributeBindings: ['min', 'max']
  change: ->
    @triggerAction
      action: 'setTempo',
      actionContext: +@get('value')

Seq25.PianoKeyView = Ember.View.extend
  model: -> @get('controller').get('model')
  attributeBindings: ['class']
  classNames: ['row']
  classNameBindings: ['isSharp']
  isSharp: (-> 'sharp' if @model().isSharp).property()
  tagName: 'li'

  mouseLeave: -> @model().stop()
  mouseUp:    -> @model().stop()
  mouseDown:  -> @model().play()

Seq25.NoteListView = Ember.CollectionView.extend
  itemView: 'note'
  tagName: 'ul'
  classNames: ['notes']
  itemViewClass: Ember.View.extend
    click: ->
      @get('controller').send 'removeNote', @get('content')
      false

    didInsertElement: ->
      time = @get('content').get('start')
      @$().css(left: "#{time * 100}%")

  click: (e)->
    offsetX = e.pageX - @$().offset().left
    rowWidth = @$().width()
    @get('controller').send 'addNote', (offsetX / rowWidth)

Ember.Handlebars.helper 'piano-key', Seq25.PianoKeyView
Ember.Handlebars.helper 'note-list', Seq25.NoteListView

Note = Ember.Object.extend
  init: (@start, @pitch)->

  isPitch: (pitch)->
    @pitch.name == pitch.name

  schedule: ->
    ratio = 960.0 / song.get('tempo')
    console.log @start, song.progress()
    @pitch.play((@start - song.progress()) * ratio, (1/16) * ratio)

  stop: ->
    @pitch.stop()

class Seq25.Pitch
  noteNames = "A A# B C C# D D# E F F# G G#".split ' '
  a0Pitch = 27.5
  context = new window.AudioContext
  @context = context
  getOscilator = (freq)->
    oscillator = context.createOscillator()
    oscillator.connect context.destination
    oscillator.frequency.value = freq
    oscillator

  constructor: (@number)->
    @name = noteNames[(number - 21) % 12] + Math.round((number - 17) / 12)
    @freq = a0Pitch * Math.pow(2, (@number - 21)/12)
    @isSharp = @name.indexOf('#') > 0

  isPlaying: ->
    @oscillator?.playbackState == OscillatorNode.PLAYING_STATE

  isScheduled: ->
    @oscillator?.playbackState == OscillatorNode.SCHEDULED_STATE

  isActive: ->
    @isScheduled() or @isPlaying()

  play: (secondsFromNow=0, duration=null)->
    @oscillator = getOscilator(@freq)
    @oscillator.start context.currentTime + secondsFromNow
    @stop(secondsFromNow + duration) if duration

  stop: (secondsFromNow=0)->
    if @isActive()
      @oscillator.stop context.currentTime + secondsFromNow

  do ->
    pitches = for number in [45..95] #[21..108]
      new Pitch(number)
    Pitch.all = pitches.reverse()
