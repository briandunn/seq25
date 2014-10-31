Seq25.PartController = Ember.ObjectController.extend
  init: ->
    @set 'selection', Seq25.Selection.create()
    @_super()
  pitches: (-> Seq25.Pitch.all).property('model')
  needs: 'transport'
  transport: Em.computed.alias('controllers.transport')
  quant: 1

  selectedNotes: Em.computed.alias 'selection.selected'

  selectionObserver: Em.observer 'notes', 'totalTicks', ->
    @get('selection').setProperties
      notes: @get('notes')
      totalTicks: @get('totalTicks')

  beats: (-> [1..@get('beat_count')] ).property('beat_count')

  partSaver: ( ->
    @get('model').save()
  ).observes('beat_count', 'volume', 'isMuted', 'notes.[]')

  noteSaver: ( ->
    @get('notes').invoke 'save'
  ).observes('notes.[]')

  positionSaver: ( ->
    @get('selectedNotes').invoke 'save'
  ).observes('selectedNotes.@each.duration',
             'selectedNotes.@each.tick',
             'selectedNotes.@each.beat',
             'selectedNotes.@each.pitchNumber')

  editResolution: (->
    q = parseInt(@get('quant')) || Seq25.Note.TICKS_PER_BEAT
    beatSlice = 1 / q
    beatSlice * Seq25.Note.TICKS_PER_BEAT
  ).property('quant')

  changeNoteDuration: (direction, num)->
    @get('selectedNotes').invoke 'changeDuration', @get('editResolution') * num * direction

  actions:
    removeNotes: ->
      @get('selectedNotes').forEach (note) =>
        @get('model').removeNote(note)

    addNote: (position)->
      @get('model').addNoteAtPoint position, @get('quant')

    extendNotes: (num) ->
      @changeNoteDuration(1, num)

    shortenNotes: (num) ->
      @changeNoteDuration(-1, num)

    nudgeLeft: (num) ->
      _.times(num, => @get('selectedNotes').invoke 'nudgeLeft', @get('quant'))

    nudgeRight: (num) ->
      _.times(num, => @get('selectedNotes').invoke 'nudgeRight', @get('quant'))

    createNote: ->
      note = @get('model').addNoteAtPoint({x: 0, y: 0}, @get('quant'))
      @set('selectedNotes', [note])

    moveUp: (num) ->
      @get('selectedNotes').invoke 'moveUp', num

    moveDown: (num) ->
      @get('selectedNotes').invoke 'moveDown', num
