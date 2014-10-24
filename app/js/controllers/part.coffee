Seq25.PartController = Ember.ObjectController.extend
  pitches: (-> Seq25.Pitch.all).property('model')
  needs: 'transport'
  transport: Em.computed.alias('controllers.transport')
  quant: 1

  selectedNotes: []

  beats: (-> [1..@get('beat_count')] ).property('beat_count')
  parts: Em.computed.alias('controllers.transport.parts')

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

    extendNotes: (num) ->
      @changeNoteDuration(1, num)

    shortenNotes: (num) ->
      @changeNoteDuration(-1, num)

    nudgeLeft: (num) ->
      _.times(num, => @get('selectedNotes').invoke 'nudgeLeft', @get('quant'))

    nudgeRight: (num) ->
      _.times(num, => @get('selectedNotes').invoke 'nudgeRight', @get('quant'))

    createNote: ->
      note = @get('model').addNoteAtPoint(0, TOP_NOTE_ON_PIANO_ROLL=95, @get('quant'))
      @set('selectedNotes', [note])

    moveUp: (num) ->
      @get('selectedNotes').invoke 'moveUp', num

    moveDown: (num) ->
      @get('selectedNotes').invoke 'moveDown', num
