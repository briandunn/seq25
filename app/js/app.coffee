window.Seq25 = Ember.Application.create()
Seq25.ApplicationSerializer = DS.LSSerializer.extend()
Seq25.ApplicationAdapter = DS.LSAdapter.extend namespace: 'seq25'
Seq25.audioContext = do ->
  contextClass = 'AudioContext webkitAudioContext'.w().find (klass)->
    window[klass]
  new window[contextClass]

Seq25.Router.map ->
  @resource 'parts', path: '/', ->
    @resource 'part', path: "/:name"

Seq25.ApplicationRoute = Ember.Route.extend
  model: ->
    new Ember.RSVP.Promise (resolve, reject) =>
      @store.find('song').then (songs)=>
        song = songs.get('firstObject') || @store.createRecord('song')
        @store.find('part', song: song.get('id')).then (parts)=>
          promises = parts.map (part)=>
            @store.find 'note', part: part.get('id')
          Ember.RSVP.Promise.all(promises).then =>
            resolve(song)

  setupController: (controller, model)->
    model.save()
    @controllerFor('transport').set('model', model)
    controller.set('model', model)

Seq25.PartRoute = Ember.Route.extend
  model: (params)->
    @modelFor('application').get('parts').findBy('name', params.name)

Seq25.PartsIndexRoute = Ember.Route.extend
  model: ->
    song = @modelFor('application')
    'Q W E R A S D F'.w().map (name)-> song.getPart(name)

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

Seq25.RangeView = Ember.Component.extend
  type: 'range'
  tagName: 'input'
  attributeBindings: ['type', 'min', 'max', 'step', 'action', 'value', 'id']
  change: ->
    @triggerAction
      action: @get('action'),
      actionContext: [@$().attr('id'), @$().val()]

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
